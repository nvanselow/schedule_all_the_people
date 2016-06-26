class EmailList
  def self.parse(email_string)
    email_string.strip!
    email_string.split(/,\s?/)
  end
end
