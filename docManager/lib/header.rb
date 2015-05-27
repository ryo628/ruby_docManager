# encoding: utf-8

require 'cgi'
require 'cgi/session'
require 'sqlite3'

$cgi = CGI.new()
$session = CGI::Session.new($cgi)

puts $cgi.header()

$currentDir = Dir.getwd + "/lib/"

$classDir = $currentDir + "classes/"
$templateDir = $currentDir + "templates/"
$databaseDir = $currentDir + "databases/"

#load $classDir + ""
classes = [
  "tools.rb",
  "dbconnect_sqlite3.rb",
  "model.rb",
  "docusers.rb",
  "doctypes.rb",
  "docgroups.rb",
  "docdatas.rb",
  "files.rb",
  "docmanager.rb"
]

classes.each do |c|
  load $classDir + c
end

$flg_debug = false

debug("USER : " + $session["user"].to_s)

$_GET = {}
CGI::parse($cgi.query_string).each {|key, val|
 $_GET[key] = val[0]
}

$_POST = {}
$cgi.params.each {|key, val|
  tmp = val[0]
  $_POST[key] = tmp
  debug("#{key} : #{tmp}")
}

$db_host = "localhost"
$db_user = "root"
$db_pass = "root"
$db_name = "docManager"

$db = DBConnect.new($db_host, $db_user, $db_pass, $databaseDir + $db_name)

$usr = DocUsers.new()
$auth_type = ""
#set_auth_type()

