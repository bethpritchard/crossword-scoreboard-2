export interface NameCardProps {
  playerName: string;
}

const NameCard = ({ playerName }: NameCardProps) => {
  return (
    <div className="flex flex-col grow items-center">
      <p>0</p>
      <div className="flex flex-row space-x-10">
        <button>-</button>
        <h2>{playerName}</h2>
        <button>+</button>
      </div>
    </div>
  );
};

export default NameCard;
