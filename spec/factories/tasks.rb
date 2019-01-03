FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "Task #{n}" }

    # projectファクトリと関連する
    association :project
  end
end
