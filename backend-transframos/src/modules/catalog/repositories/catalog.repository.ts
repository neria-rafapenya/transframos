import { Injectable } from '@nestjs/common';
import { randomUUID } from 'crypto';
import { InjectRepository } from '@nestjs/typeorm';
import { In, Repository } from 'typeorm';
import { ProductEntity } from '../entities/product.entity';
import { ProductCategoryEntity } from '../entities/product-category.entity';
import { ProductCompatibilityRuleEntity } from '../entities/product-compatibility-rule.entity';
import { VehicleEntity } from '../entities/vehicle.entity';
import { VehicleAvailabilityEntity } from '../entities/vehicle-availability.entity';
import { LoadingPointEntity } from '../entities/loading-point.entity';
import { UnloadingPointEntity } from '../entities/unloading-point.entity';
import { RouteEntity } from '../entities/route.entity';
import { RouteWaypointEntity } from '../entities/route-waypoint.entity';
import { TankEntity } from '../entities/tank.entity';
import { TankProductAuthorizationEntity } from '../entities/tank-product-authorization.entity';
import { VehicleTankEntity } from '../entities/vehicle-tank.entity';
import { VehicleRouteEntity } from '../entities/vehicle-route.entity';
import { QueryProductsDto } from '../dto/query-products.dto';
import { QueryLocationsDto } from '../dto/query-locations.dto';

@Injectable()
export class CatalogRepository {
  constructor(
    @InjectRepository(ProductEntity)
    private readonly productRepository: Repository<ProductEntity>,
    @InjectRepository(ProductCategoryEntity)
    private readonly productCategoryRepository: Repository<ProductCategoryEntity>,
    @InjectRepository(ProductCompatibilityRuleEntity)
    private readonly productCompatibilityRepository: Repository<ProductCompatibilityRuleEntity>,
    @InjectRepository(VehicleEntity)
    private readonly vehicleRepository: Repository<VehicleEntity>,
    @InjectRepository(VehicleAvailabilityEntity)
    private readonly vehicleAvailabilityRepository: Repository<VehicleAvailabilityEntity>,
    @InjectRepository(LoadingPointEntity)
    private readonly loadingPointRepository: Repository<LoadingPointEntity>,
    @InjectRepository(UnloadingPointEntity)
    private readonly unloadingPointRepository: Repository<UnloadingPointEntity>,
    @InjectRepository(RouteEntity)
    private readonly routeRepository: Repository<RouteEntity>,
    @InjectRepository(RouteWaypointEntity)
    private readonly routeWaypointRepository: Repository<RouteWaypointEntity>,
    @InjectRepository(TankEntity)
    private readonly tankRepository: Repository<TankEntity>,
    @InjectRepository(TankProductAuthorizationEntity)
    private readonly tankAuthorizationRepository: Repository<TankProductAuthorizationEntity>,
    @InjectRepository(VehicleTankEntity)
    private readonly vehicleTankRepository: Repository<VehicleTankEntity>,
    @InjectRepository(VehicleRouteEntity)
    private readonly vehicleRouteRepository: Repository<VehicleRouteEntity>,
  ) {}

  async findProducts(query: QueryProductsDto) {
    const qb = this.productRepository
      .createQueryBuilder('product')
      .leftJoinAndSelect('product.category', 'category')
      .orderBy('product.name', 'ASC');

    if (query.search?.trim()) {
      qb.andWhere(
        '(product.name LIKE :search OR product.code LIKE :search OR product.commercialName LIKE :search)',
        { search: `%${query.search.trim()}%` },
      );
    }

    const categoryId = query.categoryId ?? query.familyId;
    if (categoryId) {
      qb.andWhere('product.categoryId = :categoryId', { categoryId });
    }

    if (typeof query.isActive !== 'undefined') {
      qb.andWhere('product.isActive = :isActive', { isActive: query.isActive });
    }

    return qb.getMany();
  }

  async findProductById(id: string) {
    return this.productRepository.findOne({
      where: { id },
      relations: {
        category: true,
      },
    });
  }

  async findProductByText(text: string) {
    const trimmed = text.trim();
    if (!trimmed) {
      return null;
    }

    return this.productRepository
      .createQueryBuilder('product')
      .leftJoinAndSelect('product.category', 'category')
      .where(
        '(product.name LIKE :search OR product.code LIKE :search OR product.commercialName LIKE :search)',
        { search: `%${trimmed}%` },
      )
      .andWhere('product.isActive = :isActive', { isActive: true })
      .orderBy('product.name', 'ASC')
      .getOne();
  }

  async findProductsByIds(ids: string[]) {
    if (ids.length === 0) {
      return [];
    }

    return this.productRepository.find({
      where: {
        id: In(ids),
      },
    });
  }

  async findProductCategories() {
    return this.productCategoryRepository.find({
      order: {
        name: 'ASC',
      },
    });
  }

  async findProductCompatibilityRules() {
    return this.productCompatibilityRepository.find({
      order: {
        id: 'ASC',
      },
    });
  }

  async findVehicles(isActive = true) {
    return this.vehicleRepository.find({
      where: { isActive },
      order: {
        code: 'ASC',
      },
    });
  }

  async findAllVehicles() {
    return this.vehicleRepository.find({
      order: {
        code: 'ASC',
      },
    });
  }

  async findVehicleById(id: string) {
    return this.vehicleRepository.findOne({
      where: { id },
    });
  }

  async findAllVehicleAvailability() {
    return this.vehicleAvailabilityRepository.find({
      order: {
        availabilityDate: 'ASC',
      },
    });
  }

  async findVehicleAvailabilityByDate(date: string) {
    return this.vehicleAvailabilityRepository.find({
      where: {
        availabilityDate: date,
        available: true,
      },
    });
  }

  async findVehicleAvailabilityByVehicleIds(vehicleIds: string[]) {
    if (vehicleIds.length === 0) {
      return [];
    }

    return this.vehicleAvailabilityRepository.find({
      where: {
        vehicleId: In(vehicleIds),
        available: true,
      },
      order: {
        availabilityDate: 'ASC',
      },
    });
  }

  async findLoadingPoints(query: QueryLocationsDto) {
    const qb = this.loadingPointRepository
      .createQueryBuilder('point')
      .orderBy('point.name', 'ASC');

    if (query.search?.trim()) {
      qb.andWhere(
        '(point.name LIKE :search OR point.code LIKE :search OR point.city LIKE :search OR point.postalCode LIKE :search)',
        { search: `%${query.search.trim()}%` },
      );
    }

    if (query.countryCode?.trim()) {
      qb.andWhere('point.countryCode = :countryCode', {
        countryCode: query.countryCode.trim().toUpperCase(),
      });
    }

    if (query.province?.trim()) {
      qb.andWhere('point.city LIKE :city', {
        city: `%${query.province.trim()}%`,
      });
    }

    if (typeof query.isActive !== 'undefined') {
      qb.andWhere('point.isActive = :isActive', { isActive: query.isActive });
    }

    return qb.getMany();
  }

  async findLoadingPointById(id: string) {
    return this.loadingPointRepository.findOne({
      where: { id },
    });
  }

  async findLoadingPointByText(text: string) {
    const trimmed = text.trim();
    if (!trimmed) {
      return null;
    }

    return this.loadingPointRepository
      .createQueryBuilder('point')
      .where(
        '(point.name LIKE :search OR point.code LIKE :search OR point.city LIKE :search OR point.postalCode LIKE :search)',
        { search: `%${trimmed}%` },
      )
      .andWhere('point.isActive = :isActive', { isActive: true })
      .orderBy('point.name', 'ASC')
      .getOne();
  }

  async findUnloadingPoints(query: QueryLocationsDto) {
    const qb = this.unloadingPointRepository
      .createQueryBuilder('point')
      .orderBy('point.name', 'ASC');

    if (query.search?.trim()) {
      qb.andWhere(
        '(point.name LIKE :search OR point.code LIKE :search OR point.city LIKE :search OR point.postalCode LIKE :search)',
        { search: `%${query.search.trim()}%` },
      );
    }

    if (query.countryCode?.trim()) {
      qb.andWhere('point.countryCode = :countryCode', {
        countryCode: query.countryCode.trim().toUpperCase(),
      });
    }

    if (query.province?.trim()) {
      qb.andWhere('point.city LIKE :city', {
        city: `%${query.province.trim()}%`,
      });
    }

    if (typeof query.isActive !== 'undefined') {
      qb.andWhere('point.isActive = :isActive', { isActive: query.isActive });
    }

    return qb.getMany();
  }

  async findUnloadingPointById(id: string) {
    return this.unloadingPointRepository.findOne({
      where: { id },
    });
  }

  async findUnloadingPointByText(text: string) {
    const trimmed = text.trim();
    if (!trimmed) {
      return null;
    }

    return this.unloadingPointRepository
      .createQueryBuilder('point')
      .where(
        '(point.name LIKE :search OR point.code LIKE :search OR point.city LIKE :search OR point.postalCode LIKE :search)',
        { search: `%${trimmed}%` },
      )
      .andWhere('point.isActive = :isActive', { isActive: true })
      .orderBy('point.name', 'ASC')
      .getOne();
  }

  async createLoadingPoint(params: {
    code: string;
    name: string;
    countryCode: string;
    city: string;
    addressLine1: string;
    postalCode?: string | null;
    latitude?: number | null;
    longitude?: number | null;
    clientId?: string | null;
    notes?: string | null;
  }) {
    const entity = this.loadingPointRepository.create({
      id: randomUUID(),
      code: params.code,
      name: params.name,
      countryCode: params.countryCode,
      city: params.city,
      addressLine1: params.addressLine1,
      postalCode: params.postalCode ?? null,
      latitude:
        typeof params.latitude === 'number' ? params.latitude : null,
      longitude:
        typeof params.longitude === 'number' ? params.longitude : null,
      clientId: params.clientId ?? null,
      notes: params.notes ?? null,
      isActive: true,
      requiresPrealert: false,
    });

    return this.loadingPointRepository.save(entity);
  }

  async createUnloadingPoint(params: {
    code: string;
    name: string;
    countryCode: string;
    city: string;
    addressLine1: string;
    postalCode?: string | null;
    latitude?: number | null;
    longitude?: number | null;
    clientId?: string | null;
    notes?: string | null;
  }) {
    const entity = this.unloadingPointRepository.create({
      id: randomUUID(),
      code: params.code,
      name: params.name,
      countryCode: params.countryCode,
      city: params.city,
      addressLine1: params.addressLine1,
      postalCode: params.postalCode ?? null,
      latitude:
        typeof params.latitude === 'number' ? params.latitude : null,
      longitude:
        typeof params.longitude === 'number' ? params.longitude : null,
      clientId: params.clientId ?? null,
      notes: params.notes ?? null,
      isActive: true,
      requiresPrealert: false,
    });

    return this.unloadingPointRepository.save(entity);
  }

  async findLocations(query: QueryLocationsDto) {
    if (query.pointType === 'loading') {
      return this.findLoadingPoints(query);
    }

    if (query.pointType === 'unloading') {
      return this.findUnloadingPoints(query);
    }

    const [loading, unloading] = await Promise.all([
      this.findLoadingPoints(query),
      this.findUnloadingPoints(query),
    ]);

    return [...loading, ...unloading];
  }

  async findLocationById(id: string) {
    const loading = await this.loadingPointRepository.findOne({
      where: { id },
    });

    if (loading) {
      return loading;
    }

    return this.unloadingPointRepository.findOne({
      where: { id },
    });
  }

  async findRouteByPoints(
    originLoadingPointId: string,
    destinationUnloadingPointId: string,
  ) {
    return this.routeRepository.findOne({
      where: {
        originLoadingPointId,
        destinationUnloadingPointId,
        isActive: true,
      },
    });
  }

  async findRouteById(id: string) {
    return this.routeRepository.findOne({
      where: { id },
    });
  }

  async findAllRoutes() {
    return this.routeRepository.find({
      order: {
        code: 'ASC',
      },
    });
  }

  async findAllRouteWaypoints() {
    return this.routeWaypointRepository.find({
      order: {
        routeId: 'ASC',
        sequenceNo: 'ASC',
      },
    });
  }

  async findAllTanks() {
    return this.tankRepository.find({
      order: {
        code: 'ASC',
      },
    });
  }

  async findAllTankAuthorizations() {
    return this.tankAuthorizationRepository.find({
      order: {
        id: 'ASC',
      },
    });
  }

  async findAllVehicleTanks() {
    return this.vehicleTankRepository.find({
      order: {
        vehicleId: 'ASC',
      },
    });
  }

  async findAuthorizedTanks(params: {
    productId?: string | null;
    categoryId?: string | null;
    date?: string | null;
  }) {
    if (!params.productId && !params.categoryId) {
      return [];
    }

    const qb = this.tankAuthorizationRepository
      .createQueryBuilder('authorization')
      .where('authorization.allowed = :allowed', { allowed: true });

    if (params.productId && params.categoryId) {
      qb.andWhere(
        '(authorization.productId = :productId OR authorization.categoryId = :categoryId)',
        {
          productId: params.productId,
          categoryId: params.categoryId,
        },
      );
    } else if (params.productId) {
      qb.andWhere('authorization.productId = :productId', {
        productId: params.productId,
      });
    } else if (params.categoryId) {
      qb.andWhere('authorization.categoryId = :categoryId', {
        categoryId: params.categoryId,
      });
    }

    if (params.date) {
      qb.andWhere(
        '(authorization.validFrom IS NULL OR authorization.validFrom <= :date) AND (authorization.validTo IS NULL OR authorization.validTo >= :date)',
        { date: params.date },
      );
    }

    const authorizations = await qb.getMany();
    const tankIds = authorizations.map((item) => item.tankId);

    if (tankIds.length === 0) {
      return [];
    }

    return this.tankRepository.find({
      where: {
        id: In(tankIds),
        isActive: true,
      },
    });
  }

  async findVehicleTankLinks(params: {
    tankIds?: string[];
    vehicleIds?: string[];
    date?: string | null;
    onlyActive?: boolean;
  }) {
    const qb = this.vehicleTankRepository.createQueryBuilder('link');

    if (params.tankIds && params.tankIds.length > 0) {
      qb.andWhere('link.tankId IN (:...tankIds)', {
        tankIds: params.tankIds,
      });
    }

    if (params.vehicleIds && params.vehicleIds.length > 0) {
      qb.andWhere('link.vehicleId IN (:...vehicleIds)', {
        vehicleIds: params.vehicleIds,
      });
    }

    if (params.onlyActive !== false) {
      qb.andWhere('link.isActive = :isActive', { isActive: true });
    }

    if (params.date) {
      qb.andWhere(
        '(link.validFrom IS NULL OR link.validFrom <= :date) AND (link.validTo IS NULL OR link.validTo >= :date)',
        { date: params.date },
      );
    }

    return qb.getMany();
  }

  async findVehicleRouteLinks(params: {
    routeId?: string;
    vehicleIds?: string[];
    date?: string | null;
    onlyActive?: boolean;
  }) {
    const qb = this.vehicleRouteRepository.createQueryBuilder('link');

    if (params.routeId) {
      qb.andWhere('link.routeId = :routeId', { routeId: params.routeId });
    }

    if (params.vehicleIds && params.vehicleIds.length > 0) {
      qb.andWhere('link.vehicleId IN (:...vehicleIds)', {
        vehicleIds: params.vehicleIds,
      });
    }

    if (params.onlyActive !== false) {
      qb.andWhere('link.isActive = :isActive', { isActive: true });
    }

    if (params.date) {
      qb.andWhere(
        '(link.validFrom IS NULL OR link.validFrom <= :date) AND (link.validTo IS NULL OR link.validTo >= :date)',
        { date: params.date },
      );
    }

    return qb.getMany();
  }

  async findAllVehicleRoutes() {
    return this.vehicleRouteRepository.find({
      order: {
        routeId: 'ASC',
      },
    });
  }
}
