require 'rails_helper'

RSpec.describe Note, type: :model do

  it "ファクトリで関連するデータを生成する" do
    note = FactoryBot.create(:note)
    puts "This note's project is #{note.project.inspect}"
    puts "This note's project is #{note.user.inspect}"
  end

  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project, owner: user) }

  it "ユーザー、プロジェクト、メッセージがあれば有効な状態であること" do
    note = Note.new(
      message: "This is a sample note.",
      user:    user,
      project: project,
    )

    expect(note).to be_valid
  end

  it "メッセージがなければ無効な状態であること" do
    note = Note.new(message: nil)
    note.valid?
    expect(note.errors[:message]).to include("can't be blank")
  end

  describe "文字列に一致するメッセージを検索する" do

    # letは遅延読み込み、let!は遅延読み込みされず即座にブロックを実行する
    # ここをletのままにすると、後述のexpect(Note.count).to eq 3がパスしなくなる
    # これは、expect(Note.count).to eq 3を含むitの中で、note1,note2,note3を
    # 呼び出す処理がないため、それらのオブジェクトが作成されないため。
    let!(:note1) {
      FactoryBot.create(:note, project: project, user: user, message: "This is the first note.")
    }
    let!(:note2) {
      FactoryBot.create(:note, project: project, user: user, message: "This is the second note.")
    }
    let!(:note3) {
      FactoryBot.create(:note, project: project, user: user, message: "First, preheat the oven.")
    }

    context "一致するデータが見つかるとき" do
      it "検索文字列に一致するメモを返すこと" do
        expect(Note.search("first")).to     include(note1, note3)
      end
    end

    context "一致するデータが1件も見つからないとき" do
      it "検索結果が1件も見つからなければ空のコレクションを返すこと" do
        expect(Note.search("message")).to be_empty
        expect(Note.count).to eq 3
      end
    end
  end
  
end
