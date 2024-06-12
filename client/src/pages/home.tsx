import { useEffect, useState } from 'react';

import NameCard from '@/components/nameCard/nameCard';
import { InitialScore, CHLOE_KEY, BETH_KEY } from '@/constants';
import { PlayerName } from '@/types';
import { useAuth } from '@/hooks/useAuth';

const Home = () => {
  const auth = useAuth();
  if (auth.isLoading) {
    return <div>Loading...</div>;
  }

  const [scores, setScores] = useState(InitialScore);
  const [error, setError] = useState('');
  const [ws, setWs] = useState<WebSocket | null>(null);

  const initaliseWebSocket = async () => {
    const token = await auth.getAuthToken();

    const ws = new WebSocket(
      `wss://9zhq00y7se.execute-api.eu-west-2.amazonaws.com/dev?Auth=${token}`,
    );

    ws.onopen = () => {
      console.log('Connected to WebSocket');
    };

    ws.onmessage = (messageEvent) => {
      const data = JSON.parse(messageEvent.data);
      if (data.action === 'scoreUpdate') {
        setScores((prevScore) => ({
          ...prevScore,
          [data.playerName]: data.score,
        }));
      }
    };

    ws.onclose = () => {
      console.log('Disconnected from WebSocket');
    };

    setWs(ws);

    return () => {
      ws.close();
    };
  };

  useEffect(() => {
    initaliseWebSocket();
  }, []);

  const handleScoreChange = async (
    playerName: PlayerName,
    newScore: number,
  ) => {
    if (newScore < 0 && scores[playerName] === 0) {
      return;
    }

    setScores((prevScore) => ({
      ...prevScore,
      [playerName]: newScore,
    }));

    try {
      if (ws) {
        ws.send(
          JSON.stringify({
            action: 'sendmessage',
            playerName,
            score: newScore,
          }),
        );
      }
      console.log('Sent score update:', playerName, newScore);
    } catch (error) {
      setError('Error updating score. Please try again.');
    }
  };

  const handleReset = async () => {
    setScores(InitialScore);
    try {
      // const token = await auth.getAuthToken();
      // for (const playerName in InitialScore) {
      //   updateScore(token, playerName as PlayerName, 0);
      // }
    } catch (error) {
      setError('Error resetting scores. Please try again.');
    }
  };

  return (
    <div className="h-full flex flex-col justify-evenly items-center p-4">
      <div className="w-full mb-4">
        <h1 className="text-center">Crossword Scoreboard</h1>
      </div>
      <div className="flex flex-col md:flex-row justify-evenly w-full space-y-4 md:space-y-0 md:space-x-4">
        <NameCard
          playerName={CHLOE_KEY}
          score={scores[CHLOE_KEY]}
          updateScore={handleScoreChange}
        />
        <NameCard
          playerName={BETH_KEY}
          score={scores[BETH_KEY]}
          updateScore={handleScoreChange}
        />
      </div>
      {error && <p>{error}</p>}
      <div className="flex justify-center mt-4 md:mt-8 mb-4">
        <button onClick={handleReset}>Reset</button>
      </div>
      <div className="flex justify-center">
        <button onClick={() => auth.handleSignOut()}>Sign Out</button>
      </div>
    </div>
  );
};

export default Home;
