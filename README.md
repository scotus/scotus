# SCOTUS

Command an AR Drone using Twitter.

### Installation

Clone from git:

    git clone https://github.com/scotus/scotus.git

Obtain [Processing](http://processing.org/) for your OS, then open up
`src/ARDroneTweetWatcher/ARDroneTweetWatcher.pde`.  Populate
`OAuthConsumerKey`, `OAuthConsumerSecret`, `AccessToken`, and
`AccessTokenSecret` to connect to Twitter.

### Usage

Turn on your drone, and make sure you're simultaneously connected to its
wireless network as well as the actual Internet (for example, through your
computer's ethernet port.)  On a Mac, this should work provided your wired
network is placed above your wireless in the System Preferences 'Network' pane.

Then, press the "Run" button of the above
`src/ARDroneTweetWatcher/ARDroneTweetWatcher.pde` project in Processing.  You
can also "Export Application" if you want to run the drone outside of the
Processing environment.

### License

Licensed under the GPLv3.  See LICENSE.txt.

### Contributors

See CONTRIBUTORS.txt.
