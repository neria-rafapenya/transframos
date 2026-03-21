import {
  Controller,
  Get,
  Param,
  Query,
  UseGuards,
} from '@nestjs/common';
import { CatalogService } from './catalog.service';
import { QueryProductsDto } from './dto/query-products.dto';
import { QueryLocationsDto } from './dto/query-locations.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@UseGuards(JwtAuthGuard)
@Controller('catalog')
export class CatalogController {
  constructor(private readonly catalogService: CatalogService) {}

  @Get('products')
  async getProducts(@Query() query: QueryProductsDto) {
    return this.catalogService.getProducts(query);
  }

  @Get('products/:id')
  async getProductById(@Param('id') id: string) {
    return this.catalogService.getProductById(id);
  }

  @Get('product-families')
  async getProductFamilies() {
    return this.catalogService.getProductFamilies();
  }

  @Get('product-categories')
  async getProductCategories() {
    return this.catalogService.getProductFamilies();
  }

  @Get('vehicle-types')
  async getVehicleTypes() {
    return this.catalogService.getVehicleTypes();
  }

  @Get('cleaning-protocols')
  async getCleaningProtocols() {
    return this.catalogService.getCleaningProtocols();
  }

  @Get('locations')
  async getLocations(@Query() query: QueryLocationsDto) {
    return this.catalogService.getLocations(query);
  }

  @Get('loading-points')
  async getLoadingPoints(@Query() query: QueryLocationsDto) {
    return this.catalogService.getLoadingPoints(query);
  }

  @Get('unloading-points')
  async getUnloadingPoints(@Query() query: QueryLocationsDto) {
    return this.catalogService.getUnloadingPoints(query);
  }

  @Get('locations/:id')
  async getLocationById(@Param('id') id: string) {
    return this.catalogService.getLocationById(id);
  }

  @Get('compatibility-rules')
  async getCompatibilityRules() {
    return this.catalogService.getCompatibilityRules();
  }
}
