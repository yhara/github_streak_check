require 'github_streak_check'
require 'fakeweb'
require 'timecop'

FakeWeb.allow_net_connect = false

describe GithubStreakCheck do
  before do
    @login = "taro"
    @checker = GithubStreakCheck.new(username: @login) 
  end

  describe "#commited_today?" do
    it "<no events> : false" do
      FakeWeb.register_uri(:get,
        "https://api.github.com/users/#{@login}/events?per_page=1",
        body: "[]"
      )
      expect(@checker.commited_today?).to be_false
    end

    it "<yesterday's event> : false" do
      FakeWeb.register_uri(:get,
        "https://api.github.com/users/#{@login}/events?per_page=1",
        body: '[{"created_at":"2013-11-04T10:47:16Z"}]'
                         # == "2013-11-04T02:47:16-08:00"
                       
      )
      Timecop.freeze(Time.parse("2013-11-05T07:00:00-08:00")) do
        expect(@checker.commited_today?).to be_false
      end
    end

    it "<today's event> : true" do
      FakeWeb.register_uri(:get,
        "https://api.github.com/users/#{@login}/events?per_page=1",
        body: '[{"created_at":"2013-11-04T10:47:16Z"}]'
                         # == "2013-11-04T02:47:16-08:00"
                       
      )
      Timecop.freeze(Time.parse("2013-11-04T07:00:00-08:00")) do
        expect(@checker.commited_today?).to be_true
      end
    end

    it "<today's event> <tomorrow's event> : true" do
      FakeWeb.register_uri(:get,
        "https://api.github.com/users/#{@login}/events?per_page=1",
        body: '[{"created_at":"2013-11-05T10:47:16Z"},' +
                         # == "2013-11-05T02:47:16-08:00"
               '{"created_at":"2013-11-04T10:47:16Z"}]'
                         # == "2013-11-04T02:47:16-08:00"
                       
      )
      Timecop.freeze(Time.parse("2013-11-04T07:00:00-08:00")) do
        expect(@checker.commited_today?).to be_true
      end
    end

    # Note: this happens when user is living in Tokyo, for example.
    it "<tomorrow's event> : false" do
      FakeWeb.register_uri(:get,
        "https://api.github.com/users/#{@login}/events?per_page=1",
        body: '[{"created_at":"2013-11-04T10:47:16Z"}]'
                         # == "2013-11-04T02:47:16-08:00"
                       
      )
      Timecop.freeze(Time.parse("2013-11-03T07:00:00-08:00")) do
        expect(@checker.commited_today?).to be_false
      end
    end
  end
end
