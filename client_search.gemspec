Gem::Specification.new do |s|
  s.name                  = 'client_search'
  s.version               = '0.0.1'
  s.summary               = 'Search a JSON client list'
  s.description           = 'A simple gem to search a JSON client list for partial name matches and also for duplicate email addresses'
  s.authors               = ['Dan Simmonds']
  s.email                 = 'danoxster@gmail.com'
  s.homepage              = 'https://github.com/danoxster/detrack'
  s.files                 = Dir['lib/**/*.rb']
  s.required_ruby_version = '>= 3.4.5'
  s.licenses              << '0BSD'
  s.executables           << 'client_search'
end
