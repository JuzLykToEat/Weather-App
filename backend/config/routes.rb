Rails.application.routes.draw do
  get '/weather/:city/:days',   to: 'weather#get'
end