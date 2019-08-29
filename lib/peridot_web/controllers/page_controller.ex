defmodule PeridotWeb.PageController do
  use PeridotWeb, :controller
  alias Peridot.Jobs
  alias Peridot.Jobs.Post

  def index(conn, _) do
    render(conn, "index.html", posts: [])
  end
  def find(conn, params) do
    posts = Jobs.find_post(params)
    render(conn, "index.html", posts: posts)
  end
  def get_job(id) do
    url = "https://hacker-news.firebaseio.com/v0/item/#{id}.json"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        %{"kids" => comment_ids} = Poison.decode!(body)
        Enum.each comment_ids, fn comment_id -> 
          if !Jobs.post_exists?(comment_id) do
            get_info(comment_id)
          end

          
        end
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end
  def get_info(comment_id) do
    url = "https://hacker-news.firebaseio.com/v0/item/#{comment_id}.json"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        comment = Poison.decode!(body)
        save_info(comment)
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  defp save_info(%{"text" => text, "by" => username, "id" => comment_id} = comment) do
    upcase_text = String.upcase(text)
    list_text = String.split(upcase_text, ["<P>","\n"])
    is_remote = get_specified_text(list_text, "REMOTE:")
    willing_to_relocate = get_specified_text(list_text, "RELOCATE:")
    params = %{"username" => username, "remote" => is_remote, "relocate" => willing_to_relocate, "content" => text, "priority" => 2, "comment_id" => comment_id}
    Jobs.create_post(params)
  end

  defp save_info(_) do
  end

  defp get_specified_text(list_text, pattern_string) do
    case Enum.find(list_text, fn text -> String.contains?(text, pattern_string) end) do
      nil -> false
      pattern_text -> String.contains?(pattern_text, "YES") 
    end
  end

end
