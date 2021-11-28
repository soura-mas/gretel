Dummy::Application.routes.draw do
  root to: "dummy#dummy"

  get "about"              => "dummy#dummy", as: :about
  get "about/contact"      => "dummy#dummy", as: :contact
  get "about/contact/form" => "dummy#dummy", as: :contact_form

  resources :projects do
    resources :issues do
      resource :assignee
      resources :comments
    end
  end

  namespace :admin do
    root to: "projects#index"
    resources :projects
  end

  namespace :mypage do
    resource :setting, only: %i[edit update]
  end
end
