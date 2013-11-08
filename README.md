# github_streak_check

GitHub's user page (eg. https://github.com/yhara) shows 'Longest Streak',
how many successive days the user is keep contributing. 

This RubyGem provides a command to check if you have done today's
contribution and optionally send an email if not.

## Installation

    $ gem i github_streak_check

## Usage

    $ github_streak_check GITHUB_USER_NAME

Exit with status 0 if already did contribution, with 1 otherwise.

### Sending alert mail

    $ github_streak_check foo -m foo@example.com

This will send an notification to the given mail address.
github_streak_check uses [Pony](http://github.com/benprew/pony)'s default
way to send email; use /usr/sbin/sendmail if exists, then try to send with SMTP on localhost.

## Run test

    $ bundle install
    $ rspec

## Limitations

IMPORTANT: this gem does not guarantee 100% accuracy!

- Private repos are not supported
- Commits to forked repo are not counted [unless it is merged to main repo](https://help.github.com/articles/why-are-my-contributions-not-showing-up-on-my-profile), but github_streak_check returns OK for them, too
- Fetches only recent 300 events, so it may fail if you make over 300 commits a day.

## License

MIT
