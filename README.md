# Charting

Charting lets you capture snippets from websites, organise and discuss them. It consists of a rails application, browser plugin for Firefox and a bookmarklet.

## Install

Clone this repository:

    git clone https://github.com/johnturner/charting.git

Install ruby (version 1.8.7 is known to work) and rake 0.8.7.  If there are other ruby environments on the   server you may want to use rvm to maintain a separate version for charting.

Assuming ubuntu and no need for maintaining multiple versions of ruby:
    sudo apt-get install ruby
    sudo gem install rake -v 0.8.7

Once ruby and rake are installed, all other dependencies should be included in the repository (frozen into vendor/).

    cd charting/server
    rake db:schema:load
    script/server

Full steps for installing through rvm:

    \curl -L https://get.rvm.io | bash -s stable # install RVM if it's not already installed
    
    rvm install 1.8.7
    rvm use 1.8.7
    gem install rake -v 0.8.7
    rvm rubygems 1.3.7 # Installs and switches to rubygems 1.3.7
    cd ~/.rvm/gems/ruby-1.8.7-p374@global/gems
    rm -r *bundler* # (The bundler gem was causing load errors with the older version of rubygems, and refuses to be uninstalled with the gem command.)
    gem install rack -v 1.1.0
    gem install sqlite3-ruby
    cd charting/server
    rake _0.8.7_ db:schema:load
    script/server

The newserver directory currently contains a version partially ported over to ruby 2.0.0/rails 4.0.  To install and run this:

    \curl -L https://get.rvm.io | bash -s stable # install RVM if it's not already installed
    cd charting/newserver
    rvm install 2.0.0
    rvm use 2.0.0
    bundle install
    rake db:reset
    rails server
   
