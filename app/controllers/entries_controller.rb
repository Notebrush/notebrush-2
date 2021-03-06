class EntriesController < ApplicationController
    before_action :set_entry, only: [:show, :edit, :update, :destroy, :vote, :unvote, :repost, :report]
  before_filter :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  respond_to :html

  def index
    @entries = Entry.all.order(created_at: :desc)
    if params[:search]
        @entries = Entry.search(params[:search]).order("created_at DESC")
    else
        @entries = Entry.all.order('created_at DESC')
    end
  end

  def show
    respond_with(@entry)
  end

  def new
    @entry = Entry.new
    respond_with(@entry)
  end

  def edit
  end

  def create
    @entry = Entry.new(entry_params)
    @entry.user_id = current_user.id
    @entry.tag_list.add(@entry.tag, parse: true)
    @entry.save
    respond_with(@entry)
  end

  def update
    @entry.tag_list = @entry.tag_list.add(@entry.tag, parse: true)
    @entry.update(entry_params)
    respond_with(@entry)
  end

  def destroy
    @entry.destroy
    respond_with(@entry)
  end
    
  def vote
    @entry.liked_by current_user
    @entry.total_votes = @entry.votes_for.size
    redirect_to @entry
  end
  
  def unvote
      @entry.unliked_by current_user
      @entry.total_votes=@entry.votes_for.size
      redirect_to @entry
  end
    
 def report
     flash.alert = "Thank you for flagging this video. We will review it and take appropriate actions."
      @entry.update_attributes(:report_flag => true)
      respond_with(@entry)
  end
    
  private
    def set_entry
      @entry = Entry.find(params[:id])
    end

    def entry_params
      params.require(:entry).permit(:title, :description, :user_id, :tag, :reel, :tag_list, :album_id, :total_votes)
    end
end
