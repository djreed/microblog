defmodule MicroblogWeb.UpdatesChannel do
  use MicroblogWeb, :channel

  def join("updates:all", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("add_post", %{"name" => name, "handle" => handle, "content" => content}, socket) do
    broadcast! socket, "add_post", %{name: name, handle: handle, content: content}
    {:noreply, socket}
  end

  def handle_out("add_post", payload, socket) do
    push socket, "add_post", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
