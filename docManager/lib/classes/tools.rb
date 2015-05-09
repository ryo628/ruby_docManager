$flg_debug = false

def debug(txt)
  
  if $flg_debug then
    puts "<div>#{txt}</div>\n"
  end
  
end

def get_dir()
  
  return Dir.getwd + "/"
  
end

def load_template(values, filename)
  
  dir = $templateDir
  debug(dir + filename)
  
  html = ""
  html = File.read(dir + filename, encoding: 'utf-8')
  values.each_pair { |key, val|
    html = html.gsub("_%#{key}%_", val.to_s)
  }
  
  return html

end
