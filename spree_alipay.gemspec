Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_alipay'
  s.version     = '1.1'
  s.summary     = 'Add gem summary here'
  #s.description = 'Add (optional) gem description here'
  s.required_ruby_version = '>= 2.0.0'
  s.author            = ['krypt2005']
  s.email             = ['krypt2005@gmail.com']
  s.homepage          = ''

  s.files        = Dir['CHANGELOG', 'README.md', 'LICENSE', 'lib/**/*', 'app/**/*','db/migrate/*','config/locales/en.yml','config/routes.rb']
  s.require_path = 'lib'
  s.requirements << 'none'

  s.has_rdoc = true

  s.add_dependency('spree_core', '>= 2.0')
end
