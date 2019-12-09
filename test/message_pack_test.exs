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

    test "it can handle Decimal" do
      assert {:ok, [[199, 11], 100 | <<1, 207, 0, 0, 0, 7, 80, 136, 255, 7, 246>>]} =
               MessagePack.pack(Decimal.new(1, 31_415_926_535, -10))

      assert Decimal.new(1, 31_415_926_535, -10) ==
               MessagePack.unpack!([[199, 11], 100 | <<1, 207, 0, 0, 0, 7, 80, 136, 255, 7, 246>>])
    end

    test "it can handle Date" do
      assert {:ok, [214, 101 | <<7, 216, 8, 16>>]} = MessagePack.pack(~D[2008-08-16])
      assert ~D[2008-08-16] == MessagePack.unpack!([214, 101 | <<7, 216, 8, 16>>])
    end

    test "it can handle NaiveDateTime" do
      assert {:ok, [[199, 7], 102 | <<7, 216, 8, 16, 15, 0, 0>>]} ==
               MessagePack.pack(~N[2008-08-16 15:00:00])

      assert ~N[2008-08-16 15:00:00] ==
               MessagePack.unpack!([[199, 7], 102 | <<7, 216, 8, 16, 15, 0, 0>>])
    end

    test "it can handle times past 18:12:15" do
      assert ~N[2019-12-05 18:12:16] ==
               MessagePack.unpack!(MessagePack.pack!(~N[2019-12-05 18:12:16]))

      assert ~N[2019-12-05 23:59:59] ==
               MessagePack.unpack!(MessagePack.pack!(~N[2019-12-05 23:59:59]))
    end
  end
end
