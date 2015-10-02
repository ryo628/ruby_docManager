class DocGroups < Model
  
  def initialize()
    set_value($db, "docgroups")
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
  
  def get_data_by_doctype_id(id)
    
    sql = "SELECT * FROM #{@table} WHERE doctype_id=#{id} ORDER BY num"
    vals = @db.query(sql)
    
  end
  
  def get_data_by_doctype_id_with_count(id)
    
    wk = get_data_by_doctype_id(id)
    
    wk.each do |row|
    
      sql = <<EOF
SELECT
  COUNT(id) AS datacount
FROM
  docdatas
WHERE
  docgroup_id = #{row["id"]}
GROUP BY docgroup_id
EOF
      
      tmp = @db.query(sql)
      if tmp.length > 0 then
        row["datacount"] = tmp[0]["datacount"]
      else
        row["datacount"] = 0
      end
      
    end
    
    return wk
    
  end
  
  def get_edit_form(vals)
    
    typ = DocTypes.new()
    
    vals["doctype_id"] = $_GET["doctype_id"]
    vals["doctype_name"] = typ.get_name(vals["doctype_id"])
    
    vals["docgroup_id"] = get_select_form("docgroup_id", vals["docgroup_id"])
    
    html = load_template(vals, "edit_docgroup.html")
    return html
    
  end
  
  def get_name(id)
    return get_value_by_id("name", id)
  end
  
  def get_select_form(name, id)
    
    #vals = get_data()
    #vals = get_data_with_order("name")
    #vals = get_data_by_value("doctype_id", $_GET["doctype_id"].to_i)
    vals = get_data_by_doctype_id($_GET["doctype_id"].to_i)
    
    html = "<SELECT name='#{name}'>"
    html += "<option value=''></option>"
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
    #return get_list_table(get_data_with_order("name"))
    #return get_list_table(get_data_by_value("doctype_id",$_GET["doctype_id"].to_i))
    
    return get_list_table(get_data_by_doctype_id($_GET["doctype_id"].to_i))
    
  end
  
  def get_add_form()
    
    html = ""
    
    if $_GET["doctype_id"].to_i > 0 then
      html = <<EOF
<form method='post'>
  <input type="hidden" name="id" value="0" />
  <input type="hidden" name="mode" value="add_docgroup" />
  <input type="submit" name="submit" value="追加" />
</form>
EOF
    end
    
    return html
    
  end
  
  def get_list_table(vals)
    
    debug("docTypes.get_list_table")
    html = get_add_form()
    
    if vals.length > 0 then
    
      html += <<EOF
<table class="list">
  <tr>
    <th>番号</th>
    <th>分類名</th>
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
      <input type="hidden" name="mode" value="edit_docgroup" />
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
    
