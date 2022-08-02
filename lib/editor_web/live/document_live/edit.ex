defmodule EditorWeb.DocumentLive.Edit do
  use EditorWeb, :live_view

  alias Editor.{Documents, Accounts}
  alias EditorWeb.DocumentPresence

  @impl true
  def mount(_params, session, socket) do
    EditorWeb.Endpoint.subscribe(DocumentPresence.topic())
    {:ok, socket |> assign(user: Accounts.get_user_by_session_token(session["user_token"]))}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    document = Documents.get_document!(id)

    maybe_track_user(document, socket)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:document, Documents.get_document!(id))}
  end

  defp page_title(:show), do: "Show Document"
  defp page_title(:edit), do: "Edit Document"

  @spec maybe_track_user(Map.t(), Map.t()) :: nil | {:error, any} | {:ok, binary}
  def maybe_track_user(
        document,
        %{assigns: %{live_action: :edit, user: user}} = socket
      ) do
    if connected?(socket) do
      DocumentPresence.track_user(self(), document.id, user.email)
    end
  end

  def maybe_track_user(_docment, _socket), do: nil

  @impl true
  def handle_info(%{event: "presence_diff"}, socket) do
    document = socket.assigns.document
    send_update(EditorWeb.DocumentActivityLive, id: "doc#{document.id}", document: document)

    {:noreply, socket}
  end
end
