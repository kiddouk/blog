task default: "assets:precompile"

namespace :assets do
  desc "Precompile assets"
  task :precompile do
    Rake::Task["clean"].invoke
    sh "bundle exec jekyll build"
    sh "bundle exec jekyll build"
    sh "cp #{File.dirname(__FILE__)}/keybase.txt _site"
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
