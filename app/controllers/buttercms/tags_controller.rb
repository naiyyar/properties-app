class Buttercms::TagsController < Buttercms::BaseController
  def show
    @tag = ButterCMS::Tag.find(params[:slug], :include => :recent_posts)
    @tags = ButterCMS::Tag.all
    @categories = ButterCMS::Category.all
  end
end