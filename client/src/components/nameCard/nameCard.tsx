import { MINUS, PLUS } from '../../constants';
import { PlayerName, PlayerScore } from '../../types';
import ScoreButton from './scoreButton/scoreButton';

export interface NameCardProps extends PlayerScore {
  updateScore: (playerName: PlayerName, score: number) => void;
}

const NameCard = ({ playerName, score, updateScore }: NameCardProps) => {
  const handleIncrement = (multiplier: number) => {
    updateScore(playerName, score + 1 * multiplier);
  };
  return (
    <div className="flex flex-col items-center">
      <h3>{score}</h3>
      <div className="flex flex-row space-x-10">
        <ScoreButton sign={MINUS} onClick={handleIncrement} />
        <h2>{playerName}</h2>
        <ScoreButton sign={PLUS} onClick={handleIncrement} />
      </div>
    </div>
  );
};

export default NameCard;
