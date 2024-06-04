import axios from 'axios';
import { API_URL } from '@/api/constants';

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
