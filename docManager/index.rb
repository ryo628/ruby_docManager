#!/usr/local/bin/ruby
# encoding: utf-8

load 'lib/header.rb'

begin
  
  obj = DocManager.new()
  obj.top()
  
rescue => ex
  
  puts ex.message
  
end

