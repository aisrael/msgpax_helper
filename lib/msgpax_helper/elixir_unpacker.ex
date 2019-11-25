defmodule MsgpaxHelper.ElixirUnpacker do
  @moduledoc """
  The actual logic to unpack Elixir data types from `%Msgpax.Ext{}` data.
  """
  @behaviour Msgpax.Ext.Unpacker

  @date_ext_type 101
  @naive_date_time_ext_type 102

  @doc """
  Unpack our custom Msgpax.Ext types.
  """
  @spec unpack(%Msgpax.Ext{}) :: {:ok, any} | :error
  def unpack(%Msgpax.Ext{type: @date_ext_type, data: data}) do
    with <<yyyy::integer-16, mm::integer, dd::integer>> <- data do
      Date.from_erl({yyyy, mm, dd})
    end
  end

  def unpack(%Msgpax.Ext{type: @naive_date_time_ext_type, data: data}) do
    with <<yyyy::integer-16, mm::integer-8, dd::integer-8, seconds_from_midnight::integer-16>> <-
           data do
      h = div(seconds_from_midnight, 3600)
      r = rem(seconds_from_midnight, 3600)
      m = div(r, 60)
      s = rem(r, 60)

      NaiveDateTime.from_erl({{yyyy, mm, dd}, {h, m, s}})
    end
  end
end
