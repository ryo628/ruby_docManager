class DocTypes < Model
  
  def initialize()
    set_value($db, "doctypes")
  end
  
  def show(id)
    
    vals = get_data_by_id(id)
    return get_show_form(vals)
    
  end
  
  def edit(id)
    
    #vals = @mdl.get_data_by_id(id)
    vals = get_data_by_id(id)
    return get_edit_form(vals)
    
  end
  
  def add()
    
    #vals = @mdl.get_blank_data()
    vals = get_blank_data()
    
    vals["list_header"] = load_template({}, "list_header.html")
    vals["list_row"] = load_template({}, "list_row.html")
    vals["edit_form"] = load_template({}, "edit_docdata.html")
    vals["show_form"] = load_template({}, "show_docdata.html")
    
    return get_edit_form(vals)
    
  end
  
  def get_list_header(id)
    
    return get_value_by_id("list_header",id)
    
  end
  
  def get_list_row(id)
    
    return get_value_by_id("list_row",id)
    
  end
  
  def get_data_edit_form(id)
    
    return get_value_by_id("edit_form",id)
    
  end
  
  def get_data_show_form(id)
    
    return get_value_by_id("show_form",id)
    
  end
  
  def get_edit_form(vals)
    
    html = load_template(vals, "edit_doctype.html")
    return html
    
  end
  
  def get_show_form(vals)
    
    html = load_template(vals, "show_doctype.html")
    return html
    
  end
  
  def get_name(id)
    return get_value_by_id("name", id)
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
    return get_list_table(get_data_with_order("num"))
    
  end
  
  def get_add_form()
    
    html = <<EOF
<form method='post'>
  <input type="hidden" name="id" value="0" />
  <input type="hidden" name="mode" value="add_doctype" />
  <input type="submit" name="submit" value="追加" />
</form>
EOF
    return html
    
  end
  
  def get_list_table(vals)
    
    debug("docTypes.get_list_table")
    html = get_add_form()
    
    if vals.length > 0 then
    
    html += <<EOF
<table class="list">
  <tr>
    <th>NO.</th>
    <th>文書名</th>
    <th>説明</th>
    <th>&nbsp;</th>
  </tr>
EOF
    end
    
    vals.each do |row|
      html += <<EOF
<tr>
  <td align="center">#{row["num"]}</td>
  <td>#{row["name"]}</td>
  <td>#{row["note"]}</td>
  <td align="center">
    <form method='post'>
      <input type="hidden" name="id" value="#{row['id']}" />
      <input type="hidden" name="mode" value="edit_doctype" />
      <input type="submit" name="submit" value="編集" />
    </form>
  </td>
</tr>
EOF
    end
    
    html += "</table>"
    
    return html
    
  end
  
end
    
