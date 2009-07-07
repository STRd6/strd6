desc "copy development db to production"
task :db_copy do
  `cp db/development.sqlite3 db/production.sqlite3`
end

desc "Clear cached full pages"
task :clear_cache do
  `rm public/index.html public/quizzes.html public/about.html public/quizzes.rss`
  `rm public/quizzes/*.html`
end

desc "Create a new user: create_user[login,password,email]"
task :create_user, [:login, :password, :email] => :environment do |t, args|
  u = User.create(:login => args.login, :password => args.password, :password_confirmation => args.password, :email => args.email);
  puts u.inspect
end