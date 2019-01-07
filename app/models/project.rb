class Project < ApplicationRecord
  validates :name, presence: true, uniqueness: { scope: :user_id }

  belongs_to :owner, class_name: 'User', foreign_key: :user_id
  has_many :notes
  has_many :tasks

  def late?
    due_on.in_time_zone < Date.current.in_time_zone
  end

  def complete
    update_attributes(completed: true)
  end

  def incomplete
    update_attributes(completed: false)
  end
end
