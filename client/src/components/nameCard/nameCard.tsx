import { MINUS, PLUS } from '../../constants';
import { PlayerName } from '../../types';
import ScoreButton from './scoreButton/scoreButton';

export interface NameCardProps {
  playerName: PlayerName;
  score: number;
  updateScore: (playerName: PlayerName, score: number) => void;
}

const NameCard = ({ playerName, score, updateScore }: NameCardProps) => {
  const handleIncrement = (multiplier: number) => {
    updateScore(playerName, score + 1 * multiplier);
  };
  return (
    <div className="flex flex-col grow items-center space-y-5">
      <p>{score}</p>
      <div className="flex flex-row space-x-10">
        <ScoreButton sign={MINUS} onClick={handleIncrement} />
        <h2>{playerName}</h2>
        <ScoreButton sign={PLUS} onClick={handleIncrement} />
      </div>
    </div>
  );
};

export default NameCard;
