# encoding: utf-8

require 'cgi'

$cgi = CGI.new()

#$currentDir = Dir::pwd
$currentDir = Dir.getwd + "/lib/"
#$currentDir = get_dir()

$classDir = $currentDir + "classes/"
$templateDir = $currentDir + "templates/"
$databaseDir = $currentDir + "databases/"


def load_classes()
  
  dir = $classDir + "*.rb"
  #puts dir
  
  Dir::glob(dir).each {|f|
    
    load f
    
  }

end

def test()
  
  puts $cgi.header()
  
  html = load_template({}, "page.html")
  puts html
  #puts "<p>Current Directory</p>"
  #puts $classDir
  
  #puts "<p>classes</p>"
  
  #puts get_dir()

end

load_classes()

