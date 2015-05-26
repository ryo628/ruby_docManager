#!/usr/local/bin/ruby
# encoding: utf-8

load 'lib/header.rb'

begin
  
  debug("index.rb")
  obj = DocManager.new()
  if obj.is_login() then
    debug("obj.is_login() = true")
    obj.top()
  else
    debug("obj.is_login() = false")
    obj.output_login_form()
  end
  
rescue => ex
  
  puts ex.message
  
end

