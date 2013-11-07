# github_streak_check

TODO: Write a gem description

## Installation

    $ gem i github_streak_check

## Usage

    $ github_streak_check && echo OK

### Sending alert mail

    $ github_streak_check -m foo@example.com

This will send an notification to the given mail address.
github_streak_check uses [Pony](http://github.com/benprew/pony)'s default
way to send email; use /usr/sbin/sendmail if exists, then try to send with SMTP on localhost.

## Limitations

- Private repos are not supported
- Commits to forked repo are not counted [unless it is merged to main repo](https://help.github.com/articles/why-are-my-contributions-not-showing-up-on-my-profile), but github_streak_check returns OK for them, too
- Fetches only recent 300 events, so it may fail if you make over 300 commits a day.

## License

MIT
