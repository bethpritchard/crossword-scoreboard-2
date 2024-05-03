import NameCard from "./components/nameCard/nameCard";

function App() {
  return (
    <div className="h-screen flex flex-col justify-center items-center">
      <div>
        <h1>Crossword Scoreboard </h1>
      </div>
      <div className="flex flex-row">
        <NameCard playerName="Chloe" />
        <NameCard playerName="Beth" />
      </div>
    </div>
  );
}

export default App;
