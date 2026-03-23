import { createHash } from 'crypto';

const SPAIN_BOUNDS = {
  minLon: -9.5,
  maxLon: 3.3,
  minLat: 36.0,
  maxLat: 43.8,
};

const BOUNDS_PADDING = 0.25;

export type DecorativeCoordinates = {
  latitude: number;
  longitude: number;
};

export const buildDecorativeCoordinates = (
  seed: string,
): DecorativeCoordinates | null => {
  const trimmed = seed.trim();
  if (!trimmed) {
    return null;
  }

  const hash = createHash('sha256').update(trimmed).digest();
  const int1 = hash.readUInt32BE(0);
  const int2 = hash.readUInt32BE(4);

  const lonRange = SPAIN_BOUNDS.maxLon - SPAIN_BOUNDS.minLon - BOUNDS_PADDING * 2;
  const latRange = SPAIN_BOUNDS.maxLat - SPAIN_BOUNDS.minLat - BOUNDS_PADDING * 2;

  const longitude =
    SPAIN_BOUNDS.minLon +
    BOUNDS_PADDING +
    (int1 / 0xffffffff) * lonRange;
  const latitude =
    SPAIN_BOUNDS.minLat +
    BOUNDS_PADDING +
    (int2 / 0xffffffff) * latRange;

  return {
    latitude: Number(latitude.toFixed(6)),
    longitude: Number(longitude.toFixed(6)),
  };
};
