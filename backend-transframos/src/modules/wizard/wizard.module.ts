import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { WizardController } from './wizard.controller';
import { WizardService } from './wizard.service';
import { WizardRepository } from './repositories/wizard.repository';
import { WizardStepEntity } from './entities/wizard-step.entity';
import { SessionStepStateEntity } from './entities/session-step-state.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([WizardStepEntity, SessionStepStateEntity]),
  ],
  controllers: [WizardController],
  providers: [WizardService, WizardRepository],
  exports: [WizardService, WizardRepository],
})
export class WizardModule {}
