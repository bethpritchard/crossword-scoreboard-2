import NameCard from "./components/nameCard/nameCard";

function App() {
  return (
    <div className="h-screen w-screen flex flex-col flex-grow justify-around items-center">
      <div className="w-full">
        <h1 className="text-center">Crossword Scoreboard</h1>
      </div>
      <div className="flex flex-row  justify-evenly w-full">
        <NameCard playerName="Chloe" />
        <NameCard playerName="Beth" />
      </div>
      <div>
        <h1> Reset</h1>
      </div>
    </div>
  );
}

export default App;
