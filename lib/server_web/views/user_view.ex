defmodule ServerWeb.UserView do
  use ServerWeb, :view
  alias ServerWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      name: user.name,
      verified: user.verified,
      password_hash: user.password_hash,
      dob: user.dob,
      email: user.email,
      email_verified: user.email_verified,
      is_admin: user.is_admin,
      contact_me: user.contact_me}
  end
end
