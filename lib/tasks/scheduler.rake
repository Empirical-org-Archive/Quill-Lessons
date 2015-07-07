desc "This task is called by the Heroku cron add-on"
task :call_page => :environment do
  uri = URI.parse('https://empirical-grammar.herokuapp.com/')
  Net::HTTP.get(uri)
  uri = URI.parse('https://empirical-discourse.herokuapp.com/')
  Net::HTTP.get(uri)
end
