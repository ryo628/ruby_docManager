class Files
  
  def initialize()
    @name = "uploadData"
    @dir = Dir.getwd + "/files/"
  end
  
  def get_file_dir(id)
    return @dir + sprintf("%010d",id.to_i)
  end
  
  def get_upload_form(id)
    
    html = ""
    
    file_dir = get_file_dir(id)
    FileUtils.mkdir_p(file_dir) unless FileTest.exist?(file_dir)
    
    path = "files/" + sprintf("%010d", id.to_i)
    
    Dir::glob(file_dir + "/*").each {|f|
      # ここにマッチしたファイルに対して行う処理を記述する
      # この例ではファイル名とファイルのサイズを標準出力へ出力している
      html += <<EOF
<form method="post" action="upload.rb">
  <input type="button" value="削除" onclick="if(window.confirm('削除しますか？')){this.form.submit();}" />
  <input type="hidden" name="id" value="#{id}" />
  <input type="hidden" name="name" value="#{File.basename(f)}" />
  <a href="#{path}/#{File.basename(f)}">#{File.basename(f)}</a>
  <input type="hidden" name="mode" value="file_delete" />
</form>
EOF
    }
    
    html += <<EOF
<form method="post" action="upload.rb" enctype="multipart/form-data">
  <input type="hidden" name="mode" value="file_save" />
  <input type="hidden" name="id" value="#{id}">
  <input type="hidden" name="selected" value="" />
  <input type="file" name="#{@name}" onchange="this.form.selected.value='true'">
  <input type="button" value="アップロード" onclick="if(this.form.selected.value=='true'){this.form.submit();}else{alert('ファイルが選択されていません');}">
</form>
EOF
    return html
  end
  
  def save()
    
    data = $cgi.params[@name][0]
    id = $_POST["id"]
    
    filename = data.original_filename
    file_dir = get_file_dir(id)
    open(file_dir + "/" + filename, "w") do |fh|
      fh.binmode
      fh.write data.read
    end
    
    #print "Content-type: text/html\n\n"
    html = <<EOF
<html>
  <head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <title>アップロード</title>
  </head>
  <body>
    <div>#{filename}</div>
    <div>#{@dir}</div>
    <div>#{data.read}</div>
  </body>
</html>
EOF
    
  end
  
  def file_delete()
    
    id = $_POST["id"]
    file_dir = get_file_dir(id)
    filename = $_POST["name"]
    
    debug(file_dir + "/" + filename)
    File.unlink(file_dir + "/" + filename)
    
  end
  
end