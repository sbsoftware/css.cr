macro css_enum(name, &blk)
  module ::CSS::Enums
    enum {{name}}
      {{blk.body}}

      def to_s(io : IO)
        io << String.build do |str|
          super(str)
        end.underscore.gsub('_', '-')
      end
    end
  end
end
