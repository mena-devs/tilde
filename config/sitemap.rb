require 'rubygems'
require 'sitemap_generator'

SitemapGenerator::Sitemap.default_host = 'http://menadevs.com'
SitemapGenerator::Sitemap.create do
  add '/home', :changefreq => 'weekly'
  add '/about', :changefreq => 'weekly'
  add '/contact', :changefreq => 'weekly'
  add '/jobs', :changefreq => 'daily', :priority => 0.9
end
SitemapGenerator::Sitemap.ping_search_engines # Not needed if you use the rake tasks
