class Room < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :entries, dependent: :destroy
  # ↓ 勝手に追加される
  belongs_to :user
end
