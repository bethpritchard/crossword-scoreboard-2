import { Score } from '@/types';
import axios from 'axios';

const URL = 'https://55u3xi0fv6.execute-api.eu-west-2.amazonaws.com/test/test';

const CONFIG = {
  headers: {
    'Content-Type': 'application/json',
  },
};

export const updateScore = async (score: Score) => {
  axios
    .post(`${URL}`, JSON.stringify(score), CONFIG)
    .then((response) => {
      console.log(response);
    })
    .catch((error) => {
      console.log(error);
    });
};
