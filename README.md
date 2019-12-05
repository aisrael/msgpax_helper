# MsgpaxHelper

[![Elixir CI](https://github.com/aisrael/msgpax_helper/workflows/Elixir%20CI/badge.svg)](https://github.com/aisrael/msgpax_helper/actions)
[![Coverage Status](https://coveralls.io/repos/github/aisrael/msgpax_helper/badge.svg?branch=master)](https://coveralls.io/github/aisrael/msgpax_helper?branch=master)

This is a small, personal library that provides a thin but opionated around [Msgpax](https://github.com/lexmag/msgpax) that can conveniently encode and decode Elixir
`Date` and `NaiveDateTime` values.

**IMPORTANT!**: Version 0.1 of this library had a critical flaw that it couldn't encode `NaiveDateTime`s where the time component was after `18:12:15` (this would overflow a 16-bit unsigned integer). Please upgrade to version 0.2 immediately (using `tag: "0.2"`, see below)!

## Installation

Until this library is published [in Hex](https://hex.pm/docs/publish), you can install it from Github by adding `msgpax_helper` to your list of dependencies in `mix.exs` as follows:

```elixir
def deps do
  [
    {:msgpax_helper, github: "aisrael/msgpax_helper", tag: "0.2"}
  ]
end
```

## Usage

To use this library, simply replace all calls to `Msgpax.pack`/`Msgpax.unpack` to `MessagePack.pack`/`MessagePack.unpack`:

```
iex> MessagePack.pack(~D[2008-08-16])
{:ok, [214, 101 | <<7, 216, 8, 16>>]}

iex> MessagePack.unpack([214, 101 | <<7, 216, 8, 16>>])
{:ok, ~D[2008-08-16]}

iex> MessagePack.pack!(~N[1879-03-14 11:30:00])
[[199, 7], 102 | <<7, 87, 3, 14, 11, 30, 0>>]

iex> MessagePack.unpack!([[199, 7], 102 | <<7, 87, 3, 14, 11, 30, 0>>])
~N[1879-03-14 11:30:00]
```

## Encoding/Decoding Structs

`Msgpax`, when combined with [maptu](https://github.com/lexhide/maptu), already provides a way to conveniently pack/unpack Elixir structs.

First use `@derive [{Msgpax.Packer, include_struct_field: true}]` on your struct:

```
defmodule Foo do

  @derive [{Msgpax.Packer, include_struct_field: true}]
  defstruct foo: "bar"
end
```

Packing the struct now encodes the `__struct__` field:

```
iex> MessagePack.pack!(%Foo{foo: "bar"})
[130, [170 | "__struct__"], [170 | "Elixir.Foo"], [163 | "foo"], [163 | "bar"]]
```

When unpacking, just pipe the result to `Maptu.struct!`:

```
iex> [130, [170 | "__struct__"], [170 | "Elixir.Foo"], [163 | "foo"], [163 | "bar"]] |> Msgpax.unpack! |> Maptu.struct!
%Foo{foo: "bar"}
```
