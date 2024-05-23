import { useEffect, useState } from 'react';
import NameCard from './components/nameCard/nameCard';
import { updateScore } from './api/updateScore';
import { getScores } from './api/getScores';
import { InitialScore, CHLOE_KEY, BETH_KEY } from './constants';
import { PlayerName } from './types';

const App = () => {
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
    <div className="h-screen w-screen flex flex-col flex-grow justify-around items-center">
      <div className="w-full">
        <h1 className="text-center">Crossword Scoreboard</h1>
      </div>
      <div className="w-full flex flex-row justify-evenly">
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
      <div>
        <button onClick={handleReset}>Reset</button>
      </div>
    </div>
  );
};

export default App;
