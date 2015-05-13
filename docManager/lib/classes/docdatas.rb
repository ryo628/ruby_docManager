class DocDatas < Model
  
  def initialize()
    set_value($db, "docdatas")
    @type = "docdata"
  end
  
  def edit(id)
    
    #vals = @mdl.get_data_by_id(id)
    vals = get_data_by_id(id)
    $_GET["doctype_id"] = get_doctype_id(vals["docgroup_id"])
    return get_edit_form(vals)
    
  end
  
  def show(id)
    
    #vals = @mdl.get_data_by_id(id)
    vals = get_data_by_id(id)
    $_GET["doctype_id"] = get_doctype_id(vals["docgroup_id"])
    return get_show_form(vals)
    
  end
  
  def add()
    
    #vals = @mdl.get_blank_data()
    vals = get_blank_data()
    vals["docgroup_id"] = $_GET["docgroup_id"]
    return get_edit_form(vals)
    
  end
  
  def get_edit_form(vals)
    
    grp = DocGroups.new()
    
    vals["docgroup_id"] = grp.get_select_form("docgroup_id", vals["docgroup_id"])
    
    doctype_id = $_GET["doctype_id"]
    html = load_template(vals, "edit_#{@type}_#{doctype_id}.html")
    return html
    
  end
  
  def get_show_form(vals)
    
    grp = DocGroups.new()
    
    vals["docgroup_id"] = grp.get_name(vals["docgroup_id"])
    
    doctype_id = $_GET["doctype_id"]
    html = load_template(vals, "show_#{@type}_#{doctype_id}.html")
    
    f = Files.new()
    html += f.get_upload_form(vals["id"])
    
    return html
    
  end
  
  def get_find_form()
    
    word = $_POST["word"].to_s
    
    html = <<EOF
<form method="post">
  <input type="hidden" name="mode" value="find_docdata" />
  <table>
    <tr>
      <td><input type="text" name="word" value="#{word}" size=10 /></td>
      <td><input type="submit" name="submit" value="検索" /></td>
    </tr>
  </table>
</form>
EOF
    return html
    
  end
  
  def get_name(id)
    return get_value_by_id("name", id)
  end
  
  def get_doctype_id(docgroup_id)
    grp = DocGroups.new()
    vals = grp.get_data_by_id(docgroup_id)
    return vals["doctype_id"]
  end
  
  def get_select_form(name, id)
    
    #vals = get_data()
    vals = get_data_with_order("name")
    html = "<SELECT name='#{name}'>"
    vals.each do |row|
      tmp = (row["id"].to_i==id.to_i) ? "selected" : ""
      html += "<OPTION value='#{row["id"]}' #{tmp}>#{row["name"]}</OPTION>"
    end
    html += "</SELECT>"
    return html
    
  end
  
  def list_all()
    
    #return get_list_table(get_data())
    #return get_list_table(get_data_with_order("name"))
    
    opt = ""
    
    docgroup_id = $_GET["docgroup_id"].to_i
    if docgroup_id > 0 then
      sql = "SELECT * FROM #{@table} WHERE docgroup_id=#{docgroup_id} ORDER BY num DESC, id DESC;"
      vals = @db.query(sql)
      #vals = get_data_by_value("docgroup_id", docgroup_id)
    else
      sql = "SELECT * FROM #{@table} ORDER BY id DESC LIMIT 10;"
      vals = @db.query(sql)
      #vals = get_data()
      opt = "<h1>新着10件</h1>"
    end
    
    return opt + get_list_table(vals)
    
  end
  
  def list_by_word()
    
    docgroup_id = $_GET["docgroup_id"].to_i
    
    str = ""
    opt = ""
    
    if docgroup_id > 0 then
      str = "AND docgroup_id = #{docgroup_id}"
      grp = DocGroups.new()
      opt = grp.get_name(docgroup_id) + "内の"
    end
    
    sql = "SELECT * FROM #{@table} WHERE title LIKE '%#{$_POST["word"]}%' #{str};"
    vals = @db.query(sql)
    #vals = get_data_by_value("title", $_POST["word"])
    opt = "<h1>#{opt}「#{$_POST["word"]}」検索結果</h1>"
    return opt + get_list_table(vals)
    
  end
  
  def get_add_form()
    
    html = ""
    
    if $_GET["docgroup_id"].to_i > 0 then
      
      html = <<EOF
<form method='post'>
  <input type="hidden" name="id" value="0" />
  <input type="hidden" name="mode" value="add_#{@type}" />
  <input type="submit" name="submit" value="追加" />
</form>
EOF
    end
    
    return html
    
  end
  
  def get_list_table(vals)
    
    debug("doc#{@type}s.get_list_table")
    html = get_add_form()
    
    if vals.length > 0 then
    
    html += <<EOF
<table class="list">
  <tr>
    <th>NO</th>
    <th>件名</th>
    <th>作成</th>
    <th nowrap>ファイル</th>
    <th>&nbsp;</th>
  </tr>
EOF
    end
    
    fl = Files.new()
    typ = DocTypes.new()
    grp = DocGroups.new()
    
    vals.each do |row|
      
      grp_vals = grp.get_data_by_id(row["docgroup_id"])
      grp_name = grp_vals["name"]
      typ_name = typ.get_name(grp_vals["doctype_id"])
      
      psn = ""
      case grp_vals["doctype_id"].to_i
      when 1
        psn = row["item03"]
      when 2
        psn = row["item05"]
      when 3
        psn = row["item04"]
      end
      
      
      html += <<EOF
<tr>
  <td align="center" nowrap>#{row["num"]}</td>
  <td><span style="font-size: 10pt;">[#{typ_name} - #{grp_name}]</span><br />#{row["title"]}</td>
  <td align="center" nowrap>#{psn}</td>
  <td align="left" nowrap>#{fl.get_file_links(row["id"])}</td>
  <td align="center" nowrap>
    <form method='post'>
      <input type="hidden" name="id" value="#{row['id']}" />
      <input type="hidden" name="mode" value="edit_#{@type}" />
      <input type="submit" name="submit" value="編集" /><input type="submit" name="submit" value="表示" onclick="this.form.mode.value='show_#{@type}';" />
    </form>
  </td>
</tr>
EOF
    end
    
    html += "</table>"
    
    return html
    
  end
  
end
    
