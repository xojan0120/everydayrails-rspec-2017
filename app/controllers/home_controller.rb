class HomeController < ApplicationController

  # authenticate_user!は認証gemのdeviseによって提供されるメソッド
  # before_action :authenticate_user!とControllerの先頭に記載する
  # ことで、そのControllerで定義されているアクションは、認証済み
  # ユーザのみアクセスできることになる。
  # なお、ここでは、skip_before_actionになっているので、認証されて
  # いないユーザがここで定義されているアクションにアクセスできる。
  skip_before_action :authenticate_user!

  def index
  end
end
