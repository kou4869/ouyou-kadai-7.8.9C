class Message < ApplicationRecord
  # ↓ 勝手に追加される
  belongs_to :user
  belongs_to :room
  
  validates :message, presence: true, length: { maximum: 140 } 
end
