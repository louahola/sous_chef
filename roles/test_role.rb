name 'sous_chef'
description 'role for a sous_chef server'
run_list %w(
  recipe[sous_chef::server])
default_attributes(
  sous_chef: {
    manage_chef_repo: true,
    chef_repos: [
      {
        chef_repo_name: 'chef_repo',
        chef_repo_url: '',
        notification: {
          email: {
            enabled: true,
            maintainers_email: 'email@example.com'
          }
        }
      }
    ],
    cookbooks: [
      {
        cookbook_name: 'sous_chef',
        cookbook_url: 'https://github.com/commercehub-oss/sous_chef.git',
        notification: {
          email: {
            enabled: false,
            maintainers_email: ''
          }
        },
        steps: {
          bundle: {
            command: 'chef exec bundle install'
          },
          rubocop: {
            command: 'exec rubocop'
          },
          foodcritic: {
            command: 'exec foodcritic . -f any'
          },
          test_kitchen: {
            command: 'exec kitchen test'
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
