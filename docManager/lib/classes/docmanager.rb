class DocManager
  
  def initialize()
    
  end
  
  def main()
    
    mode = $_POST["mode"]
    
    html = ""
    
    obj = DocTypes.new()
    
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
    else
      debug("ELSE")
      html += obj.list_all()
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
    
    wk = {
      "title" => title,
      "head" => title,
      "menu" => menu,
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
    
    html = main()
    output("文書管理 - 種類",html)
    
  end
  
  def docgroups()
    
    html = main()
    output("文書管理 - 分類",html)
    
  end
  
  def docdatas()
    
    html = main()
    output("文書管理 - データ",html)
    
  end
  
   def docusers()
    
    html = main()
    output("文書管理 - ユーザー",html)
    
  end
  
end