namespace :telegram do
  desc "Start the Telegram bot server"
  task start: :environment do
    require "telegram/bot"
    TelegramBotServer.new.start
  end
end
