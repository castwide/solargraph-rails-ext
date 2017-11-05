module SolargraphRailsExt
  module ProcessMethods
    def can_posix?
      Signal.list.include?("HUP")
    end
  end
end
