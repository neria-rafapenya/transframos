import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from '../entities/user.entity';

@Injectable()
export class UsersRepository {
  constructor(
    @InjectRepository(User)
    private readonly repository: Repository<User>,
  ) {}

  findById(id: string) {
    return this.repository.findOne({ where: { id } });
  }

  findByEmail(email: string) {
    return this.repository.findOne({ where: { email } });
  }

  create(data: Partial<User>) {
    return this.repository.create(data);
  }

  save(user: User) {
    return this.repository.save(user);
  }

  async findAll(_query?: unknown) {
    const [data, total] = await this.repository.findAndCount();
    return { data, total };
  }

  async remove(user: User) {
    return this.repository.remove(user);
  }
}
