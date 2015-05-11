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
    
    docgroup_id = $_GET["docgroup_id"].to_i
    if docgroup_id > 0 then
      vals = get_data_by_value("docgroup_id", docgroup_id)
    else
      vals = get_data()
    end
    
    return get_list_table(vals)
    
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
    <th>件名</th>
    <th>説明</th>
    <th>&nbsp;</th>
  </tr>
EOF
    end
    
    vals.each do |row|
      html += <<EOF
<tr>
  <td>#{row["title"]}</td>
  <td>#{row["note"]}</td>
  <td align="center">
    <form method='post'>
      <input type="hidden" name="id" value="#{row['id']}" />
      <input type="hidden" name="mode" value="edit_#{@type}" />
      <input type="submit" name="submit" value="編集" />
      <input type="submit" name="submit" value="表示" onclick="this.form.mode.value='show_#{@type}';" />
    </form>
  </td>
</tr>
EOF
    end
    
    html += "</table>"
    
    return html
    
  end
  
end
    
