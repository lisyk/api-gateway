Rails.application.routes.draw do
  mount DbService::Engine => "/db_service"
end
