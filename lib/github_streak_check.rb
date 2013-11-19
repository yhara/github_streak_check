require "github_streak_check/version"
require 'open-uri'
require 'json'
require 'active_support/time'
require 'pony'

class GithubStreakCheck
  def initialize(opts)
    @opts = opts

    @pst = ActiveSupport::TimeZone["Pacific Time (US & Canada)"]
  end

  def run
    if commited_today?
      puts "Check OK: you've already done today(#{@pst.today} PST)'s contribution."
      exit 0
    else
      msg = "Check failed: You have not extended today(#{@pst.today} PST)'s streak yet"
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
    events = JSON.parse(get_status)
    return false if events.length == 0

    return events.any?{|event|
      Time.parse(event["created_at"]).in_time_zone(@pst).to_date == @pst.today
    }
  end

  MAX_TRY = 5
  def get_status
    try = 1
    begin
      open("https://api.github.com/users/#{@opts[:username]}/events?per_page=300").read
    rescue OpenURI::HTTPError => ex
      if try == MAX_TRY
        raise
      else
        puts "#{ex.message} (#{ex.class})"
        sleep 30

        try += 1
        retry
      end
    end
  end
end
