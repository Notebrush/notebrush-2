class PagesController < ApplicationController
  def home
      @entries = Entry.take(6)
  end

    def feed
        @user = current_user
        @following = @user.following
        @followers = @user.followers
        @entries =  current_user.feed
    end

  def elements
  end

  def forms
  end
end
