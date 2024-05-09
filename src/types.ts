import { BETH_KEY, CHLOE_KEY, PLUS, MINUS } from "./constants";

export interface Score {
  [BETH_KEY]: number;
  [CHLOE_KEY]: number;
}

export type Sign = typeof PLUS | typeof MINUS;

export type PlayerName = typeof BETH_KEY | typeof CHLOE_KEY;
