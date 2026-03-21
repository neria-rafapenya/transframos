import {
  BadRequestException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import * as bcrypt from 'bcrypt';
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
      isActive: user.isActive,
      createdAt: user.createdAt,
      updatedAt: user.updatedAt,
    };
  }

  async create(dto: CreateUserDto): Promise<UserResponseDto> {
    const existing = await this.usersRepository.findByEmail(dto.email);

    if (existing) {
      throw new BadRequestException('Ya existe un usuario con ese email');
    }

    const passwordHash = await bcrypt.hash(dto.password, 10);

    const user = this.usersRepository.create({
      email: dto.email.toLowerCase(),
      passwordHash,
      fullName: dto.fullName,
      role: dto.role ?? UserRole.CLIENT,
      isActive: dto.isActive ?? true,
    });

    const saved = await this.usersRepository.save(user);
    return this.toResponse(saved);
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
