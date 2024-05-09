import { beforeEach, describe, expect, it } from "vitest";
import { render, screen, waitFor } from "@testing-library/react";
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
  beforeEach(() => {
    userEvent.setup();
  });

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

  it("It increments and decrements score", async () => {
    render(<App />);

    const plusButton = screen.getAllByRole("button", { name: "+" })[0];
    userEvent.click(plusButton);
    const plusScore = await screen.findByText("1");
    expect(plusScore).not.toBeNull();

    const minusButton = screen.getAllByRole("button", { name: "-" })[0];
    userEvent.click(minusButton);

    await waitFor(() => {
      const score = screen.queryAllByText("0");
      expect(score).toHaveLength(2);
    });
  });

  it("Does not decrement score below 0", async () => {
    render(<App />);
    const minusButton = screen.getAllByRole("button", { name: "-" })[0];
    userEvent.click(minusButton);

    await waitFor(() => {
      const score = screen.queryAllByText("0");
      expect(score).toHaveLength(2);
    });
  });

  it("Resets score", async () => {
    render(<App />);
    userEvent.click(screen.getAllByRole("button", { name: "+" })[0]);
    userEvent.click(screen.getAllByRole("button", { name: "+" })[1]);

    await waitFor(() => {
      const score = screen.queryAllByText("1");
      expect(score).toHaveLength(2);
    });
    userEvent.click(screen.getByRole("button", { name: "Reset" }));

    await waitFor(() => {
      const score = screen.queryAllByText("0");
      expect(score).toHaveLength(2);
    });
  });
});