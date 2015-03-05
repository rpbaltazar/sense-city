class RoutesController < ApplicationController
  def index
    @routes = Route.all
    render json: @routes.to_json
  end


end
