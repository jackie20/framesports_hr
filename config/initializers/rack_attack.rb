Rack::Attack.throttle("auth/login", limit: 5, period: 1.minute) do |req|
  req.ip if req.path == "/api/v1/auth/login" && req.post?
end

Rack::Attack.throttle("auth/forgot_password", limit: 3, period: 5.minutes) do |req|
  req.ip if req.path == "/api/v1/auth/forgot_password" && req.post?
end

Rack::Attack.throttle("api/general", limit: 300, period: 5.minutes) do |req|
  req.env["HTTP_AUTHORIZATION"]&.split(" ")&.last
end

Rack::Attack.blocklist_ip("127.0.0.2") # Example blocked IP

Rack::Attack.throttled_responder = lambda do |env|
  [
    429,
    { "Content-Type" => "application/json" },
    [{ errors: [{ status: "429", code: "TOO_MANY_REQUESTS", title: "Too Many Requests", detail: "Rate limit exceeded. Please try again later." }] }.to_json]
  ]
end
