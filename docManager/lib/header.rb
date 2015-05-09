# encoding: utf-8

require 'cgi'

$cgi = CGI.new()

$currentDir = Dir::pwd

$classDir = $currentDir + "/classes"
$templateDir = $currentDir + "/templates"
$databaseDir = $currentDir + "/databases"

def main()
  
  puts $cgi.header()
  
  puts "Current Directory : "
  puts $classDir
  
end
