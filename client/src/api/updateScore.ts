import { PlayerScore } from '@/types';
import axios from 'axios';

const URL = 'https://b9v7lxe1ul.execute-api.eu-west-2.amazonaws.com/v1/db';

const headers = {
  'Content-Type': 'application/json',
};

export const updateScore = async (playerScore: PlayerScore) => {
  axios
    .post(`${URL}`, JSON.stringify(playerScore), { headers })
    .then((response) => {
      console.log(response.data.body);
    })
    .catch((error) => {
      console.log(error);
    });
};

export const getScores = async () => {
  axios
    .get(`${URL}`)
    .then((response) => {
      console.log(response.data);
    })
    .catch((error) => {
      console.log(error);
    });
};
