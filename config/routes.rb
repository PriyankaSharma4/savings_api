BASE_URL = 'api/v1/'
Rails.application.routes.draw do
  devise_for :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post '/auth/login' => BASE_URL+'users#sign_in'
  post '/auth/signup' => BASE_URL+'users#sign_up'
  post '/goal' => BASE_URL+'users#create_goal'
  put '/goal/:id' => BASE_URL+'users#getandupdateGoal'
  get '/goal/:id' => BASE_URL+'users#getandupdateGoal'
  get '/goals' => BASE_URL+'users#getUserGoals'
end
