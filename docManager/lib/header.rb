# encoding: utf-8

require 'cgi'
require 'cgi/session'
require 'sqlite3'
require 'webrick'

$cgi = CGI.new()
$session = CGI::Session.new($cgi)

puts $cgi.header()

$currentDir = Dir.getwd + "/lib/"

$classDir = $currentDir + "classes/"
$templateDir = $currentDir + "templates/"
$databaseDir = $currentDir + "databases/"

#load $classDir + ""
load $classDir + "tools.rb"
load $classDir + "dbconnect_sqlite3.rb"
load $classDir + "model.rb"
load $classDir + "docusers.rb"
load $classDir + "doctypes.rb"
load $classDir + "docgroups.rb"
load $classDir + "docdatas.rb"
load $classDir + "files.rb"
load $classDir + "docmanager.rb"

def test()
  
  obj = DocTypes.new()
  
  wk = {}
  #wk["cont"] = $db.list_fields("doctypes")
  #wk["cont"] = load_template(wk,"edit_doctype.html")
  wk["cont"] = obj.list_all()
  
  html = load_template(wk, "page.html")
  puts html
  
end

$flg_debug = false

$_GET = {}
CGI::parse($cgi.query_string).each {|key, val|
 $_GET[key] = val[0]
}

$_POST = {}
$cgi.params.each {|key, val|
  tmp = val[0]
  $_POST[key] = tmp
}

$db_host = "localhost"
$db_user = "root"
$db_pass = "root"
$db_name = "docManager"

$db = DBConnect.new($db_host, $db_user, $db_pass, $databaseDir + $db_name)

$auth_type = ""
set_auth_type()

