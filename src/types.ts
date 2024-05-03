import { BETH_KEY, CHLOE_KEY, PLUS, MINUS } from "./constants";

export interface Score {
  [BETH_KEY]: number;
  [CHLOE_KEY]: number;
}

export const initialScore: Score = {
  [BETH_KEY]: 0,
  [CHLOE_KEY]: 0,
};

export type Sign = typeof PLUS | typeof MINUS;
