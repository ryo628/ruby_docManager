#!/usr/local/bin/ruby
# encoding: utf-8

load 'lib/header.rb'

begin
  
  obj = DocManager.new()
  if obj.is_login() then
    obj.docusers()
  else
    obj.output_login_form()
  end
  
rescue => ex
  
  puts ex.message
  
end

