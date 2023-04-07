module Users
  class CategoriesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_category, only: %i[update destroy]

    def index
      @categories = Category.where(user_id: current_user.id)
      render json: @categories, status: :ok
    end

    def create
      @category = Category.new(category_params)
      if @category.save
        render json: @category, status: :created
      else
        render json: { 'error': @category.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    end

    def update
      if @category.update(category_params)
        render json: @category, status: :updated
      else
        render json: { 'error': @category.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    end

    def destroy
      render json: @category, status: :ok
    end

    private

    def category_params
      params.require(:category).permit(:name).merge(user_id: current_user.id)
    end

    def set_category
      @category = Category.find(params[:id])
    end
  end
end
