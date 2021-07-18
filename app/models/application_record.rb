class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  class << self
    def paging(per_page, page)
      per_page = 20 if per_page < 0
      page = 1 if page <= 0
      page = (page - 1) * per_page if page > 0
      limit(per_page).offset(page)
    end
  end
end
