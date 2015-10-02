require 'net/ldap'

class ADUser
  
  def initialize()
    
    @host = "000.000.000.000"
    @port = "389"
    @domain = "@yourdomain"
    
  end
  
  def exists(name, pass)
    
    flg = false
    
    if name != "" && pass != "" then
      
      ldap = Net::LDAP.new(
        :host => @host,
        :port => @port,
        :auth => {
          :method => :simple,
          :username => "#{name}#{@domain}",
          :password => pass
        }
      )
      
      flg = ldap.bind
      
      f = File.open($currentDir + "aduser.log",'a')
      f << "#{Time.now} [#{name}] #{flg}\n"
      f.close()
      
    end
    
    return flg
    
  end
  
end
