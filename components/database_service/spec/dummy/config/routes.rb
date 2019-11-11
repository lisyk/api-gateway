Rails.application.routes.draw do
  mount DatabaseService::Engine => "/database_service"
end
