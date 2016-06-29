class GroupsController < ApplicationController
  before_filter :authorize

  def index
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
    @people = @group.people
    @person = Person.new
  end

  def new
    @group = Group.new
    @people = []
  end

  def create
    @group = Group.new(group_params)
    @group.user = current_user

    if(@group.save)
      flash[:success] = "Group Created!"
      redirect_to group_path(@group.id)
    else
      flash[:alert] = "There was a problem creating that group."
      @errors = @group.errors.full_messages
      render "groups/new"
    end
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])

    if(@group.update(group_params))
      flash[:success] = "Group Updated!"
      redirect_to group_path(@group.id)
    else
      flash[:alert] = "There was a problem updating the group."
      @errors = @group.errors.full_messages
      render "groups/edit"
    end
  end

  def destroy
    Group.destroy(params[:id])
    flash[:success] = "Group deleted!"
    redirect_to groups_path
  end

  private

  def group_params
    params.require(:group).permit(:name)
  end

end
