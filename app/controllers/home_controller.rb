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

  def events
    @page_title       = 'Events'
    @page_description = 'Community events organised by MENA devs'
    @page_keywords    = AppSettings.meta_tags_keywords

    respond_to do |format|
      format.html  # events.html.erb
    end
  end

  def partners
    @page_title       = 'Community Partners'
    @page_description = 'Community partners listing'
    @page_keywords    = AppSettings.meta_tags_keywords

    respond_to do |format|
      format.html  # partners.html.erb
    end
  end

  def partner
    @page_title       = 'Community Partners'
    @page_description = 'Community partner'
    @page_keywords    = AppSettings.meta_tags_keywords

    respond_to do |format|
      format.html  # partner.html.erb
    end
  end
end
