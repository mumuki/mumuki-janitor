class Locale

  def self.all
    %w(es-AR en-US pt-BR)
  end

  def self.first
    self.all.first
  end

  def self.last
    self.all.last
  end

end
