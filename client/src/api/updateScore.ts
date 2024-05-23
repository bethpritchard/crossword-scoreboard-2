import axios from 'axios';
import { API_URL, HEADERS } from './constants';
import { PlayerName, PlayerScore } from '@/types';

export const updateScore = async (playerName: PlayerName, score: number) => {
  const playerScore: PlayerScore = { playerName, score };

  axios
    .post(`${API_URL}`, JSON.stringify(playerScore), { headers: HEADERS })
    .then((response) => {
      console.log(response.data.body);
    })
    .catch((error) => {
      console.log(error);
    });
};
