# encoding: utf-8

require 'cgi'
require 'cgi/session'
require 'sqlite3'
#require 'webrick'

$cgi = CGI.new()
$session = CGI::Session.new($cgi)

#$session["user"] = "test"

puts $cgi.header()

$currentDir = Dir.getwd + "/lib/"

$classDir = $currentDir + "classes/"
$templateDir = $currentDir + "templates/"
$databaseDir = $currentDir + "databases/"

#load $classDir + ""
load $classDir + "aduser.rb"
load $classDir + "tools.rb"
load $classDir + "dbconnect_sqlite3.rb"
load $classDir + "model.rb"
load $classDir + "docusers.rb"
load $classDir + "doctypes.rb"
load $classDir + "docgroups.rb"
load $classDir + "docdatas.rb"
load $classDir + "files.rb"
load $classDir + "docmanager.rb"

$flg_debug = false
$flg_ad = false

output_log("loaded classes.")

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

output_log("preset parameters.")

