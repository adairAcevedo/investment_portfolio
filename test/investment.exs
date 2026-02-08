defmodule InvestmentTest do
  use ExUnit.Case
  def mock_wish_stocks do
    [
      %WishStock{percentaje: 20, code: "AAPL"},
      %WishStock{percentaje: 30, code: "META"},
      %WishStock{percentaje: 50, code: "NFLX"}
    ]
  end

  def mock_assigned_stocks do
    [
      %Stock{name: "Apple Inc.", code: "AAPL"},
      %Stock{name: "Apple Inc.", code: "AAPL"},
      %Stock{name: "Apple Inc.", code: "AAPL"},
      %Stock{name: "Apple Inc.", code: "AAPL"},
      %Stock{name: "Apple Inc.", code: "AAPL"},
      %Stock{name: "Meta Platforms, Inc.", code: "META"}
    ]
  end

  def default_wallet do
    %Wallet{name: "Juan wallet", assigned_stocks: mock_assigned_stocks(), wish_stocks: mock_wish_stocks(), to_sell_stocks: [], to_buy_stocks: []}
  end
  test "invalid wallet" do
    assert {:error, :entity_not_process} == Investment.rebalance_wallet(%{})
  end

  test "error, assing_stock is empty" do
    assert {:error, :wish_stocks_empty} == Investment.rebalance_wallet(%Wallet{assigned_stocks: [], wish_stocks: []})
  end

  test "error, validate allocation sum 100 " do
    wallet =
      %Wallet{
        assigned_stocks: [],
        wish_stocks: [
          %WishStock{percentaje: 2, code: "AAPL"},
          %WishStock{percentaje: 3, code: "META"},
          %WishStock{percentaje: 5, code: "NFLX"}
        ]
      }
    assert {:error, :allocation_not_one} == Investment.rebalance_wallet(wallet)
  end

  test "rebalance returns buy/sell instructions" do
    response = Investment.rebalance_wallet(default_wallet())
    assert response.to_sell_stocks ==  [%{code: "AAPL", units: 4}, %{code: "META", units: 1}]
    assert response.to_buy_stocks == [%{code: "NFLX", units: 10}]
  end
end
