FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "Project #{n}" }
    description "A test project."
    due_on 1.week.from_now
    completed false
    # ownerファクトリ(本名はuserファクトリ)と関連する
    association :owner
    
    # [コールバック付きトレイト]メモ付きのプロジェクト
    trait :with_notes do
      after(:create) { |project| create_list(:note, 5, project: project) }
    end

    # 昨日が締め切りのプロジェクト
    factory :project_due_yesterday do
      due_on 1.day.ago
    end

    # 今日が締め切りのプロジェクト
    factory :project_due_today do
      # Date.current.in_time_zoneで本日の０時が取得できる
      due_on Date.current.in_time_zone
    end

    # 明日が締め切りのプロジェクト
    factory :project_due_tomorrow do
      due_on 1.day.from_now
    end

    # 無効になっている
    trait :invalid do
      name nil
    end
  end

=begin
  # 昨日が締め切りのプロジェクト
  factory :project_due_yesterday, class: Project do
    sequence(:name) { |n| "Project #{n}" }
    description "A test project."
    due_on 1.day.ago

    # ownerファクトリ(本名はuserファクトリ)と関連する
    association :owner
  end

  # 今日が締め切りのプロジェクト
  factory :project_due_today, class: Project do
    sequence(:name) { |n| "Project #{n}" }
    description "A test project."

    # Date.current.in_time_zoneで本日の０時が取得できる
    due_on Date.current.in_time_zone

    # ownerファクトリ(本名はuserファクトリ)と関連する
    association :owner
  end

  # 明日が締め切りのプロジェクト
  factory :project_due_tomorrow, class: Project do
    sequence(:name) { |n| "Project #{n}" }
    description "A test project."

    due_on 1.day.from_now

    # ownerファクトリ(本名はuserファクトリ)と関連する
    association :owner
  end
=end
end
