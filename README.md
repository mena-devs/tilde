[![Build Status](https://app.travis-ci.com/mena-devs/tilde.svg?branch=main)](https://app.travis-ci.com/mena-devs/tilde)

[![Maintainability](https://api.codeclimate.com/v1/badges/618cfe32cf0874f94648/maintainability)](https://codeclimate.com/github/mena-devs/tilde/maintainability)

[![Test Coverage](https://api.codeclimate.com/v1/badges/618cfe32cf0874f94648/test_coverage)](https://codeclimate.com/github/mena-devs/tilde/test_coverage)

[![FOSSA Status](https://app.fossa.com/api/projects/git%2Bgithub.com%2Fmena-devs%2Ftilde.svg?type=large)](https://app.fossa.com/projects/git%2Bgithub.com%2Fmena-devs%2Ftilde?ref=badge_large)

# Tilde: Web Application

Tilde is a web application built with Ruby on Rails.

What started as a community over a Slack group, needed a communication platform. Tilde is considered as the public interface of MENAdevs online community and a window to the world outside of the Slack group. It consists of a job board and an online members directory.
Employers can use the job board to advertise, free of charge, jobs to all of the community members.

Tilde is Open Source, contributors from the community are welcome to join and contribute back.

If you have a feature request, please open a ticket.

## Documentation

This README describes the purpose of this repository and how to set up a development environment. Other sources of documentation are as follows:

* UI and API designs are in `docs/`

API specifications are [located here](https://mena-devs.github.io/tilde/api_specifications/index.html)

## Purpose and features

You can find our objectives and a preliminary set of features on the following [Google Docs link](https://docs.google.com/document/d/1Qmyx_wfw-gard0VMcBCzu8TG42cSIHbGze7eQ0GAvw0/edit?usp=sharing)

## Prerequisites

This project requires:

* Ruby 2.6.5
* PhantomJS (in order to use the [poltergeist][] gem)
* PostgreSQL must be installed and accepting connections
* [Redis][] must be installed and running on localhost with the default port

On a Mac, you can obtain all of the above packages using [Homebrew][].

If you need help setting up a Ruby development environment, check out this [Rails OS X Setup Guide](https://mattbrictson.com/rails-osx-setup-guide).

## Getting started

### Run it!

**Make sure you have PostgreSQL and Redis servers running locally**

1. Install bundler: `gem install bundler`
2. Download the application: `git clone git@github.com:mena-devs/tilde.git`
3. Copy local configuration files and pupulate them with your values:
  - `cp config/database.example.yml config/database.yml`
  - `cp config/settings/development.yml.sample config/settings/development.yml`
  - `cp example.env .env`
4. Install libraries: `cd tilde && bundle install`
5. Run `bin/rails server` to start a local application server
6. Navigate to `localhost:3000` to view the application in your browser

[rbenv]:https://github.com/sstephenson/rbenv
[poltergeist]:https://github.com/teampoltergeist/poltergeist
[redis]:http://redis.io
[Homebrew]:http://brew.sh

### Emails in development environment

To test sent out emails during development, navigate to `localhost:3000/letter_opener` to check individual sent emails.

## Git workflow

For contributions, please follow the following [git workflow](GIT-WORKFLOW.md)

## License
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fmena-devs%2Ftilde.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2Fmena-devs%2Ftilde?ref=badge_large)
