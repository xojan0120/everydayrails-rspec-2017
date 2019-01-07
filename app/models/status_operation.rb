class StatusOperation < ApplicationRecord

  def self.complete(model)
    model.update_attributes(completed: true)
  end

  def self.incomplete(model)
    model.update_attributes(completed: false)
  end

end
