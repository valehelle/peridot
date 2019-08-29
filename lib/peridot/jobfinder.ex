defmodule Peridot.Jobfinder do
  use GenServer
  alias Peridot.Hackernews
  alias Peridot.Hackernews.Ask
  alias PeridotWeb.PageController

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work() # Schedule work to be performed at some point
    {:ok, state}
  end

  def handle_info(:find_post, state) do
    ask = Hackernews.get_latest_ask()
    if ask != nil do
      PageController.get_job(ask.hacker_news_id)
    end
    IO.puts "finish finding job"
    schedule_work() # Reschedule once more
    {:noreply, state}
  end

  defp schedule_work() do
     #Process.send_after(self(), :find_post, 86400000) # In 1 day
     #Process.send_after(self(), :find_post, 15000) 
  end
end