defmodule PeridotWeb.PostLive do
  use Phoenix.LiveView
  alias Peridot.Jobs
  alias PeridotWeb.PageView
  def render(assigns), do: PageView.render("post.html", assigns)

  def mount(_session, socket) do
     posts = Jobs.list_posts()
    {:ok, assign(socket, posts: posts, search: "")}
  end

  def handle_event("search", %{"q" => query} = params, socket)  do
    posts = Jobs.find_post(params)
    {:noreply, assign(socket, posts: posts, search: query)}
  end


end