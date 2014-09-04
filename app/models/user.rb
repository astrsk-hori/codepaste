class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :pages
  has_many :comments

  validates_presence_of :name

  def last_pages
    pages.opened.order('id desc').limit(10)
  end
end
