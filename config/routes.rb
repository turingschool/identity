Applicandy::Application.routes.draw do
  root 'site#index'

  get '/please-login' => 'sessions#show', as: :please_login
  get '/login' => 'sessions#new', as: :login
  get '/github/callback' => 'sessions#callback', as: :github_callback
  delete '/logout' => 'sessions#destroy', as: :logout

  resource :admin, only: [:show]

  namespace :step, path: 'apply' do
    get 'step-1' => 'bio#show', as: :bio_edit
    put 'step-1' => 'bio#update', as: :bio

    get 'step-2' => 'resume#show', as: :resume_edit
    put 'step-2' => 'resume#update', as: :resume

    get 'step-3' => 'essay#show', as: :essay_edit
    put 'step-3' => 'essay#update', as: :essay

    get 'step-4' => 'video#show', as: :video_edit
    put 'step-4' => 'video#update', as: :video
  end
end
