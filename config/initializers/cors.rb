Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*' # Permitir solicitações de todas as origens (ajuste conforme necessário)
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      expose: ['access-token', 'expiry', 'token-type', 'uid', 'client'],
      max_age: 0
  end
end