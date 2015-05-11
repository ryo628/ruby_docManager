class DocManager
  
  def initialize()
    @nav = ""
  end
  
  def main(obj)
    
    mode = $_POST["mode"]
    
    html = ""
    
    #obj = DocTypes.new()
    
    case mode
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
      
    when "edit_docdata"
      debug("EDIT_DOCDATA")
      html += obj.edit($_POST["id"])
    when "add_docdata"
      debug("ADD_DOCDATA")
      html += obj.add()
    when "apply_docdata"
      debug("APPLY_DOCDATA")
      obj.apply($_POST)
      html += obj.list_all()
    else
      debug("ELSE")
      #html += obj.list_all()
    end
    
    return html
    
  end
  
  def output(title, html)
    
    menu = <<EOF
<a href="./">TOP</a>
<a href="doctypes.rb">種類</a>
<a href="docgroups.rb">分類</a>
<a href="docdatas.rb">データ</a>
<a href="docusers.rb">ユーザー</a>
EOF
    
    html += "<div style='clear: both;'>#{$_GET.to_s}</div>"
    
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
    
    html = main()
    output("文書管理",html)
    
  end
  
  def doctypes()
    
    doctype_id = $_GET["doctype_id"].to_i
    
    obj = DocTypes.new()
    html = main(obj)
    
    if doctype_id > 0 then
      #html = obj.list_all()
      html = obj.show(doctype_id)
    elsif html == "" then
      #html = obj.get_add_form()
      html = obj.list_all()
    end
    
    obj.get_data_with_order("num").each do |row|
      @nav += "<div><a href='doctypes.rb?doctype_id=#{row["id"]}'>#{row["name"]}</a></div>"
    end
    
    output("文書管理 - 種類",html)
    
  end
  
  def docgroups()
    
    obj = DocGroups.new()
    html = main(obj)
    if html == "" then
      html = obj.list_all()
    end
    
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
    
    if doctype_id > 0 then
      grp = DocGroups.new()
      grp.get_data_by_value("doctype_id", doctype_id).each do |row|
        @nav += "<div><a href='docdatas.rb?doctype_id=#{doctype_id}&docgroup_id=#{row["id"]}'>#{row["name"]}</a></div>"
      end
    else
      typ = DocTypes.new()
      typ.get_data_with_order("num").each do |row|
        @nav += "<div><a href='docdatas.rb?doctype_id=#{row["id"]}'>#{row["name"]}</a></div>"
      end
    end
    
    output("文書管理 - データ",html)
    
  end
  
   def docusers()
    
    html = main()
    output("文書管理 - ユーザー",html)
    
  end
  
end