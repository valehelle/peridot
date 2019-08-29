defmodule Peridot.JobsTest do
  use Peridot.DataCase

  alias Peridot.Jobs

  describe "posts" do
    alias Peridot.Jobs.Post

    @valid_attrs %{content: "some content", priority: 42, relocate: true, remote: true, username: "some username"}
    @update_attrs %{content: "some updated content", priority: 43, relocate: false, remote: false, username: "some updated username"}
    @invalid_attrs %{content: nil, priority: nil, relocate: nil, remote: nil, username: nil}

    def post_fixture(attrs \\ %{}) do
      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Jobs.create_post()

      post
    end

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Jobs.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Jobs.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      assert {:ok, %Post{} = post} = Jobs.create_post(@valid_attrs)
      assert post.content == "some content"
      assert post.priority == 42
      assert post.relocate == true
      assert post.remote == true
      assert post.username == "some username"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Jobs.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      assert {:ok, %Post{} = post} = Jobs.update_post(post, @update_attrs)
      assert post.content == "some updated content"
      assert post.priority == 43
      assert post.relocate == false
      assert post.remote == false
      assert post.username == "some updated username"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Jobs.update_post(post, @invalid_attrs)
      assert post == Jobs.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Jobs.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Jobs.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Jobs.change_post(post)
    end
  end
end
