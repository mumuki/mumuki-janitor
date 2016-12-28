class Mumukit::Auth::Permissions
  def protect_delegation!(other)
    other ||= {}
    raise Mumukit::Auth::UnauthorizedAccessError unless delegate_to?(Mumukit::Auth::Permissions.parse(other.to_h))
  end
end
