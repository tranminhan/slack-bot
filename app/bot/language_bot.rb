class LanguageBot < SlackRubyBot::Bot
  # leave it empty for now
  command 'hello' do |client, data, match|
    # client.say(text: t("hello <#{data.user}>!", channel: data.channel)
    user = User.find_or_create_by(username: data.user) do |u|
      u.locale = :en
    end
    
    I18n.locale = user.locale
    text = I18n.t "hello", user: user.username
    client.say(text: text, channel: data.channel)
  end

  command 'locale' do |client, data, match|
    user = User.find_or_create_by(username: data.user)
    # 
    if I18n.available_locales.map(&:to_s).include? match[:expression]
      user.locale = match[:expression]
      user.save

      text = "Set locale successfully"
      client.say(text: text, channel: data.channel)
    else 
      text = "Incorrect locale"
      client.say(text: text, channel: data.channel)
    end 
  end
end