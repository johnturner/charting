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
