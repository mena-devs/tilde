require 'rubygems'
require 'sitemap_generator'

SitemapGenerator::Sitemap.default_host = 'https://menadevs.com'
SitemapGenerator::Sitemap.create do
  add '/home', :changefreq => 'weekly'
  add '/events', :changefreq => 'weekly'
  add '/about-us', :changefreq => 'weekly'
  add '/contact-us', :changefreq => 'weekly'
  add '/jobs', :changefreq => 'daily', :priority => 0.9
end
SitemapGenerator::Sitemap.ping_search_engines # Not needed if you use the rake tasks
