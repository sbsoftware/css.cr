module CSS
  abstract class MediaQuery
    def &(other)
      AndMediaQuery.new(self, other)
    end
  end
end
