defmodule Peridot.HackernewsTest do
  use Peridot.DataCase

  alias Peridot.Hackernews

  describe "asks" do
    alias Peridot.Hackernews.Ask

    @valid_attrs %{hacker_news_id: "some hacker_news_id"}
    @update_attrs %{hacker_news_id: "some updated hacker_news_id"}
    @invalid_attrs %{hacker_news_id: nil}

    def ask_fixture(attrs \\ %{}) do
      {:ok, ask} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Hackernews.create_ask()

      ask
    end

    test "list_asks/0 returns all asks" do
      ask = ask_fixture()
      assert Hackernews.list_asks() == [ask]
    end

    test "get_ask!/1 returns the ask with given id" do
      ask = ask_fixture()
      assert Hackernews.get_ask!(ask.id) == ask
    end

    test "create_ask/1 with valid data creates a ask" do
      assert {:ok, %Ask{} = ask} = Hackernews.create_ask(@valid_attrs)
      assert ask.hacker_news_id == "some hacker_news_id"
    end

    test "create_ask/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Hackernews.create_ask(@invalid_attrs)
    end

    test "update_ask/2 with valid data updates the ask" do
      ask = ask_fixture()
      assert {:ok, %Ask{} = ask} = Hackernews.update_ask(ask, @update_attrs)
      assert ask.hacker_news_id == "some updated hacker_news_id"
    end

    test "update_ask/2 with invalid data returns error changeset" do
      ask = ask_fixture()
      assert {:error, %Ecto.Changeset{}} = Hackernews.update_ask(ask, @invalid_attrs)
      assert ask == Hackernews.get_ask!(ask.id)
    end

    test "delete_ask/1 deletes the ask" do
      ask = ask_fixture()
      assert {:ok, %Ask{}} = Hackernews.delete_ask(ask)
      assert_raise Ecto.NoResultsError, fn -> Hackernews.get_ask!(ask.id) end
    end

    test "change_ask/1 returns a ask changeset" do
      ask = ask_fixture()
      assert %Ecto.Changeset{} = Hackernews.change_ask(ask)
    end
  end
end
