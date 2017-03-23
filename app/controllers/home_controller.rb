class HomeController < ApplicationController
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
end