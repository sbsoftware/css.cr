macro css_enum(name, &blk)
  module ::CSS::Enums
    enum {{name}}
      {{blk.body}}

      def to_css_value
        String.build do |str|
          to_s(str)
        end.underscore.gsub('_', '-')
      end
    end
  end
end
