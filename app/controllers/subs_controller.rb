class SubsController < ApplicationController
  before_action :require_login!, only: [:new, :create]
  before_action :moderator?, only: [:edit, :update]

  def index
    @subs = Sub.all
    render :index
  end

  def new
    @sub = Sub.new
    render :new
  end

  def create
    @sub = Sub.new(sub_params)
    if @sub.save
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :new
    end
  end

  def show
    @sub = Sub.find_by_id(params[:id])
    render :show
  end

  def edit
    @sub = Sub.find_by_id(params[:id])
    render :edit
  end

  def update
    @sub = Sub.find_by_id(params[:id])
    @sub.update_attributes(sub_params)
    redirect_to sub_url(@sub)
  end

  private
  def sub_params
    params.require(:sub).permit(:moderator_id, :title, :description)
  end

  def moderator?
    @sub = Sub.find_by_id(params[:id])
    unless @sub.moderator_id == current_user.id
      flash.now[:errors] = "Only moderators allowed to edit this Sub!"
      redirect_to sub_url(@sub)
    end
  end
end
