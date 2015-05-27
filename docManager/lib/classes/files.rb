class Files
  
  def initialize()
    @name = "uploadData"
    @dir = Dir.getwd + "/files/"
  end
  
  def get_file_dir(id)
    return @dir + sprintf("%010d",id.to_i)
  end
  
  def get_file_array(id)
    
    wk = []
    
    file_dir = get_file_dir(id)
    FileUtils.mkdir_p(file_dir) unless FileTest.exist?(file_dir)
    
    Dir::glob(file_dir + "/*").each {|f|
      filename = File.basename(f.force_encoding("utf-8"))
      wk << filename
    }
    
    return wk
    
  end
  
  def get_file_links(id)
    
    wk = get_file_array(id)
    
    html = ""
    
    path = "files/" + sprintf("%010d", id.to_i)
    
    wk.each do |filename|
      html += <<EOF
<a href='#{path}/#{filename}' target='_blank'>
  <img src='report1.png' alt='#{filename}' width=24 border=0 />
</a>
EOF
    end
    
    return html
    
  end
  
  def get_upload_form(id)
    
    html = ""
    
    file_dir = get_file_dir(id)
    FileUtils.mkdir_p(file_dir) unless FileTest.exist?(file_dir)
    
    path = "files/" + sprintf("%010d", id.to_i)
    
    get_file_array(id).each do |filename|
      html += <<EOF
<form method="post" action="upload.rb">
  <input type="hidden" name="id" value="#{id}" />
  <input type="hidden" name="name" value="#{filename}" />
  <input type="hidden" name="mode" value="file_delete" />
  <table>
    <tr>
      <td><input type="button" value="削除" onclick="if(window.confirm('削除しますか？')){this.form.submit();}" /></td>
      <td><a href="#{path}/#{filename}" target="_blank">#{filename}</a></td>
    </tr>
  </table>
</form>
EOF
    end
    
    if html != "" then
      html = "<h1>ファイル</h1>" + html
    end
    
    dat = DocDatas.new()
    
    docgroup_id = dat.get_data_by_id(id)["docgroup_id"]
    doctype_id = dat.get_doctype_id(docgroup_id)
    
    html += <<EOF
<form method="post" action="upload.rb?doctype_id=#{doctype_id}&docgroup_id=#{docgroup_id}" enctype="multipart/form-data">
  <input type="hidden" name="mode" value="file_save" />
  <input type="hidden" name="id" value="#{id}">
  <input type="hidden" name="selected" value="" />
  <input type="file" name="#{@name}" onchange="this.form.selected.value='true'">
  <input type="button" value="アップロード" onclick="if(this.form.selected.value=='true'){this.form.submit();}else{alert('ファイルが選択されていません');}" style="padding: 0px;">
</form>
EOF
    return "<div style='border-top: 1px solid #666666; padding-top: 10px;'>#{html}</div>"
  end
  
  def save()
    
    data = $cgi.params[@name][0]
    id = $_POST["id"]
    
    dir, filename =  File::split(data.original_filename.force_encoding("utf-8").gsub("\\","/"))
    file_dir = get_file_dir(id)
    open(file_dir + "/" + filename, "w") do |fh|
      fh.binmode
      fh.write data.read
    end
    
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