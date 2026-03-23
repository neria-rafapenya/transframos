import {
  BadRequestException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import * as bcrypt from 'bcrypt';
import { ClientType } from '../../common/enums/client-type.enum';
import { UserRole } from '../../common/enums/user-role.enum';
import type { JwtPayload } from '../../common/interfaces/jwt-payload.interface';
import { CreateUserDto } from './dto/create-user.dto';
import { QueryUsersDto } from './dto/query-users.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { UserResponseDto } from './dto/user-response.dto';
import { User } from './entities/user.entity';
import { UsersRepository } from './repositories/users.repository';

@Injectable()
export class UsersService {
  constructor(private readonly usersRepository: UsersRepository) {}

  private toResponse(user: User): UserResponseDto {
    return {
      id: user.id,
      email: user.email,
      fullName: user.fullName,
      role: user.role,
      clientType: user.clientType,
      clientId: user.clientId ?? null,
      isActive: user.isActive,
      dni: user.dni ?? null,
      nif: user.nif ?? null,
      companyName: user.companyName ?? null,
      companyHqAddress: user.companyHqAddress ?? null,
      contactName: user.contactName ?? null,
      contactPhone: user.contactPhone ?? null,
      contactPhoneAlt: user.contactPhoneAlt ?? null,
      contactEmail: user.contactEmail ?? null,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    };
  }

  private async createUser(params: {
    email: string;
    password: string;
    fullName: string;
    role: UserRole;
    clientType: ClientType;
    isActive: boolean;
    dni?: string;
    nif?: string;
    companyName?: string;
    companyHqAddress?: string;
    contactName?: string;
    contactPhone?: string;
    contactPhoneAlt?: string;
    contactEmail?: string;
  }): Promise<User> {
    const existing = await this.usersRepository.findByEmail(params.email);

    if (existing) {
      throw new BadRequestException('Ya existe un usuario con ese email');
    }

    const passwordHash = await bcrypt.hash(params.password, 10);

    const user = this.usersRepository.create({
      email: params.email.toLowerCase(),
      passwordHash,
      fullName: params.fullName,
      role: params.role,
      clientType: params.clientType,
      isActive: params.isActive,
      dni: params.dni ?? null,
      nif: params.nif ?? null,
      companyName: params.companyName ?? null,
      companyHqAddress: params.companyHqAddress ?? null,
      contactName: params.contactName ?? null,
      contactPhone: params.contactPhone ?? null,
      contactPhoneAlt: params.contactPhoneAlt ?? null,
      contactEmail: params.contactEmail ?? null,
    });

    return this.usersRepository.save(user);
  }

  async create(dto: CreateUserDto): Promise<UserResponseDto> {
    const saved = await this.createUser({
      email: dto.email,
      password: dto.password,
      fullName: dto.fullName,
      role: dto.role ?? UserRole.CLIENT,
      clientType: dto.clientType ?? ClientType.FIDELIZADO,
      isActive: dto.isActive ?? true,
      dni: dto.dni,
      nif: dto.nif,
      companyName: dto.companyName,
      companyHqAddress: dto.companyHqAddress,
      contactName: dto.contactName,
      contactPhone: dto.contactPhone,
      contactPhoneAlt: dto.contactPhoneAlt,
      contactEmail: dto.contactEmail,
    });

    return this.toResponse(saved);
  }

  async registerClient(params: {
    email: string;
    password: string;
    fullName: string;
  }): Promise<User> {
    return this.createUser({
      email: params.email,
      password: params.password,
      fullName: params.fullName,
      role: UserRole.CLIENT,
      clientType: ClientType.NUEVO,
      isActive: true,
    });
  }

  async findAll(query: QueryUsersDto): Promise<{
    data: UserResponseDto[];
    total: number;
    page: number;
    limit: number;
  }> {
    const page = query.page ?? 1;
    const limit = query.limit ?? 20;
    const { data, total } = await this.usersRepository.findAll(query);

    return {
      data: data.map((item) => this.toResponse(item)),
      total,
      page,
      limit,
    };
  }

  async findById(id: string): Promise<User> {
    const user = await this.usersRepository.findById(id);

    if (!user) {
      throw new NotFoundException('Usuario no encontrado');
    }

    return user;
  }

  async assignClientId(id: string, clientId: string | null): Promise<User> {
    const user = await this.findById(id);
    user.clientId = clientId;
    return this.usersRepository.save(user);
  }

  async findResponseById(
    id: string,
    currentUser: JwtPayload,
  ): Promise<UserResponseDto> {
    const canAccess =
      currentUser.role === UserRole.ADMIN || currentUser.sub === id;

    if (!canAccess) {
      throw new ForbiddenException('No puedes consultar este usuario');
    }

    const user = await this.findById(id);
    return this.toResponse(user);
  }

  async update(
    id: string,
    dto: UpdateUserDto,
    currentUser: JwtPayload,
  ): Promise<UserResponseDto> {
    const user = await this.findById(id);
    const isAdmin = currentUser.role === UserRole.ADMIN;
    const isSelf = currentUser.sub === id;

    if (!isAdmin && !isSelf) {
      throw new ForbiddenException('No puedes modificar este usuario');
    }

    if (dto.email && dto.email !== user.email) {
      const existing = await this.usersRepository.findByEmail(dto.email);

      if (existing && existing.id !== user.id) {
        throw new BadRequestException('Ya existe un usuario con ese email');
      }

      user.email = dto.email.toLowerCase();
    }

    if (dto.fullName) {
      user.fullName = dto.fullName;
    }

    if (typeof dto.dni === 'string') {
      user.dni = dto.dni;
    }

    if (typeof dto.nif === 'string') {
      user.nif = dto.nif;
    }

    if (typeof dto.companyName === 'string') {
      user.companyName = dto.companyName;
    }

    if (typeof dto.companyHqAddress === 'string') {
      user.companyHqAddress = dto.companyHqAddress;
    }

    if (typeof dto.contactName === 'string') {
      user.contactName = dto.contactName;
    }

    if (typeof dto.contactPhone === 'string') {
      user.contactPhone = dto.contactPhone;
    }

    if (typeof dto.contactPhoneAlt === 'string') {
      user.contactPhoneAlt = dto.contactPhoneAlt;
    }

    if (typeof dto.contactEmail === 'string') {
      user.contactEmail = dto.contactEmail;
    }

    if (typeof dto.isActive === 'boolean') {
      if (!isAdmin) {
        throw new ForbiddenException(
          'Solo un admin puede cambiar el estado activo',
        );
      }

      user.isActive = dto.isActive;
    }

    if (dto.role) {
      if (!isAdmin) {
        throw new ForbiddenException('Solo un admin puede cambiar el rol');
      }

      user.role = dto.role;
    }

    if (dto.clientType) {
      if (!isAdmin) {
        throw new ForbiddenException(
          'Solo un admin puede cambiar el tipo de cliente',
        );
      }

      user.clientType = dto.clientType;
    }

    if (dto.password) {
      user.passwordHash = await bcrypt.hash(dto.password, 10);
    }

    const saved = await this.usersRepository.save(user);
    return this.toResponse(saved);
  }

  async remove(id: string): Promise<void> {
    const user = await this.findById(id);
    await this.usersRepository.remove(user);
  }

  async validateUser(email: string, password: string): Promise<User> {
    const user = await this.usersRepository.findByEmail(email.toLowerCase());

    if (!user) {
      throw new BadRequestException('Credenciales incorrectas');
    }

    if (!user.isActive) {
      throw new ForbiddenException('El usuario está inactivo');
    }

    const isValidPassword = await bcrypt.compare(password, user.passwordHash);

    if (!isValidPassword) {
      throw new BadRequestException('Credenciales incorrectas');
    }

    return user;
  }

  async findActiveUserById(id: string): Promise<User> {
    const user = await this.usersRepository.findById(id);

    if (!user || !user.isActive) {
      throw new NotFoundException('Usuario no encontrado o inactivo');
    }

    return user;
  }

  toUserResponse(user: User): UserResponseDto {
    return this.toResponse(user);
  }
}
