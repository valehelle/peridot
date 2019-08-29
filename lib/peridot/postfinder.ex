defmodule Peridot.Postfinder do
  use GenServer
  alias Peridot.Hackernews
  alias Peridot.Hackernews.Ask

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work() # Schedule work to be performed at some point
    {:ok, state}
  end

  def handle_info(:find_post, state) do
    # Do the work you desire here
    url = "https://hacker-news.firebaseio.com/v0/askstories.json?print=pretty"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        post_ids = Poison.decode!(body)
        Enum.each post_ids, fn post_id -> 
          get_info(post_id)
        end
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
    IO.puts "Finish finding post."
    schedule_work() # Reschedule once more
    {:noreply, state}
  end

  defp get_info(post_id) do
    url = "https://hacker-news.firebaseio.com/v0/item/#{post_id}.json"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        %{"title" => title, "by" => by, "id" => post_id} = Poison.decode!(body)
        if (String.equivalent?(title, "Ask HN: Who wants to be hired?") && String.equivalent?(by, "whoishiring")) do
          if Hackernews.get_ask(post_id) == nil do
            params = %{hacker_news_id: post_id}
            Hackernews.create_ask(params)
          end
        end
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  defp schedule_work() do
     #Process.send_after(self(), :find_post, 86400000) # In 1 day
     #Process.send_after(self(), :find_post, 15000) 
  end
end