import { Body, Controller, Get, Param, Patch, Post } from '@nestjs/common';
import { UpdateStepStateDto } from './dto/update-step-state.dto';
import { WizardService } from './wizard.service';

@Controller('wizard')
export class WizardController {
  constructor(private readonly wizardService: WizardService) {}

  @Get('steps')
  async getSteps() {
    return this.wizardService.getSteps();
  }

  @Get('steps/:code')
  async getStepByCode(@Param('code') code: string) {
    return this.wizardService.getStepByCode(code);
  }

  @Post('sessions/:sessionId/initialize')
  async initializeSessionSteps(@Param('sessionId') sessionId: string) {
    return this.wizardService.initializeSessionSteps(sessionId);
  }

  @Get('sessions/:sessionId/state')
  async getSessionStepStates(@Param('sessionId') sessionId: string) {
    return this.wizardService.getSessionStepStates(sessionId);
  }

  @Get('sessions/:sessionId/current')
  async getCurrentStep(@Param('sessionId') sessionId: string) {
    return this.wizardService.getCurrentStep(sessionId);
  }

  @Patch('sessions/:sessionId/state/:stepCode')
  async upsertSessionStepState(
    @Param('sessionId') sessionId: string,
    @Param('stepCode') stepCode: string,
    @Body() dto: UpdateStepStateDto,
  ) {
    return this.wizardService.upsertSessionStepState(sessionId, stepCode, dto);
  }
}
