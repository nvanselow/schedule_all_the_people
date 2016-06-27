class PeopleController < ApplicationController
  def create
    @group = Group.find(params[:group_id])
    if(params[:email_list])
      create_from_list
    else
      @person = Person.new(person_params)

      if(@person.save)
        @group.people << @person
        flash[:success] = "Person added!"
        redirect_to group_path(@group)
      else
        @people = @group.people
        flash[:alert] = "There was a problem adding that person."
        @errors = @person.errors.full_messages
        render 'groups/show'
      end
    end
  end

  def destroy
    Person.destroy(params[:id])
    flash[:success] = "Person removed from group."
    redirect_to group_path(params[:group_id])
  end

  private

  def create_from_list
    bad_emails = Person.create_from_list(params[:email_list], @group)
    if(bad_emails == nil)
      flash[:alert] = "That are too many emails. Reduce the number of emails and try again."
      @people = @group.people
      @person = Person.new
      render 'groups/show'
    elsif(bad_emails.empty?)
      flash[:success] = "People added!"
      redirect_to group_path(@group)
    else
      flash[:alert] = "There was a problem with some of the emails you provided."
      @people = @group.people
      @person = Person.new
      @email_list_errors = []
      bad_emails.each do |person|
        @email_list_errors << person.email
      end
      render 'groups/show'
    end
  end

  def person_params
    params.require(:person).permit(:email, :first_name, :last_name)
  end
end
