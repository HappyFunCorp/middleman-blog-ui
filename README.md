# Middleman::Blog::Ui

This gem is mean to work with an exitisting middleman site, that uses both middleman-blog and middleman-blog-drafts.

More information on how it works can be found on my blog, at http://willschenk.com/building-a-gui-for-managing-middleman-blogs/

## Installation


Given a middleman app with `middleman-blog` and `middleman-blog-drafts` configured:

1. Add `middleman-blog-ui` in your `Gemfile`.
2. Add `activate :blog_ui` in `config.rb`
3. Start `middleman server`
4. Visit [http://localhost:4567/admin](http://localhost:4567/admin).

And now you are living in the fabulous world where you can, from your browser:

- Edit existing drafts and posts
- Create new drafts
- Publish drafts into posts
- Run some basic `git` commands.
- Run `middleman build`
- Run `middleman deploy`

## Next steps

This is mainly a proof of concept, but I'm using it right now to write this post.  The app itself needs

1. A decent UI
2. Support for other static generators other than middleman
3. A concept of users
4. Shared drafts
5. Better error handling

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/middleman-blog-ui/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
