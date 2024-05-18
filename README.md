# Rails Backend API Project

This is the repository for the backend API of the React and ReactNative projects. This API will serve as the backend for the applications, providing the necessary data and functionality.

## Prerequisites

Before getting started, make sure you have Ruby on Rails and the necessary gems installed in your development environment.

- [Ruby](https://www.ruby-lang.org/)
- [Ruby on Rails](https://rubyonrails.org/)

## Installation

Follow these steps to set up and run the project:

### Clone this repository

   ```bash
   git clone https://github.com/rodrigotoledo/board_control_rails
  ```

### Navigate to the project directory and install the dependencies

```bash
cd board_control_rails
bundle install
rails db:create db:migrate db:seed
```

### Access the API

The API will be available at [http://localhost:3000/api] and the endpoints are:

| HTTP Verb | Path                        | Controller#Action            |
|-----------|-----------------------------|------------------------------|
| GET       | /api/tasks(.:format)        | api/tasks#index              |
| PATCH     | /api/tasks/:id(.:format)    | api/tasks#update             |
| PUT       | /api/tasks/:id(.:format)    | api/tasks#update             |
| GET       | /api/projects(.:format)     | api/projects#index           |
| PATCH     | /api/projects/:id(.:format) | api/projects#update          |
| PUT       | /api/projects/:id(.:format) | api/projects#update          |
| POST      | /api/sign_up(.:format)      | api/registrations#create     |
| POST      | /api/sign_in(.:format)      | api/sessions#create          |
| DELETE    | /api/logout(.:format)       | api/sessions#destroy         |

## Development

### Using TDD

Always code with TDD, so you can run the tests with the following command:

```bash
bundle exec guard
```

## Commit and contribute

To features use the prefix `feature`. For example

```bash
git checkout develop
git checkout -b feature/crud_user
```

For fixes, use the prefix `fix`. For example

```bash
git checkout develop
git checkout -b fix/fix_in_crud_user
```

And to commit, its good practice use the `aicommit` package with the following command:

```bash
aicommits --generate 5
```

And choice the best option to commit.

Finally, you can merge the branch with `develop` and `main` branches.

### Contact

If you have any questions or need assistance during the code test, please don't hesitate to reach out to me.

Thanks. If you have any questions or need assistance at any point, please feel free to reach out to me. I'm here to help! [rodrigo@rtoledo.inf.br]
