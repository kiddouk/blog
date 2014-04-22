task default: "assets:precompile"

namespace :assets do
  desc "Precompile assets"
  task :precompile do
    sh "bundle exec jekyll build"
    sh "bundle exec jekyll build"
  end
end

desc "Remove compiled files"
task :clean do
  sh "rm -rf #{File.dirname(__FILE__)}/_site/*"
end

desc "Start Jekyll preview server"
task :start do
  Rake::Task["clean"].invoke
  exec "bundle exec jekyll serve --config _config.yml --watch"
end
