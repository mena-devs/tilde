# Renders the home page.
class HomeController < ApplicationController
  def about
    @page_title       = 'About us'
    @page_description = 'About MENA devs'
    @page_keywords    = 'MENA, developers, CTO, technical manager,
                        computer science, computer, software, community, online
                        jobs, technical jobs'
  end

  def index
    @page_title       = 'Homepage'
    @page_description = 'Home of MENA devs'
    @page_keywords    = 'MENA, developers, CTO, technical manager,
                        computer science, computer, software, community, online
                        jobs, technical jobs'
  end

  def contact
    @page_title       = 'Contact us'
    @page_description = 'Contact MENA devs community'
    @page_keywords    = 'MENA, developers, CTO, technical manager,
                        computer science, computer, software, community, online
                        jobs, technical jobs'
  end
end
