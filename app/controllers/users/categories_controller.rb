module Users
  class CategoriesController < ApplicationController
    before_action :authenticate_user!
    before_action :set_category, only: %i[update destroy show]

    def index
      @categories = Category.where(user_id: current_user.id)

      serialized_categories = CategorySerializer.new(@categories).serializable_hash[:data]

      render json: serialized_categories, status: :ok
    end

    def create
      @category = Category.new(category_params)
      if @category.save
        serialized_category = CategorySerializer.new(@category).serializable_hash[:data]

        render json: serialized_category, status: :created
      else
        render json: { 'error': @category.errors.full_messages.to_sentence },
               status: :unprocessable_entity
      end
    end

    def update
      if @category.update(category_params)
        serialized_category = CategorySerializer.new(@category).serializable_hash[:data]

        render json: serialized_category, status: :ok
      else
        render json: { 'error': @category.errors.full_messages.to_sentence },
               status: :unprocessable_entity
      end
    end

    def destroy
      @category.destroy
      serialized_category = CategorySerializer.new(@category).serializable_hash[:data]

      render json: serialized_category, status: :ok
    end

    def show
      serialized_category = CategorySerializer.new(@category).serializable_hash[:data]

      render json: serialized_category, status: :ok
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
