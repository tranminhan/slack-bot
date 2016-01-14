class LanguageBot < SlackRubyBot::Bot
  # leave it empty for now
  command 'hello' do |client, data, match|
    # client.say(text: t("hello <#{data.user}>!", channel: data.channel)
    user = User.find_or_create_by(username: data.user) do |u|
      u.locale = :en
    end
    puts data
    puts user.locale
    I18n.locale = user.locale
    text = I18n.t "hello", user: user.username
    client.say(text: text, channel: data.channel)
  end
end