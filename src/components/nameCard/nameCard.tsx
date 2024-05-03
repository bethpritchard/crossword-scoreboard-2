export interface NameCardProps {
  playerName: string;
}

const NameCard = ({ playerName }: NameCardProps) => {
  return (
    <div>
      <p>0</p>
      <div className="flex flex-row">
        <button>+</button>
        <h2>{playerName}</h2>
        <button>-</button>
      </div>
    </div>
  );
};

export default NameCard;
