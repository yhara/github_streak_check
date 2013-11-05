require 'github_streak_check'
require 'fakeweb'
require 'timecop'

FakeWeb.allow_net_connect = false

describe GithubStreakCheck do
  before do
    @login = "taro"
  end

  describe "#commited_today?" do
    context "When no event was found" do
      before do
        FakeWeb.register_uri(:get,
          "https://api.github.com/users/#{@login}/events?per_page=1",
          body: "[]"
        )
      end

      it "should return false" do
        expect(GithubStreakCheck.new(@login).commited_today?).to be_false
      end
    end

    context "When today's event was not found" do
      before do
        FakeWeb.register_uri(:get,
          "https://api.github.com/users/#{@login}/events?per_page=1",
          body: '[{"created_at":"2013-11-04T10:47:16Z"}]'
        )
      end

      it "should return false" do
        Timecop.freeze(Date.new(2013, 11, 5)) do
          expect(GithubStreakCheck.new(@login).commited_today?).to be_false
        end
      end
    end

    context "When today's event was found" do
      before do
        FakeWeb.register_uri(:get,
          "https://api.github.com/users/#{@login}/events?per_page=1",
          body: '[{"created_at":"2013-11-04T10:47:16Z"}]'
        )
      end

      it "should return true" do
        Timecop.freeze(Date.new(2013, 11, 4)) do
          expect(GithubStreakCheck.new(@login).commited_today?).to be_true
        end
      end
    end
  end
end
