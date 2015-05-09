
class Model
  
  def initialize(db, table)
    @db = db
    @table = table
  end
  
  def get_data_by_id(id)
    sql = "SELECT * FROM #{@table} WHERE id=#{id}"
    return @db.query(sql)[0]
  end
  
  def get_blank_data()
    
    vals = {}
    @db.list_fields(@table).each do |f|
      vals[f] = ""
    end
    return vals
    
  end
  
  def apply(values)
    
    if values.has_key?('id') then
      id = values['id'].to_s
    else
      id = 0
    end
    
    if 1 > id.to_i
      values["id"] = get_max_id() + 1
	  #print "#{values["id"]}<br>"
      sql = insert(values)
    else
      sql = update(values, id)
    end
    
    #print sql
    @db.exec(sql)
    
  end
  
  def insert(values)
  
    sql = "INSERT INTO `#{@table}` "
    
    col = ""
    val = ""
    fields = @db.list_fields()
    #debug_print rs.num_fields()
    
    fields.each do |fd|
      #debug_print fd.name + "<br />"
      if values.has_key?(fd) then
        if col != "" then
          col += ","
          val += ","
        end
        col += fd
        val += "'" + escape_string(values[fd].to_s) + "'"
      end
    end
    
    sql += "(#{col}) VALUES (#{val})"
    return sql
    
  end
  
  def update(values, id)
    
    sql = "UPDATE `#{@table}` SET "
    col = ""
    
    rs = @db.list_fields()
    #debug_print "#{table}<br />"
    
    rs.each do |fd|
      #debug_print fd.name + "<br />"
      #print values[fd] + "<br />"
      if values.has_key?(fd) then
        if col != "" then
          col += ","
        end
        col += "#{fd}='" + escape_string(values[fd].to_s) + "'"
      end
    end
    
    sql += "#{col} WHERE id=#{id}"
    return sql
    
  end
  
  def delete(id)
    
    sql = "DELETE FROM `#{@table}` WHERE id=#{id}"
    #print sql
    exec(sql)
    
  end
  
  def setup()
    sql = <<EOF
CREATE TABLE `persons`(
  id integer primary key,
  name text,
  year integer,
  country text,
  note text
)
EOF
    #@db.execute(sql)
    sql = <<EOF
CREATE TABLE `words`(
  id integer primary key,
  person_id integer,
  words text
)
EOF
    #@db.execute(sql)
    
  end
  
end
