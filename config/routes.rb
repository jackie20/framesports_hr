Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      # Authentication
      scope :auth do
        post   "login",           to: "auth#login"
        post   "logout",          to: "auth#logout"
        post   "refresh",         to: "auth#refresh"
        post   "forgot_password", to: "auth#forgot_password"
        put    "reset_password",  to: "auth#reset_password"
        put    "change_password", to: "auth#change_password"
      end

      # Employees
      resources :employees do
        member do
          get  "addresses",      to: "employee_addresses#index"
          post "addresses",      to: "employee_addresses#create"
          get  "qualifications", to: "employee_qualifications#index"
          post "qualifications", to: "employee_qualifications#create"
          get  "uniform",        to: "employee_uniforms#show"
          put  "uniform",        to: "employee_uniforms#update"
          get  "documents",      to: "employee_documents#index"
          post "documents",      to: "employee_documents#create"
        end
      end

      resources :employee_addresses, only: [:show, :update, :destroy]
      resources :employee_qualifications, only: [:show, :update, :destroy]
      resources :employee_documents, only: [:show, :update, :destroy]

      # Leave
      scope :leave do
        get  "balance",       to: "leave#balance"
        get  "team_calendar", to: "leave#team_calendar"
      end
      resources :leave, controller: "leave", only: [:index, :show, :create, :destroy] do
        member do
          put "approve", to: "leave#approve"
          put "reject",  to: "leave#reject"
        end
      end

      # Teams
      resources :teams do
        collection do
          get "org_chart"
        end
        member do
          post   "members",             to: "team_members#create"
          delete "members/:employee_id", to: "team_members#destroy"
        end
      end

      # Tasks
      resources :tasks do
        resources :comments, controller: "task_comments", shallow: true
      end

      # Chat
      namespace :chat do
        resources :rooms, controller: "chat_rooms" do
          member do
            get  "messages", to: "chat_messages#index"
            post "messages", to: "chat_messages#create"
          end
        end
      end

      # Files
      resources :files, controller: "shared_files"

      # Notifications
      resources :notifications, only: [:index] do
        member do
          put "read"
        end
        collection do
          put "read_all"
        end
      end

      # Reports
      resources :reports, only: [:show], param: :code

      # Lookups
      resources :lookups, only: [:index, :show], param: :type_code

      # Admin namespace
      namespace :admin do
        resources :roles do
          member do
            post   "permissions",           to: "role_permissions#create"
            delete "permissions/:perm_id",  to: "role_permissions#destroy"
          end
        end
        resources :employees, only: [] do
          member do
            post "roles", to: "user_roles#create"
            delete "roles/:role_id", to: "user_roles#destroy"
          end
        end
        resources :lookups, controller: "lookup_types" do
          resources :values, controller: "lookup_values", shallow: true
        end
        resources :teams, only: [] do
          resources :members, controller: "team_members", shallow: true
        end
        resources :leave, controller: "leave", only: [:index]
      end
    end
  end
end
