# Renders the home page.
class HomeController < ApplicationController
  def about
    @page_title       = 'About us'
    @page_description = 'About MENA devs'
    @page_keywords    = AppSettings.meta_tags_keywords
  end

  def index
    @page_title       = 'Homepage'
    @page_description = "Home of MENA devs. One of the largest online communities for developers in the MENA region. Join in if you're looking for software developers, CTO, technical expertise or to connect with mentors and community leaders."
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

  def newsletter
    @page_title       = 'Newsletter'
    @page_description = 'Subscribe to MENA devs newsletter'
    @page_keywords    = AppSettings.meta_tags_keywords

    respond_to do |format|
      format.html  # newsletter.html.erb
    end
  end
end
