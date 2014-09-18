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
  status 200
end

get '/isup' do
  "ok"
end

post '/service/:service/:id' do
  request.body.rewind
  body = request.body.read
  if is_json?(body)
    puts "service:#{params[:service]} #{params[:id]} #{body}"
    $redis.hmset("service:#{params[:service]}", "#{params[:id]}", "#{body}")
    "ok"
  else
    status 400
  end
end
