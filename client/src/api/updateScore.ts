import { PlayerScore } from '@/types';
import axios from 'axios';

const URL = 'https://hj7vuxsb0b.execute-api.eu-west-2.amazonaws.com/v1/update';

const CONFIG = {
  headers: {
    'Content-Type': 'application/json',
  },
};

export const updateScore = async (playerScore: PlayerScore) => {
  axios
    .post(`${URL}`, JSON.stringify(playerScore), CONFIG)
    .then((response) => {
      console.log(response);
    })
    .catch((error) => {
      console.log(error);
    });
};
