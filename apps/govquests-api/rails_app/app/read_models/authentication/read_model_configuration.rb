module Authentication
  class ReadModelConfiguration
    def call(event_store)
      event_store.subscribe(OnUserRegistered.new, to: [Authentication::UserRegistered])
      event_store.subscribe(OnUserLoggedIn.new, to: [Authentication::UserLoggedIn])
      event_store.subscribe(OnUserTelegramTokenUpdated.new, to: [Authentication::UserTelegramTokenUpdated])
      event_store.subscribe(OnUserNotificationPreferencesUpdated.new, to: [Authentication::UserNotificationPreferencesUpdated])
      event_store.subscribe(OnEmailVerificationSent.new, to: [Authentication::EmailVerificationSent])
      event_store.subscribe(OnEmailVerified.new, to: [Authentication::EmailVerified])
      event_store.subscribe(OnUserTypeUpdated.new, to: [Authentication::UserTypeUpdated])
    end
  end
end
