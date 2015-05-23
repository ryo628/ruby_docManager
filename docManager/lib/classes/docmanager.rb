class DocManager
  
  def initialize()
    @nav = ""
  end
  
  def main(obj)
    
    mode = $_POST["mode"]
    
    html = ""
    
    #obj = DocTypes.new()
    
    case mode
    when "edit_docuser"
      debug("EDIT_DOCUSER")
      html += obj.edit($_POST["id"])
    when "add_docuser"
      debug("ADD_DOCUSER")
      html += obj.add()
    when "apply_docuser"
      debug("APPLY_DOCUSER")
      obj.apply($_POST)
      html += obj.list_all()
    when "change_password"
      debug("CHANGE_PASSWORD")
      html = obj.set_password($_POST)
      #html += obj.list_all()
      
    when "edit_doctype"
      debug("EDIT_DOCTYPE")
      html += obj.edit($_POST["id"])
    when "add_doctype"
      debug("ADD_DOCTYPE")
      html += obj.add()
    when "apply_doctype"
      debug("APPLY_DOCTYPE")
      obj.apply($_POST)
      html += obj.list_all()
      
    when "edit_docgroup"
      debug("EDIT_DOCGROUP")
      html += obj.edit($_POST["id"])
    when "add_docgroup"
      debug("ADD_DOCGROUP")
      html += obj.add()
    when "apply_docgroup"
      debug("APPLY_DOCGROUP")
      obj.apply($_POST)
      html += obj.list_all()
      
    when "show_docdata"
      debug("SHOW_DOCDATA")
      html += obj.show($_POST["id"])
    when "edit_docdata"
      debug("EDIT_DOCDATA")
      html += obj.edit($_POST["id"])
    when "add_docdata"
      debug("ADD_DOCDATA")
      html += obj.add()
    when "apply_docdata"
      debug("APPLY_DOCDATA")
      id = obj.apply($_POST)
      html += obj.show(id)
      #html += obj.list_all()
    when "find_docdata"
      debug("FIND_DOCDATA")
      html += obj.list_by_word()
      
    when "file_save"
      debug("FILE_SAVE")
      obj.save()
    when "file_delete"
      debug("FILE_DELETE")
      obj.file_delete()
      
    else
      debug("ELSE")
      #html += obj.list_all()
    end
    
    return html
    
  end
  
  def output(title, html)
    
    menu = <<EOF
<a href="./">TOP</a>
<!--
<a href="doctypes.rb">種類</a>
<a href="docgroups.rb">分類</a>
<a href="docdatas.rb">データ</a>
<a href="docusers.rb">ユーザー</a>
-->
EOF
    menu = ""
    #html += "<div style='clear: both;'>#{$_GET.to_s} #{RUBY_VERSION}</div>"
    
    wk = {
      "title" => title,
      "head" => title,
      "menu" => menu,
      "nav" => @nav,
      "cont" => html,
      "foot" => "&copy; きむらしのぶ"
    }
    
    html = load_template(wk, "page.html")
    puts html
    #puts "work?"
    
  end
  
  def top()
    
    #html = main()
    #output("文書管理",html)
    docdatas()
    
  end
  
  def doctypes()
    
    doctype_id = $_GET["doctype_id"].to_i
    
    obj = DocTypes.new()
    
    html = ""
    if is_admin() then
      html = main(obj)
    else
      doctype_id = 0
    end
    
    if doctype_id > 0 then
      #html = obj.list_all()
      html = obj.edit(doctype_id)
    elsif html == "" then
      #html = obj.get_add_form()
      html = obj.list_all()
    end
    
    @nav += "<div class='title'><a href='./'>戻る</a></div>"
    obj.get_data_with_order("num").each do |row|
      @nav += "<div><a href='doctypes.rb?doctype_id=#{row["id"]}'>#{row["name"]}</a></div>"
    end
    @nav += "<div><a href='doctypes.rb'>一覧</a></div>"
    
    output("文書管理 - 種類",html)
    
  end
  
  def docgroups()
    
    obj = DocGroups.new()
    
    html = ""
    if is_admin() then
      html = main(obj)
    end
    
    if html == "" then
      html = obj.list_all()
    end
    
    @nav += "<div class='title'><a href='./'>戻る</a></div>"
    
    typ = DocTypes.new()
    typ.get_data_with_order("num").each do |row|
      @nav += "<div><a href='docgroups.rb?doctype_id=#{row["id"]}'>#{row["name"]}</a></div>"
    end
    
    output("文書管理 - 分類",html)
    
  end
  
  def docdatas()
    
    doctype_id = $_GET["doctype_id"].to_i
    
    obj = DocDatas.new()
    html = main(obj)
    if html == "" then
      html = obj.list_all()
    end
    
    typ = DocTypes.new()
    grp = DocGroups.new()
    
    @nav += obj.get_find_form()
    
    if doctype_id > 0 then
      @nav += "<div class='title'><a href='./'>#{typ.get_name(doctype_id)}</a></div>"
      #grp.get_data_by_value("doctype_id", doctype_id).each do |row|
      #grp.get_data_by_doctype_id(doctype_id).each do |row|
      grp.get_data_by_doctype_id_with_count(doctype_id).each do |row|
        @nav += "<div><a href='docdatas.rb?doctype_id=#{doctype_id}&docgroup_id=#{row["id"]}'>#{row["name"]} (#{row["datacount"]})</a></div>"
      end
    else
      #typ.get_data_with_order("num").each do |row|
      typ.get_data_with_order_and_count("num").each do |row|
        @nav += "<div><a href='docdatas.rb?doctype_id=#{row["id"]}'>#{row["name"]} (#{row["datacount"]})</a></div>"
      end
      if is_admin() then
        @nav += "<div><hr size=1 /></div>"
        @nav += "<div><a href='doctypes.rb'>種類管理</a></div>"
        @nav += "<div><a href='docgroups.rb'>分類管理</a></div>"
        @nav += "<div><a href='docusers.rb'>ユーザー管理</a></div>"
      end
    end
    
    #if !is_guest() then
    #  @nav += "<div><a href='password.rb'>パスワード変更</a></div>"
    #end
    
    #@nav += "<div style='border-top: 0px solid #666; margin-top: 10px; color: #999;'>#{get_login_user()}</div>"
    
    output("文書管理",html)
    
  end
  
   def docusers()
    
    docuser_id = $_GET["docuser_id"].to_i
    
    obj = DocUsers.new()
    
    html = ""
    if is_admin() then
      html = main(obj)
    else
      docuser_id = 0
    end
    
    if docuser_id > 0 then
      #html = obj.list_all()
      html = obj.edit(docuser_id)
    elsif html == "" then
      #html = obj.get_add_form()
      html = obj.list_all()
    end
    
    @nav += "<div class='title'><a href='./'>戻る</a></div>"
    obj.get_data_with_order("name").each do |row|
      @nav += "<div><a href='docusers.rb?docuser_id=#{row["id"]}'>#{row["name"]}</a></div>"
    end
    @nav += "<div><a href='docusers.rb'>一覧</a></div>"
    
    output("文書管理 - ユーザー",html)
    
  end
  
   def password()
    
    obj = DocUsers.new()
    
    html = obj.get_password_form()
    
    if !is_guest() then
      html += main(obj)
    end
    
    @nav += "<div class='title'><a href='./'>戻る</a></div>"
    
    output("文書管理 - パスワード",html)
    
  end
  
  def files()
    
    obj = Files.new()
    
    html = ""
    if !is_guest() then
      html = main(obj)
    end
    
    $_POST["mode"] = "show_docdata"
    docdatas()
    
  end
  
end