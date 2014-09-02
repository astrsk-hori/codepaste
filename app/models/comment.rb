class Comment < ActiveRecord::Base
  belongs_to :page, :touch => true
  belongs_to :user

  validates_presence_of :comment
end
