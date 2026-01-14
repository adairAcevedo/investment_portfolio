# Portfolio Rebalancer (Elixir)

A small, self-contained Portfolio rebalancing module for a personal investments/trading app.

Given:
- Current holdings (shares per symbol)
- Target allocation (weights per symbol, e.g. 40% META, 60% AAPL)
- Current prices (provided by a function)

The module outputs rebalance instructions: which symbols to **buy** and which to **sell** to match the target distribution.

---

## Features

- Pure Elixir domain logic (no DB, no Phoenix)
- Portfolio validation:
  - weights are non-negative
  - allocation sums to 1.0 (with float tolerance)
  - holdings are non-negative
  - missing/invalid prices are rejected
- Rebalance instructions:
  - `:buy` when target value > current value
  - `:sell` when target value < current value
- Test suite with ExUnit

---

## Domain Model

### Portfolio
A `Portfolio` contains:

- `holdings`: map of `symbol => shares`
- `target_allocation`: map of `symbol => weight`

Example:

```elixir
%Portfolio{
  holdings: %{"AAPL" => 10.0, "META" => 3.0},
  target_allocation: %{"AAPL" => 0.6, "META" => 0.4}
}

%Wallet{name: "Juan wallet", assigned_stocks: [
      %Stock{name: "Apple Inc.", code: "AAPL"}, %Stock{name: "Meta Platforms, Inc.", code: "META"}], wish_stocks: [
        %WishStock{percentaje: 40, code: "META"},
      %WishStock{percentaje: 60, code: "AAPL"}]}
