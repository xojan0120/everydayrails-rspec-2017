FactoryBot.define do
  factory :note do
    message     "My important note."

    # projectファクトリと関連する
    association :project
    #association :user
    
    user { project.owner }
  end
end
