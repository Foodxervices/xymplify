class HomeController < ApplicationController
  before_action :only_allow_public_user
  layout "public/layouts/main"

  def index; end

  def retailers; end

  def how_it_works; end

  def faqs; end

  def about_us; end

  private

  def only_allow_public_user
    if user_signed_in?
      redirect_to authenticated_root_url
    end
  end
end