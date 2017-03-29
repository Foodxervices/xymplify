class HomeController < ApplicationController
  before_action :only_allow_public_user
  layout :resolve_layout

  def index; end

  def retailers; end

  def how_it_works; end

  def faqs; end

  private
  def resolve_layout
    case action_name
    when "index"
      "public/layouts/home"
    else
      "public/layouts/main"
    end
  end

  def only_allow_public_user
    if user_signed_in?
      redirect_to authenticated_root_url
    end
  end
end