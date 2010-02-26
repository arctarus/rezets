require 'lib/crawler'
 
namespace :admin do
 
  desc "Crawl pages using the Mechanize gem. Set URL variable as a starting point. Set CREDS as username:password if you are hitting a password protected site. To generate a Google Sitemap in /public/sitemap.xml, set SITEMAP=true. To suppress output and only show errors, set QUIET=true. To show more details during output, set DEBUG=true."
  task :crawl_pages do
    start_url = ENV["URL"] || "http://localhost:3000"
    sitemap = Crawler.new(start_url, (ENV["CREDS"] if ENV["CREDS"]), ENV["QUIET"] || false, ENV["SITEMAP"] || false, ENV["DEBUG"] || false)
  end
 
end
