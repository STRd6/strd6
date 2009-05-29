desc "copy development db to production"
task :db_copy do
  `cp db/development.sqlite3 db/production.sqlite3`
end

desc "Clear cached full pages"
task :clear_cache do
  `rm public/index.html public/quizzes.html public/about.html public/quizzes.rss`
  `rm public/quizzes/*.html`
end

desc "create a new user."
task :create_user, [:login, :password, :email] do |t, args|
  code="u = User.create(:login => \"#{args.login}\", :password => \"#{args.password}\", :password_confirmation => \"#{args.password}\", :email => \"#{args.email}\" );"
  command = File.dirname(__FILE__) + "/../../script/runner -e #{RAILS_ENV} '#{code}'"
  puts `#{command}`
end