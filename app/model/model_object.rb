module EQBeats
  class ModelObject
    attr_accessor :id, :detail, :html_description, :link, :plain_detail

    def detail=(detail)
      @detail = detail
      self.plain_detail = self.detail.gsub(/\[([^\]=]*)[^\]]*\](.*)\[\/\1\]/i, '\2')
    end
  end
end
