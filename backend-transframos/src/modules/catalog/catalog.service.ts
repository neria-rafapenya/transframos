import { Injectable, NotFoundException } from '@nestjs/common';
import { CatalogRepository } from './repositories/catalog.repository';
import { QueryProductsDto } from './dto/query-products.dto';
import { QueryLocationsDto } from './dto/query-locations.dto';

@Injectable()
export class CatalogService {
  constructor(private readonly catalogRepository: CatalogRepository) {}

  async getProducts(query: QueryProductsDto) {
    return this.catalogRepository.findProducts(query);
  }

  async getProductById(id: string) {
    const product = await this.catalogRepository.findProductById(id);

    if (!product) {
      throw new NotFoundException(`No existe ningún producto con id ${id}`);
    }

    return product;
  }

  async getProductFamilies() {
    return this.catalogRepository.findProductCategories();
  }

  async getVehicleTypes() {
    const vehicles = await this.catalogRepository.findVehicles(true);
    const codes = Array.from(
      new Set(vehicles.map((vehicle) => vehicle.vehicleTypeCode)),
    );

    return codes.map((code) => ({ code }));
  }

  async getCleaningProtocols() {
    return [];
  }

  async getLocations(query: QueryLocationsDto) {
    return this.catalogRepository.findLocations(query);
  }

  async getLoadingPoints(query: QueryLocationsDto) {
    return this.catalogRepository.findLoadingPoints(query);
  }

  async getUnloadingPoints(query: QueryLocationsDto) {
    return this.catalogRepository.findUnloadingPoints(query);
  }

  async getLocationById(id: string) {
    const location = await this.catalogRepository.findLocationById(id);

    if (!location) {
      throw new NotFoundException(
        `No existe ninguna localización con id ${id}`,
      );
    }

    return location;
  }

  async getCompatibilityRules() {
    return this.catalogRepository.findProductCompatibilityRules();
  }

  async getSandboxSnapshot() {
    const [
      products,
      productCategories,
      vehicles,
      vehicleAvailability,
      tanks,
      tankAuthorizations,
      vehicleTanks,
      routes,
      vehicleRoutes,
      routeWaypoints,
      loadingPoints,
      unloadingPoints,
      compatibilityRules,
    ] = await Promise.all([
      this.catalogRepository.findProducts({}),
      this.catalogRepository.findProductCategories(),
      this.catalogRepository.findAllVehicles(),
      this.catalogRepository.findAllVehicleAvailability(),
      this.catalogRepository.findAllTanks(),
      this.catalogRepository.findAllTankAuthorizations(),
      this.catalogRepository.findAllVehicleTanks(),
      this.catalogRepository.findAllRoutes(),
      this.catalogRepository.findAllVehicleRoutes(),
      this.catalogRepository.findAllRouteWaypoints(),
      this.catalogRepository.findLoadingPoints({}),
      this.catalogRepository.findUnloadingPoints({}),
      this.catalogRepository.findProductCompatibilityRules(),
    ]);

    return {
      products,
      productCategories,
      vehicles,
      vehicleAvailability,
      tanks,
      tankAuthorizations,
      vehicleTanks,
      routes,
      vehicleRoutes,
      routeWaypoints,
      loadingPoints,
      unloadingPoints,
      compatibilityRules,
    };
  }
}
