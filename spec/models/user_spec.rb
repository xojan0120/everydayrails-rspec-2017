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

  #it "名がなければ無効な状態であること" do
  #  #user = User.new(first_name: nil)
  #  user = FactoryBot.build(:user, first_name: nil)
  #  user.valid?
  #  expect(user.errors[:first_name]).to include("can't be blank")
  #end
  it { is_expected.to validate_presence_of :first_name }

  #it "姓がなければ無効な状態であること" do
  #  #user = User.new(last_name: nil)
  #  user = FactoryBot.build(:user, last_name: nil)
  #  user.valid?
  #  expect(user.errors[:last_name]).to include("can't be blank")
  #end
  it { is_expected.to validate_presence_of :last_name }

  #it "メールアドレスがなければ無効な状態であること" do
  #  #user = User.new(email: nil)
  #  user = FactoryBot.build(:user, email: nil)
  #  user.valid?
  #  expect(user.errors[:email]).to include("can't be blank")
  #end
  it { is_expected.to validate_presence_of :email }

  #it "重複したメールアドレスなら無効な状態であること" do
  #  #User.create(
  #  #  first_name:   "Joe",
  #  #  last_name:    "Tester",
  #  #  email:        "tester@example.com",
  #  #  password:   "dottle-nouveau-pavilion-tights-furze",
  #  #)
  #  FactoryBot.create(:user, email: "tester@example.com")

  #  #user = User.new(
  #  #  first_name:   "Jane",
  #  #  last_name:    "Tester",
  #  #  email:        "tester@example.com",
  #  #  password:   "dottle-nouveau-pavilion-tights-furze",
  #  #)
  #  user = FactoryBot.build(:user, email: "tester@example.com")

  #  user.valid?
  #  expect(user.errors[:email]).to include("has already been taken")
  #end
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

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

  it "アカウントが作成されたときにウェルカムメールを送信すること" do
    # UserMailerにwelcome_emailメソッドとdeliver_laterメソッドを許可する
    allow(UserMailer).to receive_message_chain(:welcome_email, :deliver_later)

    # userオブジェクトを作成(Userモデルのafter_createコールバックのsend_welcome_email
    # メソッドの内部でwelcome_emailメソッドが呼ばれる)
    user = FactoryBot.create(:user)

    # UserMailer.welcome_emailメソッドが引数userで実行されているか検証
    expect(UserMailer).to have_received(:welcome_email).with(user)
  end

  it "ジオコーディングを実行すること", vcr: true do
    user = FactoryBot.create(:user, last_sign_in_ip: "161.185.207.20")
    expect {
      user.geocode
    }.to change(user, :location).from(nil).to("Brooklyn, New York, US")
  end
end
