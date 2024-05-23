import axios from 'axios';
import { API_URL } from './constants';

export const getScores = async () => {
  try {
    const response = await axios.get(API_URL);
    return response.data;
  } catch (error) {
    console.error(error);
    return null;
  }
};
