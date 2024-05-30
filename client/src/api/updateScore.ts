import axios from 'axios';
import { API_URL } from './constants';
import { PlayerName, PlayerScore } from '@/types';

export const updateScore = async (
  authToken: string,
  playerName: PlayerName,
  score: number,
) => {
  const playerScore: PlayerScore = { playerName, score };
  const HEADERS = {
    'Content-Type': 'application/json',
    Authorization: `Bearer ${authToken}`,
  };

  axios
    .post(`${API_URL}`, JSON.stringify(playerScore), { headers: HEADERS })
    .then((response) => {
      console.log(response.data.body);
    })
    .catch((error) => {
      console.error('Error updating score.', error);
      throw error;
    });
};
