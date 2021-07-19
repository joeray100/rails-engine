class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  class << self
    def paging(per_page, page)
      per_page = 20 if per_page < 0
      page = 1 if page <= 0
      page = (page - 1) * per_page if page > 0
      limit(per_page).offset(page)
    end

    def find_all_merchants(search_parmas)
      where('name ILIKE ?', "%#{search_parmas}%")
      .order(:name)
    end

    def find_item(search_parmas)
      where('name ILIKE ?', "%#{search_parmas}%")
      .order(:name)
      .limit(2)
    end

  end
end
