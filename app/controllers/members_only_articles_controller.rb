class MembersOnlyArticlesController < ApplicationController
  before_action :authorize
  
  def index
    if logged_in?
      articles = Article.where(is_member_only: true).includes(:user).order(created_at: :desc)
      render json: articles, each_serializer: ArticleListSerializer
    else
      render json: { error: "Not authorized" }, status: :unauthorized
    end
  end

  def show
    if logged_in?
      article = Article.find(params[:id])
      render json: article
    else
      render json: { error: "Not authorized" }, status: :unauthorized
    end
  end

  private

  def authorize
    return render json: { error: "Not authorized" }, status: :unauthorized unless session.include?(:user_id)
  end

  def logged_in?
    session.include?(:user_id)
  end
end