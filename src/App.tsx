import { useState } from "react";

import { BETH_KEY, CHLOE_KEY } from "./constants";
import { initialScore } from "./types";

import NameCard from "./components/nameCard/nameCard";

const App = () => {
  const [scores, setScores] = useState(initialScore);

  const handleScoreChange = (playerName: string, newScore: number) => {
    setScores((prevScore) => ({
      ...prevScore,
      [playerName]: newScore,
    }));
  };

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
        <button> Reset </button>
      </div>
    </div>
  );
};

export default App;
