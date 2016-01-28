require 'pg'

class PostgressAdapter
  @con = nil

  def initialize
    begin
      @con = PG.connect :dbname => 'crates_training', :user => 'crates', :password => 'crates'
      @con.exec "CREATE TABLE IF NOT EXISTS requests (status boolean)"
    rescue PG::Error => e
      puts e.message
    ensure
      # @con.close if @con
    end
  end

  def log_request(status)
    if status == 200
      @con.exec  "INSERT INTO requests VALUES (TRUE);"
    else
      @con.exec  "INSERT INTO requests VALUES (FALSE);"
    end
  end

  def successful_count
    sc = @con.exec "SELECT COUNT(*) FROM requests WHERE status IS TRUE"
    sc.getvalue(0,0)
  end

  def failed_count
    sc = @con.exec "SELECT COUNT(*) FROM requests WHERE status IS FALSE"
    sc.getvalue(0,0)
  end

  def total_count
    sc = @con.exec "SELECT COUNT(*) FROM requests"
    sc.getvalue(0,0)
  end
end