name 'sous_chef'
description 'role for a sous_chef server'
run_list %w(
  recipe[sous_chef::server])
default_attributes(
  sous_chef: {
    cookbooks: [
      {
        cookbook_name: 'sous_chef',
        cookbook_url: 'git@github.com:commercehub-oss/sous_chef.git',
        notification: {
          email: {
            enabled: false,
            maintainers_email: ''
          }
        },
        steps: {
          bundle: {
            command: 'echo bundle install --path vendor/bundle'
          },
          rubocop: {
            command: 'echo bundle exec rubocop'
          },
          foodcritic: {
            command: 'echo bundle exec foodcritic . -f any'
          },
          test_kitchen: {
            command: 'echo bundle exec kitchen test'
          },
          upload_cookbook: {
            command: 'echo rm -rf replace_with_cookbook
            echo rsync -avz . ./replace_with_cookbook --exclude replace_with_cookbook
            echo knife cookbook upload replace_with_cookbook --cookbook-path . --freeze'
          }
        }
      }
    ]
  })
