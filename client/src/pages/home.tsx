import { useEffect, useState } from 'react';

import NameCard from '@/components/nameCard/nameCard';
import { getScores } from '@/api/getScores';
import { updateScore } from '@/api/updateScore';
import { InitialScore, CHLOE_KEY, BETH_KEY } from '@/constants';
import { PlayerName } from '@/types';
import { useAuth } from '@/hooks/useAuth';

const Home = () => {
  const auth = useAuth();
  if (auth.isLoading) {
    return <div>Loading...</div>;
  }

  const [scores, setScores] = useState(InitialScore);

  const handleScoreChange = (playerName: PlayerName, newScore: number) => {
    if (newScore < 0 && scores[playerName] === 0) {
      return;
    }

    setScores((prevScore) => ({
      ...prevScore,
      [playerName]: newScore,
    }));

    updateScore(playerName, newScore);
  };

  const handleReset = () => {
    setScores(InitialScore);
    for (const playerName in InitialScore) {
      updateScore(playerName as PlayerName, 0);
    }
  };

  useEffect(() => {
    const fetchScores = async () => {
      const scoreData = await getScores();
      setScores(scoreData);
    };
    fetchScores();
  }, []);

  return (
    <div className="h-full flex flex-col justify-evenly items-center">
      <div className="">
        <h1 className="">Crossword Scoreboard</h1>
      </div>
      <div className="flex justify-evenly w-full">
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
      <div className="flex justify-center mb-4">
        <button onClick={handleReset}>Reset</button>
      </div>

      <div className="flex justify-center">
        <button onClick={() => auth.handleSignOut()}>Sign Out</button>
      </div>
    </div>
  );
};

export default Home;
