# frozen_string_literal: true

class ApplicationDomain
  def ==(other)
    return false unless other.is_a?(self.class)

    @id == other.id
  end
end
