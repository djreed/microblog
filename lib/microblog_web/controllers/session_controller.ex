# Modified from Nat Tuck's 'nu_mart' example:
# https://github.com/NatTuck/nu_mart/blob/master/lib/nu_mart_web/controllers/session_controller.ex
defmodule MicroblogWeb.SessionController do
  use MicroblogWeb, :controller

  alias Microblog.Accounts

  def login(conn, %{"login" => login}) do

    user = Accounts.get_user_by_email(login)

    if user do
      conn
      |> put_session(:user_id, user.id)
      |> put_flash(:info, "Logged in as #{user.handle}")
      |> redirect(to: user_path(conn, :show, user))
    else
      user = Accounts.get_user_by_handle(login)

      if user do
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "Logged in as #{user.handle}")
        |> redirect(to: user_path(conn, :show, user))
      else
        conn
        |> put_session(:user_id, nil)
        |> put_flash(:error, "No such user")
        |> redirect(to: user_path(conn, :index))
      end
    end
  end

  def logout(conn, _args) do
    conn
    |> put_session(:user_id, nil)
    |> put_flash(:info, "Logged out.")
    |> redirect(to: post_path(conn, :index))
  end
end
