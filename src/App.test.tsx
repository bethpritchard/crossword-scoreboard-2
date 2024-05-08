import { describe, expect, it } from "vitest";
import { render, screen } from "@testing-library/react";
import userEvent from "@testing-library/user-event";
import App from "./App";

describe("App", async () => {
  it("renders without crashing", async () => {
    render(<App />);
    const h1 = screen.queryByText("Crossword Scoreboard");
    expect(h1).not.toBeNull();
  });
});

describe("NameCard", async () => {
  it("Renders name cards", async () => {
    render(<App />);
    const h2 = screen.queryByText("Chloe");
    expect(h2).not.toBeNull();
  });

  it("Renders score", async () => {
    render(<App />);
    const score = screen.queryAllByText("0")[0];
    expect(score).not.toBeNull();
  });

  it("Increments score", async () => {
    render(<App />);
    const plusButton = screen.queryAllByRole("button")[1];
    userEvent.click(plusButton);
    const score = screen.queryAllByText("1")[0];
    expect(score).not.toBeNull();
  });

  it("Decrements score", async () => {
    render(<App />);
    const minusButton = screen.queryAllByRole("button")[0];
    userEvent.click(minusButton);
    const score = screen.queryAllByText("-1")[0];
    expect(score).not.toBeNull();
  });
});
