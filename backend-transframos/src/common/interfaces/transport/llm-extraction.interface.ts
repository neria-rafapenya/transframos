export interface LlmExtractionInterface {
  intent: string;
  extractedFields: {
    productText?: string | null;
    quantityValue?: number | null;
    quantityUnit?: string | null;
    originText?: string | null;
    destinationText?: string | null;
    originLat?: number | null;
    originLon?: number | null;
    destinationLat?: number | null;
    destinationLon?: number | null;
    originAddressText?: string | null;
    originContactName?: string | null;
    originContactPhone?: string | null;
    destinationAddressText?: string | null;
    destinationContactName?: string | null;
    destinationContactPhone?: string | null;
    requestedPickupAt?: string | null;
    deliveryDeadlineAt?: string | null;
  };
  missingFields: string[];
  nextBestQuestion?: string | null;
  confidence?: number | null;
}
