export enum SessionStatus {
  ACTIVE = 'active',
  AWAITING_USER = 'awaiting_user',
  READY_FOR_QUOTE = 'ready_for_quote',
  QUOTED = 'quoted',
  READY_FOR_ORDER = 'ready_for_order',
  ORDERED = 'ordered',
  CANCELLED = 'cancelled',
}
