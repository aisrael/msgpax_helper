defmodule MessagePackTest do
  use ExUnit.Case, async: true

  doctest MessagePack

  describe "MessagePack" do
    test "pack() works" do
      assert {:ok, [214, 101 | <<7, 216, 8, 16>>]} = MessagePack.pack(~D[2008-08-16])
    end

    test "pack!() works" do
      assert [214, 101 | <<7, 216, 8, 16>>] = MessagePack.pack!(~D[2008-08-16])
    end

    test "unpack() works" do
      assert {:ok, ~D[2008-08-16]} = MessagePack.unpack(<<214, 101, 7, 216, 8, 16>>)
    end

    test "unpack!() works" do
      assert ~D[2008-08-16] = MessagePack.unpack!(<<214, 101, 7, 216, 8, 16>>)
    end

    test "it can handle Date" do
      assert {:ok, [214, 101 | <<7, 216, 8, 16>>]} = MessagePack.pack(~D[2008-08-16])
      assert ~D[2008-08-16] == MessagePack.unpack!([214, 101 | <<7, 216, 8, 16>>])
    end

    test "it can handle NaiveDateTime" do
      assert {:ok, [[199, 6], 102 | <<7, 216, 8, 16, 210, 240>>]} ==
               MessagePack.pack(~N[2008-08-16 15:00:00])

      assert ~N[2008-08-16 15:00:00] ==
               MessagePack.unpack!(<<199, 6, 102, 7, 216, 8, 16, 210, 240>>)
    end
  end
end
