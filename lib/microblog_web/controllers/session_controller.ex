# Modified from Nat Tuck's 'nu_mart' example:
# https://github.com/NatTuck/nu_mart/blob/master/lib/nu_mart_web/controllers/session_controller.ex
defmodule MicroblogWeb.SessionController do
  use MicroblogWeb, :controller

  alias Microblog.Accounts.User

  def login(conn, %{"login" => login, "password" => password}) do
    user = User.get_and_auth_user(login, password)

    if user do
      conn
      |> put_session(:user_id, user.id)
      |> put_flash(:info, "Logged in as #{user.handle}")
      |> redirect(to: user_path(conn, :show, user))
    else
      conn
      |> put_session(:user_id, nil)
      |> put_flash(:error, "No such login/password")
      |> redirect(to: user_path(conn, :index))
    end
  end

  def logout(conn, _args) do
    conn
    |> put_session(:user_id, nil)
    |> put_flash(:info, "Logged out.")
    |> redirect(to: post_path(conn, :index))
  end
end
