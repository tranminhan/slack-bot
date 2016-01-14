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

      I18n.locale = user.locale
      text = I18n.t "set_locale_success"
      client.say(text: text, channel: data.channel)
    else 
      puts user.locale
      I18n.locale = user.locale
      text = I18n.t "locale_not_available", token: match[:expression]
      client.say(text: text, channel: data.channel)
    end 
  end

  command 'study' do |client, data, match|
    question = FlashCard.order("RANDOM()").first
    # puts question.term

    Rails.cache.write "ans", question.definition
    client.say(text: "What " + question.term + " in Vietnamese?", channel: data.channel)
  end

  command 'ans' do |client, data, match|
    # puts Rails.cache.read("ans")
    # puts match[:expression]
    if Rails.cache.read("ans") == match[:expression]
      client.say(text: "That is correct", channel: data.channel)
    else 
      client.say(text: "That is incorrect", channel: data.channel)
    end 
  end
end