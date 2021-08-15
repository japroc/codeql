class BarsController < ApplicationController

  helper_method :user_name, :user_name_memo

  def index
    render template: "foo/bars/index"
  end

  def user_name
    return params[:user_name]
  end

  def user_name_memo
    @user_name ||= params[:user_name]
  end

  def show
    @user_website = params[:website]
    dt = params[:text]
    render "foo/bars/show", locals: { display_text: dt, safe_text: "hello" }
  end
end
