class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  
  class << self

    def paging(per_page, page)
      if per_page < 0 || per_page == nil
        20
      end
      if page <= 0 || page == nil
        1
      end

      limit(per_page).offset((page - 1) * per_page)
    end

  end
end
