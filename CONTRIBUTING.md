
## Contributing

Communicate
-----------
Interesting in adding a new feature or bug fix to sous_chef?  Post an issue to discuss your proposed changes with the project owners.

Contribute:
-----------

1. Fork it on GitHub
2. Make your changes
3. Perform Testing as outlined in the [Testing](#testing) section below
3. Push to the branch (`git push -u fork my-new-feature`)
4. Create a new Pull Request on GitHub

Testing:
-------
This cookbook is tested with rubocop, foodcritic and test-kitchen.  
Run `bundle install` to install required gems.  The following commands should all pass before submitting your pull request.

1. rubocop
2. foodcritic .
3. kitchen test

Currently Tested on:

* Ubuntu 14.04
