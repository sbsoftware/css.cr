module CSS
  enum Pseudoclass
    Before
    After
    Empty

    def to_s(io : IO)
      io << self.to_s.underscore
    end
  end
end
