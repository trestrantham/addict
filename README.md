[![Build Status](https://travis-ci.org/trenpixster/addict.svg)](https://travis-ci.org/trenpixster/addict)
# Addict

Addict allows you to manage users authentication on your [Phoenix Framework](http://www.phoenixframework.org) app easily.

## What does it?
For now, it enables your users to register, login, logout and recover/reset their passwords.

## On what does it depend?
Addict depends on:
- [Phoenix Framework](http://www.phoenixframework.org)
- [Ecto](https://github.com/elixir-lang/ecto)
- [Mailgun](https://mailgun.com) (Don't have an account? Register for free and get 10000 e-mails per month included)

## How can I get it started?

Addict is dependent on an ecto [User Model](https://github.com/elixir-lang/ecto/blob/master/examples/simple/lib/simple.ex#L18) and a [Database connection interface](https://github.com/elixir-lang/ecto/blob/master/examples/simple/lib/simple.ex#L12).

The user model must have at least the following schema:
```
  id serial primary key,
  email varchar(200),
  username varchar(200),
  hash varchar(130),
  recovery_hash varchar(130),
  CONSTRAINT u_constraint UNIQUE (email)
```

There are some application configurations you must add to your `configs.ex`:

```elixir
config :addict, not_logged_in_url: "/error",  # the URL where users will be redirected to
                db: MyApp.MyRepo,
                user: MyApp.MyUser,
                register_from_email: "Registration <welcome@yourawesomeapp.com>", # email registered users will receive from address
                register_subject: "Welcome to yourawesomeapp!", # email registered users will receive subject
                password_recover_from_email: "Password Recovery <no-reply@yourawesomeapp.com>",
                password_recover_subject: "You requested a password recovery link",
                email_templates: MyApp.MyEmailTemplates, # email templates for sending e-mails, more on this further down
                mailgun_domain: "yourawesomeapp.com",
                mailgun_key: "apikey-secr3tzapik3y"
```

The `email_templates` configuration should point to a module with the following structure:
```elixir
defmodule MyApp.MyEmailTemplates do
  def register_template(user) do
    """
      <h1>This is the HTML the user will receive upon registering</h1>
      You can access the user attributes: #{user.email}
    """
  end

  def password_recovery_template(user) do
    """
      <h1>This is the HTML the user will receive upon requesting a new password</h1>
      You should provide a link to your app where the token will be processed:
      <a href="http://yourawesomeapp.com/recover_password?token=#{user.recovery_hash}">like this</a>
    """
  end
end
```

## How can I use it?
Just add the following to your `router.ex`:

```elixir
defmodule ExampleApp.Router do
  use Phoenix.Router
  use Addict.RoutesHelper

  ...

  scope "/" do
    addict :routes
  end
end
```

This will generate the following routes:

```
        register_path  POST  /register          Addict.Controller.register/2
           login_path  POST  /login             Addict.Controller.login/2
          logout_path  POST  /logout            Addict.Controller.logout/2
recover_password_path  POST  /recover_password  Addict.Controller.recover_password/2
  reset_password_path  POST  /reset_password    Addict.Controller.reset_password/2
```

You can also override the `path` or `controller`/`action` for a given route:

```elixir
addict :routes,
  logout: [path: "/sign-out", controller: ExampleApp.UserController, action: :sign_out],
  recover_password: "/password/recover",
  reset_password: "/password/reset"
```

These overrides will generate the following routes:

```
        register_path  POST  /register          Addict.Controller.register/2
           login_path  POST  /login             Addict.Controller.login/2
          logout_path  POST  /sign-out          ExampleApp.UserController.sign_out/2
recover_password_path  POST  /password/recover  Addict.Controller.recover_password/2
  reset_password_path  POST  /password/reset    Addict.Controller.reset_password/2
```

`addict :routes` also allows you to configure which view and/or template is
used for a given route:

```elixir
addict :routes,
  register: [layout: false, view: MyApp.MyView],
  login: [layout: {MyApp.MyLayout, "some_template.html"}]
```

You can use `Addict.Plugs.Authenticated` plug to validate requests on your controllers:
```elixir
defmodule MyAwesomeApp.PageController do
  use Phoenix.Controller

  plug Addict.Plugs.Authenticated when action in [:foobar]
  plug :action

  def foobar(conn, _params) do
    render conn, "index.html"
  end

end
```

If the user is not logged in and requests for the above action, it will be redirected to `not_logged_in_url`.

## Extending

If you need to extend controller of manager behaviour you can do it. You just have to create new modules and `use` Base modules:

```elixir
    defmodule ExtendedManagerInteractor do
      use Addict.BaseManagerInteractor

      defp validate_params(user_params) do
      ...
      end

    end
```


## TODO
- [ ] Validate user model fields
- [x] Implement "Forgot and reset password" flow
- [x] Add example app
- [ ] Invite users ability
- [ ] ... whatever else it will definitely come up

## Contributing

Feel free to send your PR with improvements or corrections!

Special thanks to the folks at #elixir-lang on freenet for being so helpful every damn time!
