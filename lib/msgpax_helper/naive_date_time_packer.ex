defimpl Msgpax.Packer, for: NaiveDateTime do
  @moduledoc """
  Implementation of `Msgpax.Packer` for values of type `NaiveDateTime` that encodes to
  a MessagePack Ext data type with marker value `102`.

  It first uses `Date.to_erl/1` to extract the `yyyy`, `mm`, `dd`, `h`, `m` and `s`
  parts then encodes the date as a 16-bit year (2 bytes) and 1-byte month and 1-byte day.
  It then encodes the time a 16-bit integer representing seconds from midnight.

  The total packed size (including the Ext type markers) is 9 bytes.

  ## Examples

      iex> Msgpax.Packer.NaiveDateTime.pack(~N[2008-08-16 18:12:16])
      [[199, 6], 102 | <<7, 216, 8, 16, 210, 240>>]

      iex> Msgpax.Packer.NaiveDateTime.pack(~N[1879-03-14 11:30:00])
      [[199, 6], 102 | <<7, 87, 3, 14, 161, 184>>]
  """

  @naive_date_time_ext_type 102

  @spec pack(ndt :: NaiveDateTime.t()) :: iodata
  def pack(ndt) do
    {{yyyy, mm, dd}, {h, m, s}} = ndt |> NaiveDateTime.to_erl()

    @naive_date_time_ext_type
    |> Msgpax.Ext.new(
      <<yyyy::integer-16, mm::integer-8, dd::integer-8, h::integer-8, m::integer-8, s::integer-8>>
    )
    |> Msgpax.Packer.pack()
  end
end
