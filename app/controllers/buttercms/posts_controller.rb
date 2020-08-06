class Buttercms::PostsController < Buttercms::BaseController
  def index
    @posts         = ButterCMS::Post.all(:page => params[:page], :page_size => 8)
    @categories    = ButterCMS::Category.all
    @tags          = ButterCMS::Tag.all
    @next_page     = @posts.meta.next_page
    @previous_page = @posts.meta.previous_page
  end

  def show
    @post            = ButterCMS::Post.find(params[:slug])
    # @embed_body_code = ActiveSupport::SafeBuffer.new(%Q{#{@post.body}})
    @categories      = ButterCMS::Category.all
    @post_categories = @post.categories
    @related_posts   = ButterCMS::Post.all
    @tags            = @post.tags
    @has_related_posts = false
    @related_posts.each do |post|
      if post.slug != @post.slug && @post.categories.map(&:name) == post.categories.map(&:name)
        @has_related_posts = true
      end
    end
    @next_post     = @post.meta.next_post
    @previous_post = @post.meta.previous_post
  end

end