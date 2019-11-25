defmodule MessagePack do
  @moduledoc """
  A helper / utility module that wraps calls to `Msgpax.unpack/2` to pass on
  `ext: ElixirUnpacker`.

  It can correctly pack/unpack values of type `Date` and `NaiveDateTime` using
  custom `Msgpax.Packer` implementations and `MsgpaxHelper.ElixirUnpacker`

  ## Examples

      iex> MessagePack.pack(~D[2008-08-16])
      {:ok, [214, 101 | <<7, 216, 8, 16>>]}

      iex> MessagePack.unpack([214, 101 | <<7, 216, 8, 16>>])
      {:ok, ~D[2008-08-16]}

      iex> MessagePack.pack!(~N[1879-03-14 11:30:00])
      [[199, 6], 102 | <<7, 87, 3, 14, 161, 184>>]

      iex> MessagePack.unpack!([[199, 6], 102 | <<7, 87, 3, 14, 161, 184>>])
      ~N[1879-03-14 11:30:00]
  """

  defdelegate pack(term, options \\ []), to: Msgpax
  defdelegate pack!(term, options \\ []), to: Msgpax

  @doc """
  Merely calls `Msgpax.unpack/1` but adds `ext: MsgpaxHelper.ElixirUnpacker` to the
  options.

  Returns `{:ok, term}` if the de-serialization is successful, `{:error, reason}` otherwise, where `reason` is a `Msgpax.UnpackError` struct which can be raised or converted to a more human-friendly error message with `Exception.message/1`. See `Msgpax.UnpackError` for all the possible reasons for an unpacking error.

  ## Examples

      iex> MessagePack.unpack(<<214, 101, 7, 216, 8, 16>>)
      {:ok, ~D[2008-08-16]}

      iex> MessagePack.unpack(<<199, 6, 102, 7, 87, 3, 14, 161, 184>>)
      {:ok, ~N[1879-03-14 11:30:00]}

      iex> MessagePack.unpack(<<129>>)
      {:error, %Msgpax.UnpackError{reason: :incomplete}}
  """
  @spec unpack(iodata, Keyword.t()) :: {:ok, any} | {:error, Msgpax.UnpackError.t()}
  def unpack(packed, opts \\ []),
    do:
      Msgpax.unpack(
        packed,
        Keyword.put_new(opts, :ext, MsgpaxHelper.ElixirUnpacker)
      )

  @doc """
  Merely calls `Msgpax.unpack!/1` but adds `ext: MsgpaxHelper.ElixirUnpacker` to the
  options.

  This function works like `unpack/2`, but it returns `term` (instead of `{:ok, term}`)
  if de-serialization is successful, otherwise raises a `Msgpax.UnpackError` exception.

  ## Examples

      iex> MessagePack.unpack!(<<214, 101, 7, 216, 8, 16>>)
      ~D[2008-08-16]

      iex> MessagePack.unpack!(<<199, 6, 102, 7, 87, 3, 14, 161, 184>>)
      ~N[1879-03-14 11:30:00]
  """
  @spec unpack!(iodata, Keyword.t()) :: any()
  def unpack!(packed, opts \\ []),
    do: Msgpax.unpack!(packed, Keyword.put_new(opts, :ext, MsgpaxHelper.ElixirUnpacker))
end
