class DocTypes < Model
  
  def initialize()
    set_value($db, "doctypes")
  end
  
  def edit(id)
    
    #vals = @mdl.get_data_by_id(id)
    vals = get_data_by_id(id)
    return get_edit_form(vals)
    
  end
  
  def add()
    
    #vals = @mdl.get_blank_data()
    vals = get_blank_data()
    return get_edit_form(vals)
    
  end
  
  def get_edit_form(vals)
    
    html = load_template(vals, "edit_doctype.html")
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
    return get_list_table(get_data_with_order("name"))
    
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
    html += <<EOF
<table class="list">
  <tr>
    <th>文書名</th>
    <th>説明</th>
    <th>&nbsp;</th>
  </tr>
EOF
    
    vals.each do |row|
      html += <<EOF
<tr>
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
    
