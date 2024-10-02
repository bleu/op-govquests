module Authentication
  class UserType < Dry::Struct
    values :delegate, :non_delegate
  end

  class EmailAddress < Dry::Struct
    def initialize(value)
      super
      raise "Invalid email format" unless URI::MailTo::EMAIL_REGEXP.match?(value)
    end
  end
end
