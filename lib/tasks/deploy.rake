namespace :deploy do
  desc "Deploy application to Heroku"
  task :heroku do
    puts "Running the tests..."
    if system("rake test:all") == false
      puts "FAILURE: There is a problem with your tests."
      break
    end
    puts "Done."

    puts "Deploying to Heroku..."
    if system("git push heroku master") == false
      puts "FAILURE: There was a problem deploying to Heroku."
      break
    end
    puts "Done."

    puts "Running migrations..."
    if heroku("run rake db:migrate") == false
      puts "FAILURE: There was a problem running your migrations."
      break
    end
    puts "Done."

    puts "The application was deployed successfully."
  end
end

private

def heroku(command)
  system("GEM_HOME='' BUNDLE_GEMFILE='' GEM_PATH='' RUBYOPT='' /usr/local/heroku/bin/heroku #{command}")
end
