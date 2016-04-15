class Admin::ArticlesController < ApplicationController
  USERS = { "yinsigan" => ENV['PASSWORD'] }


  before_action :authenticate
  before_action :set_article, only: [:edit, :update, :destroy]

  def index
    @articles = Article.all
    render 'articles/index'
  end

  def new
    @article = Article.new
    render 'articles/new'
  end

  def create
    @article = Article.new(article_params)

    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render :show, status: :created, location: @article }
      else
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    render "articles/edit"
  end

  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { render :show, status: :ok, location: @article }
      else
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to admin_root_path, notice: 'Article was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def authenticate
    authenticate_or_request_with_http_digest do |username|
      session[:admin] = true
      USERS[username]
    end
  end

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :body, :published)
  end
end
