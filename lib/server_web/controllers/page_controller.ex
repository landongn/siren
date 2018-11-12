defmodule ServerWeb.PageController do
  use ServerWeb, :controller

  alias Server.Accounts

  def index(conn, _params) do
    render conn, "index.html"
  end

  def signup(conn, _params) do
    changeset = Accounts.change_user(%Accounts.User{})
    render conn, "signup.html", changeset: changeset
  end

  def signup_submit(conn, %{"user" => user_params}) do
    dob = user_params["dob"]
    birthdate =
    case NaiveDateTime.new(String.to_integer(dob["year"]), String.to_integer(dob["month"]), String.to_integer(dob["day"]), 0, 0, 0) do
      {:ok, val} ->
        val
      _ ->
        nil
    end

    user_params = Map.put(user_params, "validation_key", Phoenix.Token.sign(conn, "validation_key", user_params[:email_address]))
    user_params = Map.put(user_params, "dob", birthdate)

    pw = user_params["password"]
    pw2 = user_params["password_validate"]

    valid_password =
      case pw == pw2 do
        true ->
          true
        false ->
          false
      end

    hashed_password =
      case valid_password do
        true ->
          Comeonin.Pbkdf2.hashpwsalt(pw)
        false ->
          nil
      end

    user_params = Map.put(user_params, "password_hash", hashed_password)
    user_params = Map.drop(user_params, ["password", "password_validate"])

    if is_nil(user_params["rules_ok"]) do
      conn
      |> put_flash("info", "you have to agree to the rules!")
      |> render("signup.html", changeset: Accounts.change_user(user_params))
    else
      case Accounts.create_user(user_params) do
        {:ok, user} ->
          IO.inspect("-- able to register user -- ")
          ServerWeb.UserEmail.auth_validate(user) |> ServerWeb.Mailer.deliver_later
          conn
          |> put_flash("info", "Account registered.  Check your email.")
          |> render("signup_success.html")
        {:error, changeset} ->
          IO.inspect("changeset problem")
          IO.inspect changeset
          conn
          |> put_flash("error", "There was a problem.  See the form below for details.")
          |> render("signup.html", changeset: changeset)
        _ ->
          conn
          |> put_flash("error", "There was an error on our side.  Try again?")
          |> render("signup.html", changeset: user_params)

      end
    end
  end

  def signup_verify(conn, %{"token" => token}) do
    case Server.Repo.get_by(Accounts.User, validation_key: token) do
      %Accounts.User{} = record ->
        Accounts.update_user(record, %{email_verified: true})
        conn
        |> render("signup_verify.html")
      _ ->
        conn
        |> put_flash("error", "the code you gave isn't valid.")
        |> render("signup_verify_failed.html")
    end
  end

  def login_form(conn, _params) do
    render conn, "login.html", changeset: Accounts.User.changeset(%Accounts.User{}, %{})
  end

  def login(conn, %{"user" => user_params}) do

    case Server.Repo.get_by(Accounts.User, email: user_params["email"]) do
      %Accounts.User{} = user ->
        case Comeonin.Pbkdf2.checkpw(user_params["password"], user.password_hash) do
          true ->
            token = Phoenix.Token.sign(ServerWeb.Endpoint, "token", user.id, max_age: :infinity)
            session_data = %{"id" => user.id, "token" => token, "email" => user.email, "username" => user.name, "verified" => user.verified}
            conn
            |> put_session(:token, token)
            |> put_session(:user, session_data)
            |> assign(:user, session_data)
            |> assign(:token, token)
            |> configure_session(renew: true)
            |> halt
            |> redirect(to: "/play")

          false ->
            conn
            |> put_flash("error", "Your email address or password was not valid.")
            |> render("login.html", changeset: Accounts.User.changeset(%Accounts.User{}, user_params))
          end
      _ ->
        conn
        |> put_flash("error", "Your email address or password was not valid.")
        |> render("login.html", changeset: Accounts.User.changeset(%Accounts.User{}, user_params))
    end

  end
end
