[![Maintainability](https://api.codeclimate.com/v1/badges/618cfe32cf0874f94648/maintainability)](https://codeclimate.com/github/mena-devs/tilde/maintainability)
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Fmena-devs%2Ftilde.svg?type=shield)](https://app.fossa.io/projects/git%2Bgithub.com%2Fmena-devs%2Ftilde?ref=badge_shield)

[![Test Coverage](https://api.codeclimate.com/v1/badges/618cfe32cf0874f94648/test_coverage)](https://codeclimate.com/github/mena-devs/tilde/test_coverage)

# Tilde - for @MENAdevs

Tilde is home for MENAdevs community and window to the outside world.

What started as a community over a Slack group, needs a communication platform.

Tilde is Open Source, contributors from the community are welcome to join and contribute back.

If you have a feature request, please open a ticket.

## Documentation

This README describes the purpose of this repository and how to set up a development environment. Other sources of documentation are as follows:

* UI and API designs are in `doc/`

## Purpose and features

You can find our objectives and a preliminary set of features on the following [Google Docs link](https://docs.google.com/document/d/1Qmyx_wfw-gard0VMcBCzu8TG42cSIHbGze7eQ0GAvw0/edit?usp=sharing)

## Resources

Graphics and other resources are available on Dropbox using the following [link](https://www.dropbox.com/sh/2z1p8y2cux8yzea/AAAhDFbkcOs5Gf2vgIB15aKra?dl=0)

## Prerequisites

This project requires:

* Ruby 2.5.0
* PhantomJS (in order to use the [poltergeist][] gem)
* PostgreSQL must be installed and accepting connections
* [Redis][] must be installed and running on localhost with the default port

On a Mac, you can obtain all of the above packages using [Homebrew][].

If you need help setting up a Ruby development environment, check out this [Rails OS X Setup Guide](https://mattbrictson.com/rails-osx-setup-guide).

### Setup a local Vagrant box

1. Download and Install `vagrant` (link)[https://www.vagrantup.com/downloads.html]
2. Follow the instructions inside `(README.md)[ansible-rails/README.md]` under `ansible-rails` folder
3. Run `vagrant up` (provisioning the application is part of running this step)

## Getting started

### Run it!

1. Run `vagrant ssh` to log into your local development instance.
2. Go to `cd /vagrantup`.
3. Run `bin/rails server --bind=0.0.0.0` to start the Rails app.
4. Head over to your browser and visit `http://192.168.33.11:3000` to browse the app.

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