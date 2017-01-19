class Tempfile
  def self.write!(content)
    file = Tempfile.new 'tmp'
    begin
      file.write content
    ensure
      file.close
    end
    file
  end
end
