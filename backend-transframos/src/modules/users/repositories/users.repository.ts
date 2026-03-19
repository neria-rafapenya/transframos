import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { FindOptionsWhere, ILike, Repository } from 'typeorm';
import { User } from '../entities/user.entity';
import { QueryUsersDto } from '../dto/query-users.dto';

@Injectable()
export class UsersRepository {
  constructor(
    @InjectRepository(User)
    private readonly repository: Repository<User>,
  ) {}

  create(data: Partial<User>): User {
    return this.repository.create(data);
  }

  save(user: User): Promise<User> {
    return this.repository.save(user);
  }

  findById(id: string): Promise<User | null> {
    return this.repository.findOne({ where: { id } });
  }

  findByEmail(email: string): Promise<User | null> {
    return this.repository.findOne({ where: { email } });
  }

  async findAll(
    query: QueryUsersDto,
  ): Promise<{ data: User[]; total: number }> {
    const where: FindOptionsWhere<User>[] = [];
    const page = query.page ?? 1;
    const limit = query.limit ?? 20;

    if (query.search) {
      where.push({ email: ILike(`%${query.search}%`) });
      where.push({ fullName: ILike(`%${query.search}%`) });
    }

    const [data, total] = await this.repository.findAndCount({
      where: where.length > 0 ? where : {},
      order: { createdAt: 'DESC' },
      skip: (page - 1) * limit,
      take: limit,
    });

    if (!query.role) {
      return { data, total };
    }

    const filteredData = data.filter((item) => item.role === query.role);
    const filteredTotal = filteredData.length;

    return { data: filteredData, total: filteredTotal };
  }

  async remove(user: User): Promise<void> {
    await this.repository.remove(user);
  }
}
