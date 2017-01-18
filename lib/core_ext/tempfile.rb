class Tempfile
  def self.with(content)
    file = Tempfile.new('tmp')
    file.write content
    file.close
    file
  end
end