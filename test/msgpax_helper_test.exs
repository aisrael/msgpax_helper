defmodule MsgpaxHelperTest do
  use ExUnit.Case
  doctest MsgpaxHelper

  test "greets the world" do
    assert MsgpaxHelper.hello() == :world
  end
end
