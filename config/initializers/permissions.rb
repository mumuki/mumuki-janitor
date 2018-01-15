class Mumukit::Auth::Permissions
  def protect_delegation!(other, previous)
    other ||= {}
    raise Mumukit::Auth::UnauthorizedAccessError unless delegate_to?(Mumukit::Auth::Permissions.parse(other.to_h), previous)
  end
end
