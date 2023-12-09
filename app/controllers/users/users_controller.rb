module Users
  class UsersController < ApplicationController
    before_action :authenticate_user!

    def show
      summary = Users::BuildSummary.fetch(current_user.id)

      render json: summary, status: :ok
    end
  end
end
