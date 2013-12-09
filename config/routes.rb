Asquared::Application.routes.draw do
  root 'site#index'

  get '/please-login' => 'sessions#show', as: :please_login
  get '/login' => 'sessions#new', as: :login
  get '/github/callback' => 'sessions#callback', as: :github_callback
  delete '/logout' => 'sessions#destroy', as: :logout

  scope '/quiz' do
    get '/', to: 'quiz#question', as: :quiz_question
    get :complete, to: 'quiz#complete', as: :quiz_complete
  end
  resources :quiz, only: [:update]

  get '/apply' => 'step#show', as: :apply
  namespace :step, path: 'apply' do
    get 'step-1' => 'bio#show', as: :edit_bio
    put 'step-1' => 'bio#update', as: :bio

    get 'step-2' => 'resume#show', as: :edit_resume
    put 'step-2' => 'resume#update', as: :resume

    get 'step-3' => 'essay#show', as: :edit_essay
    put 'step-3' => 'essay#update', as: :essay

    get 'step-4' => 'video#show', as: :edit_video
    put 'step-4' => 'video#update', as: :video

    get 'step-5' => 'quiz#show', as: :edit_quiz
    put 'step-5' => 'quiz#update', as: :quiz
  end

  namespace :admin do
    get '/' => 'dashboard#index'
    resources :applicants, only: [] do
      collection do
        get '/step/:step' => 'applicants#index', as: :subset_of
      end
      member do
        get :show
        resources :evaluations, only: [:create]
      end
    end

    resources :evaluations, only: [:edit, :update]
  end
end
