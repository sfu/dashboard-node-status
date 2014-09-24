configure do
  redis_url = settings.redis_url
  $redis = Redis.new(:url => redis_url)
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
  "ok"
end

get '/isup' do
  "ok"
end

post '/service/:service/:id' do
  request.body.rewind
  body = request.body.read
  if is_json?(body)
    $redis.hmset("service:#{params[:service]}", "#{params[:id]}", "#{body}")
    "ok"
  else
    status 400
  end
end

get '/service/:service/?:id?' do
  content_type :json
  if params[:id]
    data = $redis.hget("service:#{params[:service]}", params[:id])
  else
    data = $redis.hgetall("service:#{params[:service]}")
  end
  if !data || (data.class == Hash && data.empty?)
    status 404
  else
    data.to_json
  end
end