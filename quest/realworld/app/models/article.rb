class Article < ApplicationRecord
  validates :slug, :title, :description, :body, presence: true
  before_validation :set_slug, if: :title_changed?

  def set_slug
    self.slug = title.downcase.gsub(" ", "-")
  end
end
