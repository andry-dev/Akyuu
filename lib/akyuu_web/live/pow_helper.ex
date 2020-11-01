defmodule AkyuuWeb.LiveViewPowHelper do
  @moduledoc """
    Will assign the current user from the session token.

    It will also renew the POW credential so it doesn't expire. Be cautious as according to @danshultzer -
    This could potentially open up for session attacks, but unless there's a way to set cookies through live view,
    I don't see any other way of keeping the session alive.
    
    I'd prefer not to use the __using__ macro stuff as I find it a little cryptic, but I needed it for the periodic handle_info unless someoe has a different suggestion?

    defmodule AppNameWeb.SomeViewLive do
        use PhoenixLiveView
        use AppNameWeb.LiveViewPowHelper

        def mount(session, socket) do
          socket = maybe_assign_current_user(socket, session)

          # ...
        end
    end
  """

  alias Akyuu.Accounts.User
  alias Phoenix.LiveView.Socket
  alias Pow.Store.CredentialsCache

  require Logger

  defmacro __using__(opts) do
    renewal_config = [renew_session: true, interval: :timer.seconds(5)]
    pow_config = [otp_app: :akyuu, backend: Pow.Store.Backend.EtsCache]

    quote do
      @pow_config unquote(Macro.escape(pow_config)) ++ [module: __MODULE__]
      @renewal_config unquote(Macro.escape(renewal_config)) ++ [module: __MODULE__]

      def maybe_assign_current_user(socket, session),
        do:
          unquote(__MODULE__).maybe_assign_current_user(
            socket,
            self(),
            session,
            @pow_config,
            @renewal_config
          )

      def handle_info({:renew_pow_session, session}, socket),
        do:
          unquote(__MODULE__).handle_renew_pow_session(
            socket,
            self(),
            session,
            @pow_config,
            @renewal_config
          )
    end
  end

  @doc """
  Retrieves the currently-logged-in user from the Pow credentials cache.
  """
  def get_user(socket, session, pow_config) do
    with {:ok, token} <- verify_token(socket, session, pow_config),
         {user, metadata} = pow_credential <- CredentialsCache.get(pow_config, token) do
      user
    else
      _any -> nil
    end
  end

  # Convienience to assign straight into the socket
  def maybe_assign_current_user(
        socket,
        pid,
        %{"akyuu_auth" => signed_token} = session,
        pow_config,
        renewal_config
      ) do
    case get_user(socket, session, pow_config) do
      %User{} = user ->
        maybe_init_session_renewal(
          socket,
          pid,
          session,
          renewal_config |> Keyword.get(:renew_session),
          renewal_config |> Keyword.get(:interval)
        )

        assign_current_user(socket, user)

      # We didn't get a current_user for the token
      _ ->
        assign_current_user(socket, nil)
    end
  end

  def maybe_assign_current_user(_, _, _), do: nil
  def maybe_assign_current_user(socket, _, _, _, _), do: assign_current_user(socket, nil)

  def maybe_assign_current_user(socket, _, _), do: assign_current_user(socket, nil)

  # assigns the current_user to the socket with the key current_user
  def assign_current_user(socket, user) do
    socket |> Phoenix.LiveView.assign(current_user: user)
  end

  # Session Renewal Logic
  def maybe_init_session_renewal(_, _, _, false, _), do: nil

  def maybe_init_session_renewal(socket, pid, session, true, interval) do
    if Phoenix.LiveView.connected?(socket) do
      Process.send_after(pid, {:renew_pow_session, session}, interval)
    end
  end

  def handle_renew_pow_session(socket, pid, session, pow_config, renewal_config) do
    with {:ok, token} <- verify_token(socket, session, pow_config),
         {user, _metadata} = pow_credential <- CredentialsCache.get(pow_config, token),
         {:ok, _session_token} <- update_session_ttl(pow_config, token, pow_credential) do
      # Successfully updates so queue up another renewal
      Process.send_after(
        pid,
        {:renew_pow_session, session},
        renewal_config |> Keyword.get(:interval)
      )
    else
      _any -> nil
    end

    {:noreply, socket}
  end

  # Verifies the session token
  defp verify_token(socket, %{"akyuu_auth" => signed_token}, pow_config) do
    conn = struct!(Plug.Conn, secret_key_base: socket.endpoint.config(:secret_key_base))
    salt = Atom.to_string(Pow.Plug.Session)
    Pow.Plug.verify_token(conn, salt, signed_token, pow_config)
  end

  defp verify_token(_, _, _), do: nil

  # Updates the TTL on POW credential in the cache
  def update_session_ttl(pow_config, session_token, {%User{} = user, metadata} = pow_credential) do
    sessions = CredentialsCache.sessions(pow_config, user)

    # Do we have an available session which matches the fingerprint?
    case sessions |> Enum.find(&(&1 == session_token)) do
      nil ->
        Logger.debug("No Matching Session Found")

      # We have an available session. Now lets update it's TTL by passing the previously fetched credential
      available_session ->
        Logger.debug("Matching Session Found. Updating TTL")
        CredentialsCache.put(pow_config, session_token, pow_credential)
    end
  end
end
