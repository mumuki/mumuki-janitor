class Hash
  def defaults(hash)
    hash.merge(self.delete_if {|k, v| v.nil? and hash[k] })
  end
end
