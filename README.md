# mena-devs

This is a Rails 5 app.

## Staging environment

[https://staging.menadevs.com](https://staging.menadevs.com)

## Documentation

This README describes the purpose of this repository and how to set up a development environment. Other sources of documentation are as follows:

* UI and API designs are in `doc/`

## Purpose and features

You can find our objectives and a preliminary set of features on the following [Google Docs link](https://docs.google.com/document/d/1Qmyx_wfw-gard0VMcBCzu8TG42cSIHbGze7eQ0GAvw0/edit?usp=sharing)

## Resources

Graphics and other resources are available on Dropbox using the following [link](https://www.dropbox.com/sh/2z1p8y2cux8yzea/AAAhDFbkcOs5Gf2vgIB15aKra?dl=0)

## Prerequisites

This project requires:

* Ruby 2.4.1, preferably managed using [rbenv][]
* PhantomJS (in order to use the [poltergeist][] gem)
* PostgreSQL must be installed and accepting connections
* [Redis][] must be installed and running on localhost with the default port

On a Mac, you can obtain all of the above packages using [Homebrew][].

If you need help setting up a Ruby development environment, check out this [Rails OS X Setup Guide](https://mattbrictson.com/rails-osx-setup-guide).

### Download vagrant box to use with project

[Download link](http://bit.ly/2vhoTvS)

1. Import the box by running the following command:

`vagrant box add "ubuntu/xenial64" ~/path-to-vagrant-box`

2. Run `vagrant up` and you should be able to access the box

## Getting started

### bin/setup

Run the `bin/setup` script. This script will:

* Check you have the required Ruby version
* Install gems using Bundler
* Create local copies of `.env` and `database.yml`
* Create, migrate, and seed the database

### Run it!

1. Run `rake test` to make sure everything works.
2. Run `rails s` to start the Rails app.
3. In a separate console, run `bundle exec sidekiq` to start the Sidekiq background job processor.

[rbenv]:https://github.com/sstephenson/rbenv
[poltergeist]:https://github.com/teampoltergeist/poltergeist
[redis]:http://redis.io
[Homebrew]:http://brew.sh

### Emails in development environment

To test sent out emails during development, navigate to `localhost:3000/letter_opener` to check individual sent emails.

## Git workflow

For contributions, please follow the following [git workflow](GIT-WORKFLOW.md)
