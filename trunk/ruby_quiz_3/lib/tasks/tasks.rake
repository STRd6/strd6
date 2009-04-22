desc "copy development db to production"
task :db_copy do
  `cp db/development.sqlite3 db/production.sqlite3`
end

desc "Clear cached full pages"
task :clear_cache do
  `rm public/index.html public/quizzes.html public/about.html`
  `rm public/quizzes/*.html`
end