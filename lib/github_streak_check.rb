require "github_streak_check/version"
require 'open-uri'
require 'json'
require 'date'
require 'pony'

class GithubStreakCheck
  def initialize(opts)
    @opts = opts
  end

  def run
    if commited_today?
      puts "Check OK: you've already done today's contribution."
      exit 0
    else
      msg = "Check failed: You have not extended today's streak yet"
      $stderr.puts msg
      if (addr = @opts[:mail_to])
        ret = Pony.mail(to: addr,
                        from: addr,
                        subject: "GithubStreakCheck",
                        body: msg)
        puts "Sent mail: #{ret.inspect}"
      end
      exit 1
    end
  end

  def commited_today?
    json = JSON.parse(open("https://api.github.com/users/#{@opts[:username]}/events?per_page=1").read)
    return false if json.length == 0

    event = json.first
    event_time = Time.parse(event["created_at"])

    return (event_time.to_date == Date.today)
  end
end
