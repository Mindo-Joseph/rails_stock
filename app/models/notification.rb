class Notification < ApplicationRecord
  belongs_to :product

  enum status: { unread: 0, read: 1 }

  scope :recent, -> { order(created_at: :desc).limit(10) }
  scope :unread, -> { where(read_at: nil) }
end
