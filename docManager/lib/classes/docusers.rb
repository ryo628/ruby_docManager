class DocUsers < Model
  
  def initialize()
    set_value($db, "docusers")
    @message = "&nbsp;"
  end
  
  def show(id)
    
    vals = get_data_by_id(id)
    return get_show_form(vals)
    
  end
  
  def edit(id)
    
    vals = get_data_by_id(id)
    vals["auth_type"] = get_select_form(vals["auth_type"])
    return get_edit_form(vals)
    
  end
  
  def add()
    
    vals = get_blank_data()
    vals["auth_type"] = get_select_form(vals["auth_type"])
    return get_edit_form(vals)
    
  end
  
  def get_edit_form(vals)
    
    html = load_template(vals, "edit_docuser.html")
    return html
    
  end
  
  def get_show_form(vals)
    
    html = load_template(vals, "show_docuser.html")
    return html
    
  end
  
  def get_password_form()
    
    vals = get_data_by_str("name", get_login_user())
    
    html = load_template(vals[0], "edit_password.html")
    return html
    
  end
  
  def set_password(vals)
    
    name = get_name(vals["id"])
    password = vals["password"]
    
    html = ""
    
    if password != "" then
      
      #htpd = WEBrick::HTTPAuth::Htpasswd.new('./htpasswd')
      #htpd.set_passwd(nil, name, password)
      #htpd.flush
      
      #cmd = "/usr/bin/sudo /usr/bin/htpasswd -b /html/www/.htpasswd #{name} #{password}"
      #cmd = "htpasswd -b /var/www/.htpasswd #{name} #{password}"
      #html += cmd
      #html += `#{cmd}`
      #html += "<pre>" + `ls -la /var/www/` + "</pre>"
      #html += `/usr/bin/htpasswd -c ./files/.htpasswd #{name} #{password}`
      
      apply(vals)
      
      html += "<div>パスワードを変更しました。</div>"
      
    else
    
      html = "<div>パスワードが空白のため、変更できませんでした。</div>"
    
    end
    
    return html
    
  end
  
  def get_name(id)
    
    return get_value_by_id("name", id)
    
  end
   
  def get_auth_type()
    
    debug("docUsers.get_auth_type()")
    ans = get_data_by_str("name", get_login_user())
    if ans.length > 0 then
      wk = ans[0]["auth_type"]
    else
      wk = ""
    end
    debug(ans)
    return wk
    
  end
  
  def get_select_form(auth_type)
    
    auth_types = ["guest", "user", "admin"]
    
    html = "<SELECT name='auth_type'>"
    auth_types.each do |str|
      tmp = (str==auth_type) ? "selected" : ""
      html += "<OPTION value='#{str}' #{tmp}>#{str}</OPTION>"
    end
    html += "</SELECT>"
    return html
    
  end
  
  def list_all()
    
    return get_list_table(get_data_with_order("name"))
    
  end
  
  def get_add_form()
    
    html = <<EOF
<form method='post'>
  <input type="hidden" name="id" value="0" />
  <input type="hidden" name="mode" value="add_docuser" />
  <input type="submit" name="submit" value="追加" />
</form>
EOF
    return html
    
  end
  
  def get_list_table(vals)
    
    debug("docUsers.get_list_table")
    html = get_add_form()
    
    if vals.length > 0 then
    
    html += <<EOF
<table class="list">
  <tr>
    <th>ID</th>
    <th>権限</th>
    <th>&nbsp;</th>
  </tr>
EOF
    end
    
    vals.each do |row|
      html += <<EOF
<tr>
  <td>#{row["name"]}</td>
  <td>#{row["auth_type"]}</td>
  <td align="center">
    <form method='post'>
      <input type="hidden" name="id" value="#{row['id']}" />
      <input type="hidden" name="mode" value="edit_docuser" />
      <input type="submit" name="submit" value="編集" />
    </form>
  </td>
</tr>
EOF
    end
    
    html += "</table>"
    
    return html
    
  end
  
  def is_login()
    
    debug("docUsers.is_login()")
    
    mode = $_POST["mode"].to_s
    flg = false
    
    debug("mode = #{mode}")
    
    if mode == "logout" then
      $session["user"] = ""
      @message = "ログアウトしました"
    elsif mode == "login" then
      $session["user"] = login()
    end
    
    debug("docUsers.is_login()")
    debug("docUsers : is_login() : " + $session["user"].to_s)
    
    if $session["user"].to_s != "" then
      flg = true
    end
    
    $session.close
    set_auth_type()
    
    debug("flg : #{flg}")
    
    return flg
    
  end
  
  def login()
    
    name = $_POST["name"]
    pass = $_POST["pass"]
    
    if $flg_ad then
      sql = "SELECT * FROM docusers WHERE name = '#{name}'"
    else
      sql = "SELECT * FROM docusers WHERE name = '#{name}' AND password = '#{pass}'"
    end
    tmp = @db.query(sql)
    
    if tmp.length == 0 then
      name = ""
      @message = "ユーザー名またはパスワードが間違っています"
    else
      
      if $flg_ad then
        ad = ADUser.new()
        if ad.exists(name, pass) then
          #
        else
          name = ""
          @message = "ユーザー名またはパスワードが間違っています"
        end
      end
      
    end
    
    debug("docUsers : login() : #{name}")
    debug(tmp.to_s)
    
    return name
    
  end
  
  def get_login_form()
    
    html = <<EOF
<form method="post">
  <input type="hidden" name="mode" value="login" />
  <table>
    <tr>
      <td colspan=2><div id="login_message">_%message%_</div></td>
    </tr>
    <tr>
      <td>ユーザー名</td>
      <td><input type="text" name="name" onFocus="getDiv('login_message').innerHTML='&nbsp;';" /></td>
    </tr>
    <tr>
      <td>パスワード</td>
      <td><input type="password" name="pass" onFocus="getDiv('login_message').innerHTML='&nbsp;';" /></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td><input type="submit" value="ログイン" /></td>
    </tr>
  </table>
</form>
EOF
    
    return make_html_by_values({"message" => @message}, html)
    
  end
  
  def get_logout_form()
    
    option = ""
    
    if $flg_ad == false then
      if !is_guest() then
      option = <<EOF
<input type="button" name="" value="パスワード変更" onClick="location.href='password.rb';" />
EOF
      end
    end
    
    html = <<EOF
<form method="post">
  <input type="hidden" name="mode" value="logout" />
  <input type="submit" name="submit" value="ログアウト" />
  #{option}
</form>
EOF
    
    return html
    
  end
  
end
    
