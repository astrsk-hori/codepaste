class Page < ActiveRecord::Base
  belongs_to :user
  has_many :comments, :dependent => :destroy

  validates_presence_of :title
  validates_presence_of :body

  default_scope -> {
    where(is_private: false)
  }

  scope :search_body, ->(keyword) {
    if keyword.present?
      where "body like :keyword", keyword: "%#{keyword}%"
    else
      all
    end
  }

  scope :search_tag, ->(keyword) {
    if keyword.present?
      where "tag like :keyword", keyword: "%#{keyword}%"
    else
      all
    end
  }

  scope :search, -> (keyword) {
    where "body like :keyword or tag like :keyword", keyword: "%#{keyword}%"
  }

  scope :opened, -> {
    where(is_private: false)
  }

  scope :closed, -> (user_id){
    unscope(where: :is_private).where(is_private: true).where(user_id: user_id)
  }
end
