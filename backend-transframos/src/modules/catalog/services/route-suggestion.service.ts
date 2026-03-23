import { Injectable } from '@nestjs/common';
import { CatalogRepository } from '../repositories/catalog.repository';
import { LlmService } from '../../llm/llm.service';
import { RouteEntity } from '../entities/route.entity';

export type RouteSuggestionResult = {
  routeCode: string | null;
  confidence: number | null;
  rationale: string | null;
  alternativeRouteCodes: string[];
};

@Injectable()
export class RouteSuggestionService {
  constructor(
    private readonly catalogRepository: CatalogRepository,
    private readonly llmService: LlmService,
  ) {}

  async suggestRoute(params: {
    originText: string | null | undefined;
    destinationText: string | null | undefined;
    userId?: string | null;
  }): Promise<{
    route: RouteEntity | null;
    suggestion: RouteSuggestionResult | null;
  }> {
    const originText = params.originText?.trim();
    const destinationText = params.destinationText?.trim();

    if (!originText || !destinationText) {
      return { route: null, suggestion: null };
    }

    const [routes, loadingPoints, unloadingPoints, waypoints] =
      await Promise.all([
        this.catalogRepository.findAllRoutes(),
        this.catalogRepository.findLoadingPoints({}),
        this.catalogRepository.findUnloadingPoints({}),
        this.catalogRepository.findAllRouteWaypoints(),
      ]);

    if (routes.length === 0) {
      return { route: null, suggestion: null };
    }

    const loadingById = new Map(
      loadingPoints.map((item) => [item.id, item]),
    );
    const unloadingById = new Map(
      unloadingPoints.map((item) => [item.id, item]),
    );

    const waypointsByRouteId = new Map<string, string[]>();
    for (const waypoint of waypoints) {
      const label = waypoint.city || waypoint.waypointName;
      if (!label) continue;
      const list = waypointsByRouteId.get(waypoint.routeId) ?? [];
      list.push(label);
      waypointsByRouteId.set(waypoint.routeId, list);
    }

    const routeSummaries = routes.map((route) => {
      const originPointId = route.originLoadingPointId ?? null;
      const destinationPointId = route.destinationUnloadingPointId ?? null;

      const originPoint = originPointId
        ? loadingById.get(originPointId)
        : undefined;
      const destinationPoint = destinationPointId
        ? unloadingById.get(destinationPointId)
        : undefined;
      const waypointCities = waypointsByRouteId.get(route.id) ?? [];

      const cities = [
        originPoint?.city ?? originPoint?.name ?? route.name,
        ...waypointCities,
        destinationPoint?.city ?? destinationPoint?.name ?? route.name,
      ]
        .filter(Boolean)
        .map((city) => String(city));

      const uniqueCities = Array.from(new Set(cities));

      return {
        code: route.code,
        name: route.name,
        cities: uniqueCities,
      };
    });

    const routeList = routeSummaries
      .map(
        (item) =>
          `- ${item.code}: ${item.name}. Ciudades en ruta: ${item.cities.join(
            ', ',
          )}`,
      )
      .join('\n');

    const prompt = `
Eres un planificador de rutas para transporte por carretera.

Debes elegir la mejor ruta del catálogo usando solo las rutas listadas.
La selección debe basarse en cercanía y en si las ciudades de origen/destino están en el trayecto.
Si la ciudad no aparece literalmente en la lista de ciudades, puedes elegir la ruta si la ciudad está
geográficamente en el corredor entre origen y destino de esa ruta (conocimiento general).
Si hay varias opciones válidas, devuelve la mejor y añade hasta 2 alternativas.
Si ninguna encaja, devuelve routeCode = null.

Devuelve EXCLUSIVAMENTE JSON válido con este formato:
{
  "routeCode": "CODIGO" | null,
  "confidence": 0.0,
  "rationale": "texto breve",
  "alternativeRouteCodes": ["CODIGO", "CODIGO"]
}

Origen usuario: ${originText}
Destino usuario: ${destinationText}

Rutas del catálogo:
${routeList}
`.trim();

    const response = await this.llmService.generateText(
      {
        prompt,
        actionType: 'route_suggestion',
        temperature: 0.1,
        max_output_tokens: 500,
      },
      params.userId ?? null,
    );

    const suggestion = this.parseSuggestion(response.text);
    if (!suggestion?.routeCode) {
      return { route: null, suggestion };
    }

    const selectedRoute =
      routes.find((route) => route.code === suggestion.routeCode) ?? null;

    return { route: selectedRoute, suggestion };
  }

  private parseSuggestion(text: string): RouteSuggestionResult | null {
    try {
      const start = text.indexOf('{');
      const end = text.lastIndexOf('}');
      if (start === -1 || end === -1) {
        return null;
      }

      const parsed = JSON.parse(text.slice(start, end + 1)) as {
        routeCode?: string | null;
        confidence?: number | null;
        rationale?: string | null;
        alternativeRouteCodes?: string[] | null;
      };

      const rawRouteCode =
        typeof parsed.routeCode === 'string'
          ? parsed.routeCode.trim().toUpperCase()
          : null;

      const routeCode =
        rawRouteCode && rawRouteCode !== 'NULL' && rawRouteCode !== 'NONE'
          ? rawRouteCode
          : null;

      return {
        routeCode,
        confidence:
          typeof parsed.confidence === 'number' ? parsed.confidence : null,
        rationale:
          typeof parsed.rationale === 'string' ? parsed.rationale : null,
        alternativeRouteCodes: Array.isArray(parsed.alternativeRouteCodes)
          ? Array.from(
              new Set(
                parsed.alternativeRouteCodes
                  .filter((item) => typeof item === 'string')
                  .map((item) => item.trim().toUpperCase())
                  .filter((item) => item.length > 0 && item !== routeCode),
              ),
            )
          : [],
      };
    } catch {
      return null;
    }
  }
}
