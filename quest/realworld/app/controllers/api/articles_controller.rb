class Api::ArticlesController < ApplicationController
  def create
    attributes = article_params
    article = Article.new(
      title: attributes[:title], 
      description: attributes[:description], 
      body: attributes[:body]
    )
    if article.save
      render json: {article: article},
             except: [:id, :created_at, :updated_at], 
             status: :ok
    else
      render json: article.errors, 
             status: :unprocessable_entity
    end
  end

  def show
    article = Article.find_by(slug: params[:slug])
    if article
      render json: {article: article},
             except: [:id, :created_at, :updated_at],
             status: :ok
    else
      render status: :not_found
    end
  end

  def update
    article = Article.find_by(slug: params[:slug])
    if article == nil
      render status: :unprocessable_entity
      return
    end

    attributes = article_params
    if article.update(attributes)
      render json: {article: article},
             except: [:id, :created_at, :updated_at],
             status: :ok
    else
      render json: article.errors,
             status: :unprocessable_entity
    end
  end

  def destroy
    article = Article.find_by(slug: params[:slug])
    if article
      article.destroy
      render status: :ok
    else
      render status: :unprocessable_entity
    end
  end


  private

  def article_params
    params.require(:article).permit(:title, :description, :body)
  end

end
