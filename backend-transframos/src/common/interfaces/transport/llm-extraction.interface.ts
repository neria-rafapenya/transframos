export interface LlmExtractionInterface {
  intent: string;
  extractedFields: {
    productText?: string | null;
    quantityValue?: number | null;
    quantityUnit?: string | null;
    originText?: string | null;
    destinationText?: string | null;
    requestedPickupAt?: string | null;
    deliveryDeadlineAt?: string | null;
  };
  missingFields: string[];
  nextBestQuestion?: string | null;
  confidence?: number | null;
}
