import { beforeEach, describe, expect, it } from 'vitest';
import { render, screen, waitFor } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import Home from '@/pages/home';

describe('Home', async () => {
  it('renders without crashing', async () => {
    render(<Home />);
    const h1 = screen.queryByText('Crossword Scoreboard');
    expect(h1).not.toBeNull();
  });
});

describe('NameCard', async () => {
  beforeEach(() => {
    userEvent.setup();
  });

  it('Renders name cards', async () => {
    render(<Home />);
    const h2 = screen.queryByText('Chloe');
    expect(h2).not.toBeNull();
  });

  it('Renders score', async () => {
    render(<Home />);
    const score = screen.queryAllByText('0')[0];
    expect(score).not.toBeNull();
  });

  it('It increments and decrements score', async () => {
    render(<Home />);

    const plusButton = screen.getAllByRole('button', { name: '+' })[0];
    userEvent.click(plusButton);
    const plusScore = await screen.findByText('1');
    expect(plusScore).not.toBeNull();

    const minusButton = screen.getAllByRole('button', { name: '-' })[0];
    userEvent.click(minusButton);

    await waitFor(() => {
      const score = screen.queryAllByText('0');
      expect(score).toHaveLength(2);
    });
  });

  it('Does not decrement score below 0', async () => {
    render(<Home />);
    const minusButton = screen.getAllByRole('button', { name: '-' })[0];
    userEvent.click(minusButton);

    await waitFor(() => {
      const score = screen.queryAllByText('0');
      expect(score).toHaveLength(2);
    });
  });

  it('Resets score', async () => {
    render(<Home />);
    userEvent.click(screen.getAllByRole('button', { name: '+' })[0]);
    userEvent.click(screen.getAllByRole('button', { name: '+' })[1]);

    await waitFor(() => {
      const score = screen.queryAllByText('1');
      expect(score).toHaveLength(2);
    });
    userEvent.click(screen.getByRole('button', { name: 'Reset' }));

    await waitFor(() => {
      const score = screen.queryAllByText('0');
      expect(score).toHaveLength(2);
    });
  });
});
