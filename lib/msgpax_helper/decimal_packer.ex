defimpl Msgpax.Packer, for: Decimal do
  @moduledoc """
  Implementation of `Msgpax.Packer` for values of type `Decimal` that encodes to
  a MessagePack Ext data type with marker value `100`.

  ## Examples

      iex> Decimal.new(0) |> Msgpax.Packer.Decimal.pack()
      [[199, 3], 100 | <<1, 0, 0>>]

      iex> Decimal.new(-1) |> Msgpax.Packer.Decimal.pack()
      [[199, 3], 100 | <<255, 1, 0>>]

      iex> Decimal.new(1234) |> Msgpax.Packer.Decimal.pack()
      [[199, 5], 100 | <<1, 205, 4, 210, 0>>]

      iex> Decimal.new(1, 31415926535, -10) |> Msgpax.Packer.Decimal.pack()
      [[199, 11], 100 | <<1, 207, 0, 0, 0, 7, 80, 136, 255, 7, 246>>]
  """

  @decimal_ext_type 100

  @doc """
  Packs a `Decimal` using the MessagePack Ext type with the type marker value `100`
  with the data as a tuple (list) of `[sign, coef, exp]`.
  """
  @spec pack(decimal :: Decimal.t()) :: iodata
  def pack(decimal) do
    data = IO.iodata_to_binary(pack_as_int_array(decimal.sign, decimal.coef, decimal.exp))

    @decimal_ext_type
    |> Msgpax.Ext.new(data)
    |> Msgpax.Packer.pack()
  end

  @spec pack_as_int_array(integer, integer, integer) :: iodata()
  def pack_as_int_array(sign, coef, exp)
      when is_integer(sign) and is_integer(coef) and is_integer(exp) do
    alias Msgpax.Packer.Integer, as: Int
    [[Int.pack(sign) | Int.pack(coef)] | Int.pack(exp)]
  end
end
