# Investment

To start your Phoenix server:

* Run `mix setup` to install and setup dependencies
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).


# Investment Wallet Rebalancer (Elixir)

This project implements a **simple investment wallet rebalancing engine** written in pure Elixir.

Given:
- A wallet with currently owned stocks
- A desired portfolio allocation (percentages)
- A known price list for available stocks

The system calculates:
- Which stocks should be **sold**
- Which stocks should be **bought**
- How many units are required to move the wallet as close as possible to the desired allocation.

This project focuses on **domain logic**, correctness, and testability rather than external integrations.

---

## Requirements

- Elixir 1.16+
- Erlang/OTP 26+

The project relies only on standard library features and does not require
any external services.


## Features

- Pure Elixir (no Phoenix, no database)
- Deterministic rebalance logic
- Percent-based allocation validation
- Integer-based money handling (prices in cents)
- Clear buy/sell instructions
- Full ExUnit test coverage

---

## Domain Model

### Wallet

Represents a user's investment wallet.

```elixir
%Wallet{
  name: "Juan wallet",
  assigned_stocks: [Stock.t()],
  wish_stocks: [WishStock.t()],
  to_sell_stocks: [%{code: String.t(), units: integer()}],
  to_buy_stocks: [%{code: String.t(), units: integer()}],
  balance_cents: integer()
}
```

**Fields**
- `assigned_stocks`: Stocks currently owned (each element represents one unit)
- `wish_stocks`: Desired portfolio distribution
- `to_sell_stocks`: Output list of stocks to sell
- `to_buy_stocks`: Output list of stocks to buy
- `balance_cents`: Total wallet value in cents

---

### Stock

Represents a tradable asset.

```elixir
%Stock{
  name: "Apple Inc.",
  code: "AAPL",
  current_price_cents: 22937
}
```

Prices are stored in **cents** to avoid floating-point errors.

---

### WishStock

Represents the desired allocation for a stock.

```elixir
%WishStock{
  percentaje: 30,
  code: "META",
  stock: %Stock{}
}
```

- `percentaje` is an integer between 0 and 100
- Allocation must sum to exactly 100

---

## Rebalance Process

1. Validate wallet structure
2. Validate that desired allocation sums to 100%
3. Load stock prices
4. Calculate current wallet balance
5. For each desired stock:
   - Calculate assigned amount based on percentage
   - Calculate how many units should be owned
   - Compare with current owned units
   - Generate buy or sell instructions

---

## Usage

### Running the script

From the project root:

```bash
iex investment.exs
```
### Example

```elixir
wallet = %Wallet{
  name: "Juan wallet",
  assigned_stocks: [
    %Stock{code: "AAPL"},
    %Stock{code: "AAPL"},
    %Stock{code: "META"}
  ],
  wish_stocks: [
    %WishStock{percentaje: 20, code: "AAPL"},
    %WishStock{percentaje: 30, code: "META"},
    %WishStock{percentaje: 50, code: "NFLX"}
  ]
}

result = Investment.rebalance_wallet(wallet)
```

### Result

```elixir
%Wallet{
  to_sell_stocks: [
    %{code: "AAPL", units: 4},
    %{code: "META", units: 1}
  ],
  to_buy_stocks: [
    %{code: "NFLX", units: 10}
  ]
}
```

---

## Validation Rules

### Wallet validation
- Must be a `%Wallet{}`
- `assigned_stocks` must be a list

### Allocation validation
- `wish_stocks` cannot be empty
- Allocation percentages must sum to exactly 100

Errors returned:
- `{:error, :entity_not_process}`
- `{:error, :wish_stocks_empty}`
- `{:error, :allocation_not_one}`

---


## Tests

Run all tests with:

```bash
elixir investment.exs
```

or

```bash
mix test
```

Covered scenarios:
- Invalid wallet structure
- Empty desired allocation
- Invalid allocation sum
- Successful rebalance with buy/sell instructions

---

## Design Decisions & Trade-offs

### Integer-based money
Prices are stored in cents to avoid floating-point inaccuracies.

### Unit-based stocks
Each stock instance represents one unit.
This simplifies counting and avoids fractional shares.

### Static price source
Prices are loaded from a predefined list (`load_stocks/0`).
Designed for simplicity and deterministic testing.

---

## Known Limitations

- No transaction fees or taxes
- No cash balance handling
- No fractional shares
- Prices are static
- Assets not in the desired allocation are not automatically forced to 0%

---

## Possible Improvements

- External price provider (API)
- Decimal-based calculations for money
- Support for cash positions
- Support for fractional shares
- Portfolio universe = assigned ∪ wish stocks
- Phoenix API or LiveView UI

---

## LLM Usage Disclosure

This project was developed with assistance from a Large Language Model (LLM) for:
- Documentation structuring

Final design and implementation decisions were made by the author.
