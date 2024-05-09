import { PLUS } from "../../../constants";
import { Sign } from "../../../types";

interface ScoreButtonProps {
  sign: Sign;
  onClick: (multiplier: number) => void;
}

const ScoreButton = ({ sign, onClick }: ScoreButtonProps) => {
  const handleClick = () => {
    const multiplier = sign === PLUS ? 1 : -1;
    onClick(multiplier);
  };

  return (
    <button name={sign} onClick={handleClick}>
      {sign}
    </button>
  );
};

export default ScoreButton;
