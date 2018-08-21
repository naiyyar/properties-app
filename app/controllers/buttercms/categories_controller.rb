class Buttercms::CategoriesController < Buttercms::BaseController
  def show
    @category = ButterCMS::Category.find(params[:slug], :include => :recent_posts)
    @categories = ButterCMS::Category.all
    @tags = ButterCMS::Tag.all
  end
end