class Person < ActiveRecord::Base
  has_many :members
  has_many :groups, through: :members
  has_many :person_slot_restrictions
  has_many :slot_restrictions, through: :person_slot_restrictions, source: :slot
  has_many :scheduled_spots
  has_many :slots, through: :scheduled_spots

  validates :email,
    presence: true,
    format: {
      with: /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
      message: "is invalid"
    }

  def self.all_by_availability
    get_all_with_availability_count.order("restrictions_count ASC")
  end

  def self.all_by_unavailability
    get_all_with_availability_count.order("restrictions_count DESC")
  end

  def self.create_from_list(email_list, group = nil)
    emails = Modules::EmailList.parse(email_list)

    if(emails.size > 90)
      nil
    else
      bad_emails = []
      emails.each do |email|
        person = Person.new(email: email)
        if(!person.save)
          bad_emails << person
        else
          group.people << person if group
        end
      end
      bad_emails
    end
  end

  def name
    if((first_name && first_name.length > 0) && (!last_name || last_name.length == 0))
      first_name
    elsif((!first_name || first_name.length == 0) && (last_name && last_name.length > 0))
      last_name
    elsif((last_name && last_name.length > 0) && (first_name && first_name.length > 0))
      "#{first_name} #{last_name}"
    else
      nil
    end
  end

  def add_restriction(slot)
    slot_restrictions << slot
  end

  def remove_restriction(slot)
    slot_restrictions.destroy(slot)
  end

  private

  def self.get_all_with_availability_count
    select("people.*, COUNT(person_slot_restrictions.id) AS restrictions_count").
      joins("LEFT JOIN person_slot_restrictions ON person_slot_restrictions.person_id = people.id").
      group("people.id")
  end


end
