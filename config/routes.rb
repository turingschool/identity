Asquared::Application.routes.draw do
  root 'site#index'

  get    '/please-login'    => 'sessions#show',     as: :please_login
  get    '/login'           => 'sessions#new',      as: :login
  get    '/github/callback' => 'sessions#callback', as: :github_callback
  delete '/logout'          => 'sessions#destroy',  as: :logout

  scope '/quiz' do
    get '/',        to: 'quiz#question', as: :quiz_question
    get 'complete', to: 'quiz#complete', as: :quiz_complete
  end
  resources :quiz, only: [:update]

  get '/apply' => 'step#show', as: :apply
  namespace :step, path: 'apply' do
    get 'step-1' => 'bio#show',      as: :edit_bio
    put 'step-1' => 'bio#update',    as: :bio

    get 'step-2' => 'resume#show',   as: :edit_resume
    put 'step-2' => 'resume#update', as: :resume

    get 'step-3' => 'essay#show',    as: :edit_essay
    put 'step-3' => 'essay#update',  as: :essay

    get 'step-4' => 'video#show',    as: :edit_video
    put 'step-4' => 'video#update',  as: :video

    get 'step-5' => 'quiz#show',     as: :edit_quiz
    put 'step-5' => 'quiz#update',   as: :quiz

    get 'step-6' => 'final#show',    as: :edit_final
    put 'step-6' => 'final#update',  as: :final
  end

  namespace :admin do
    get '/' => 'dashboard#index'
    resources :applicants, only: [] do
      collection do
        get '/step/:step'               => 'applicants#index', as: :subset_of
        get '/step/:step/by_date'       => 'applicants#by_date'
        get '/step/:step/by_quiz_score' => 'applicants#by_quiz_score'
        get '/step/:step/by_score'      => 'applicants#by_score'
      end
      member do
        get   :show
        get   :quiz
        patch :update

        resources :evaluations, only: [] do
          collection do
            post '/initial'   => 'evaluations#create_initial',   as: :initial
            post '/interview' => 'evaluations#create_interview', as: :interview
            post '/logic'     => 'evaluations#create_logic',     as: :logic
          end
        end

        resources :invitations, only: [:create] do
          collection do
            post '/accept'             => 'invitations#accept',             as: :accept
            post '/decline'            => 'invitations#decline',            as: :decline
            post '/schedule_interview' => 'invitations#schedule_interview', as: :schedule_interview
          end
        end
      end
    end

    resources :evaluations, only: [:edit, :update]
  end
end
