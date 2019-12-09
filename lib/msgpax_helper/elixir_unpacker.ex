defmodule MsgpaxHelper.ElixirUnpacker do
  @moduledoc """
  The actual logic to unpack Elixir data types from `%Msgpax.Ext{}` data.
  """
  @behaviour Msgpax.Ext.Unpacker

  @decimal_ext_type 100
  @date_ext_type 101
  @naive_date_time_ext_type 102

  @doc """
  Unpack our custom Msgpax.Ext types.
  """
  @spec unpack(%Msgpax.Ext{}) :: {:ok, any} | :error
  def unpack(%Msgpax.Ext{type: @decimal_ext_type, data: data}) do
    fudged = [147 | data]

    with {:ok, [sign, coef, exp]} <- Msgpax.unpack(fudged) do
      {:ok, Decimal.new(sign, coef, exp)}
    end
  end

  def unpack(%Msgpax.Ext{type: @date_ext_type, data: data}) do
    with <<yyyy::integer-16, mm::integer, dd::integer>> <- data do
      Date.from_erl({yyyy, mm, dd})
    end
  end

  def unpack(%Msgpax.Ext{type: @naive_date_time_ext_type, data: data}) do
    with <<yyyy::integer-16, mm::integer-8, dd::integer-8, h::integer-8, m::integer-8,
           s::integer-8>> <-
           data do
      NaiveDateTime.from_erl({{yyyy, mm, dd}, {h, m, s}})
    end
  end
end
