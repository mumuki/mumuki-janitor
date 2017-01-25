class Locale

  def self.all
    %w(es-AR en-US)
  end

  def self.first
    self.all.first
  end

  def self.last
    self.all.last
  end

end
