class MeetingsController < ApplicationController
  def index
    if params[:tag]
      @meetings = Tag.find_by(name: params[:tag]).meetings
    else
      @meetings = Meeting.all
    end
    render 'index.html.erb'
  end

  def show
    @meeting = Meeting.find_by(id: params[:id])
    render 'show.html.erb'
  end

  def new
    @meeting = Meeting.new(start_time: DateTime.now, end_time: 1.hour.from_now)
    @tags = Tag.all
  end

  def create
    @meeting = Meeting.new(
    name: params[:name],
    address: params[:address],
    start_time: params[:start_time],
    end_time: params[:end_time],
    notes: params[:notes]
    )
    if @meeting.save
      params[:tag_ids].each do |tag_id|
      MeetingTag.create(meeting_id: @meeting.id, tag_id: tag_id )
      end
      flash[:success] = "Meeting was successfully  saved!"
      redirect_to "/meetings"
    else
      @tags = Tag.all
      flash[:error] = "Sorry, could not save meeting!"
      render 'new'
    end
  end

  def edit
    @meeting = Meeting.find_by(id: params[:id])
    @tags = @meeting.tags
  end

  def update
    @meeting = Meeting.find_by(id: params[:id])
    if @meeting.update(
        name: params[:name],
        address: params[:address],
        start_time: params[:start_time],
        end_time: params[:end_time],
        notes: params[:notes]
        )
        flash[:success] = "Meeting was successfully  updated!"
        redirect_to "/meetings"
      else
      flash[:error] = "Sorry, could not update meeting!"
      render 'new'
    end
  end
end
