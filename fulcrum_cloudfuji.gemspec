# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'fulcrum_cloudfuji/version'

Gem::Specification.new do |s|
  s.name = 'fulcrum_cloudfuji'
  s.authors = ['Sean Grove', 'Nathan Broadbent']
  s.email = 's@cloudfuji.com'
  s.homepage = 'http://cloudfuji.com'
  s.summary = 'Fulcrum - Cloudfuji Integration'
  s.description = 'Integrates Fulcrum with the Cloudfuji hosting platform.'
  s.files = `git ls-files`.split("\n")
  s.version = Fulcrum::Cloudfuji::VERSION

  s.add_dependency 'cloudfuji',           '>= 0.0.44'
  s.add_dependency 'devise_cloudfuji_authenticatable'
  s.add_dependency 'uuid'

end
