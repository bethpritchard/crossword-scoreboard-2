export interface NameCardProps {
  playerName: string;
}

const NameCard = ({ playerName }: NameCardProps) => {
  return (
    <div>
      <p>0</p>
      <h2>{playerName}</h2>
    </div>
  );
};

export default NameCard;
