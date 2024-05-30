import { API_URL } from '@/api/constants';
import axios from 'axios';

export const getScores = async (authToken: string) => {
  const HEADERS = {
    'Content-Type': 'application/json',
    Authorization: `Bearer ${authToken}`,
  };

  const response = await axios.get(API_URL, {
    headers: HEADERS,
  });
  return response.data;
};
