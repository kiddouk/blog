task default: "assets:precompile"

namespace :assets do
  desc "Precompile assets"
  task :precompile do
    Rake::Task["clean"].invoke
    sh "bundle exec jekyll build"

    File.open('_posts/2013-09-01-learn-to-code.md', 'r') do |f1|  
     while line = f1.gets  
      puts line  
     end
    end  
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
