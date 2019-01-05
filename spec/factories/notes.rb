FactoryBot.define do
  factory :note do
    message     "My important note."

    # projectファクトリと関連する
    association :project
    #association :user
    
    user { project.owner }

    # 下記のようなトレイトを用意することで、
    # テスト内でFactoryBot.create(:note, :with_attachment)と書けば
    # 添付ファイルが付いた状態のNoteオブジェクトが作れる
    #trait :with_attachment do
    #  attachment { File.new("#{Rails.root}/spec/files/attachment.jpg") }
    #end
  end
end
