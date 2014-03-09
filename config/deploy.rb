set :user, "vasarigems"
set :deploy_to, "/home/vasarigems/public/"
role :gem_server, "gems.vasaristudio.com"

task :publish, :roles => :gem_server do
  latest_gem_path = Dir.glob("*.gem").sort.last
  gem_name = File.basename(latest_gem_path)
  upload(latest_gem_path, "#{deploy_to}/gems/#{gem_name}")
  run "cd #{deploy_to} && gem generate_index"
end
