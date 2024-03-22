def do_bundle
  Bundler.with_unbundled_env { run "bundle install" }
end

say "\nMaking Slim templating default..."

append_file "Gemfile" do
  <<~RUBY
  gem "slim-rails"
  RUBY
end

inject_into_file 'Gemfile', after: 'group :development do' do
  <<-RUBY
  gem "html2slim-ruby3", require: false
  RUBY
end

do_bundle

run "erb2slim app/views/layouts/application.html.erb -d"
run "erb2slim app/views/layouts/mailer.html.erb -d"
run "erb2slim app/views/layouts/mailer.text.erb -d"

run "bin/rubocop -AS"

say "\nDefault Slim templating successfull!"
