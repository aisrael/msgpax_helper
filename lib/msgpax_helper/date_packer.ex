defimpl Msgpax.Packer, for: Date do
  @moduledoc """
  Implementation of `Msgpax.Packer` for values of type `Date` that encodes to
  a MessagePack Ext data type with marker value 101.

  It first uses `Date.to_erl/1` to extract the `yyyy`, `mm` and `dd` parts then
  simply stores the `yyyy` as a 16-bit integer and the others into individual bytes.

  The total packed size (including the Ext type markers) is 6 bytes.

  ## Examples

      iex> Msgpax.Packer.Date.pack(~D[2008-08-16])
      [214, 101 | <<7, 216, 8, 16>>]

      iex> Msgpax.Packer.Date.pack(~D[1879-03-14])
      [214, 101 | <<7, 87, 3, 14>>]
  """

  @date_ext_type 101

  @doc """
  Packs a date using the MessagePack Ext type with the type marker value 101 and
  the actual date as the binary values of `Date.to_erl/1`
  """
  @spec pack(date :: Date.t()) :: iodata
  def pack(date) do
    {yyyy, mm, dd} = date |> Date.to_erl()

    @date_ext_type
    |> Msgpax.Ext.new(<<yyyy::integer-16, mm::integer-8, dd::integer-8>>)
    |> Msgpax.Packer.pack()
  end
end
