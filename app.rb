configure do
  redis_url = ENV['redis_url'] || 'redis://localhost:6379/0'
  redis = Redis.new(:url => redis_url)
end

def is_json?(json)
  begin
    JSON.parse(json)
    return true
  rescue Exception => e
    return false
  end
end

get '/' do
  "Hello, world!"
end

post '/service/:service' do
  request.body.rewind
  body = request.body.read
  puts body
  if is_json?(body)
    "#{body}"
  else
    "not valid"
  end
end
