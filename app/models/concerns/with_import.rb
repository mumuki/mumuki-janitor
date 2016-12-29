module WithImport

  def import_from_json!(data)
    where(uid: data[:uid]).assign_first(data).save!
  end

end

