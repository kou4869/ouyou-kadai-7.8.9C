class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  has_many :book_comments, dependent: :destroy
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  
  #検索方法の分岐
  def self.search_for(word, method)
    if method == 'perfect'
      Book.where(title: word)
    elsif method == 'forward'
      Book.where('title LIKE ?', word + '%')
    elsif method == 'backward'
      Book.where('title LIKE ?', '%' + word)
    else
      Book.where('title LIKE ?', '%' + word + '%')
    end
  end
  
  
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  
  
end
