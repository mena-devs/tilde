# Renders the home page.
class HomeController < ApplicationController
  def about
    @page_title       = 'About us'
    @page_description = 'About MENA devs'
    @page_keywords    = AppSettings.meta_tags_keywords
  end

  def index
    @page_title       = 'Homepage'
    @page_description = 'Home of MENA devs'
    @page_keywords    = AppSettings.meta_tags_keywords
  end

  def contact
    @page_title       = 'Contact us'
    @page_description = 'Contact MENA devs community'
    @page_keywords    = AppSettings.meta_tags_keywords
  end
end
