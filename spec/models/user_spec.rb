require 'rails_helper'

RSpec.describe User, type: :model do

  it "有効なファクトリを持つこと" do
    expect(FactoryBot.build(:user)).to be_valid
  end

  it "姓、名、メール、パスワードがあれば有効な状態であること" do
    user = User.new(
      first_name: "Aaron",
      last_name:  "Sumner",
      email:      "tester@example.com",
      password:   "dottle-nouveau-pavilion-tights-furze",
    )

    expect(user).to be_valid
  end

  it "名がなければ無効な状態であること" do
    #user = User.new(first_name: nil)
    user = FactoryBot.build(:user, first_name: nil)
    user.valid?
    expect(user.errors[:first_name]).to include("can't be blank")
  end

  it "姓がなければ無効な状態であること" do
    #user = User.new(last_name: nil)
    user = FactoryBot.build(:user, last_name: nil)
    user.valid?
    expect(user.errors[:last_name]).to include("can't be blank")
  end

  it "メールアドレスがなければ無効な状態であること" do
    #user = User.new(email: nil)
    user = FactoryBot.build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it "重複したメールアドレスなら無効な状態であること" do
    #User.create(
    #  first_name:   "Joe",
    #  last_name:    "Tester",
    #  email:        "tester@example.com",
    #  password:   "dottle-nouveau-pavilion-tights-furze",
    #)
    FactoryBot.create(:user, email: "tester@example.com")

    #user = User.new(
    #  first_name:   "Jane",
    #  last_name:    "Tester",
    #  email:        "tester@example.com",
    #  password:   "dottle-nouveau-pavilion-tights-furze",
    #)
    user = FactoryBot.build(:user, email: "tester@example.com")

    user.valid?
    expect(user.errors[:email]).to include("has already been taken")
  end

  it "ユーザーのフルネームを文字列として返すこと" do
    #user = User.new(
    #  first_name:     "John",
    #  last_name:      "Doe",
    #  email:          "johndoe@example.com",
    #)
    user = FactoryBot.build(:user, first_name: "John", last_name: "Doe")

    expect(user.name).to eq "John Doe"
  end

  it "複数のユーザーで何かする" do
    user1 = FactoryBot.create(:user)
    user2 = FactoryBot.create(:user)
    expect(true).to be_truthy
  end

end
