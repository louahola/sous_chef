name 'sous_chef'
maintainer 'Larry Zarou'
maintainer_email 'lzarou@commercehub.com'
license 'Apache 2.0'
description 'Installs/Configures a jenkins server designed for executing cookbook testing(sous_chef)'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version IO.read(File.join(File.dirname(__FILE__), 'VERSION')) rescue '0.1.0'

depends 'jenkins'
depends 'git'
depends 'build-essential'
depends 'apt'

# rubocop:disable Style/HashSyntax, Style/AlignParameters

attribute 'sous_chef/master_executors',
  :display_name => "Master Executors",
  :description => "The number of executors the jenkins master node should run with",
  :type => "integer",
  :required => "required",
  :default => 4

attribute 'sous_chef/plugins/mailer/smtp_host',
  :display_name => "SMTP Host",
  :description => "The SMTP host for the jenkins email configuration under Manage Jenkins/Configure System.",
  :type => "string",
  :required => "optional",
  :default => ''

attribute 'sous_chef/plugins/mailer/smtp_port',
  :display_name => "SMTP Port",
  :description => "The SMTP port for the jenkins email configuration under Manage Jenkins/Configure System.",
  :type => "string",
  :required => "optional",
  :default => ''

attribute 'sous_chef/plugins/mailer/smtp_reply_to_address',
  :display_name => "SMTP Reply To Address",
  :description => "The SMTP reply to address for the jenkins email configuration under Manage Jenkins/Configure System.",
  :type => "string",
  :required => "optional",
  :default => ''

attribute 'sous_chef/plugins/mailer/smtp_admin_address',
  :display_name => "SMTP Admin Address",
  :description => "The SMTP admin address for the jenkins email configuration under Manage Jenkins/Configure System.",
  :type => "string",
  :required => "optional",
  :default => ''

attribute 'sous_chef/plugins/mailer/smtp_email_suffix',
  :display_name => "SMTP Email Suffice",
  :description => "The SMTP email suffice for the jenkins email configuration under Manage Jenkins/Configure System.",
  :type => "string",
  :required => "optional",
  :default => ''

attribute 'sous_chef/plugins/hipchat/enabled',
  :display_name => "Hipchat Enabled",
  :description => "Should the hipchat plugin be installed and configured.",
  :type => "boolean",
  :required => "required",
  :default => false

attribute 'sous_chef/plugins/hipchat/auth_token',
  :display_name => "Hipchat Authentication Token",
  :description => "The hipchat plugin requires a auth token to work with your hipchat instance.",
  :type => "string",
  :required => "optional",
  :default => ''

attribute 'sous_chef/plugins/hipchat/send_as',
  :display_name => "Hipchat Send As",
  :description => "The hipchat plugin will send messages in your hipchat room using this name.",
  :type => "string",
  :required => "optional",
  :default => 'Sous Chef'

attribute 'sous_chef/plugins/hipchat/server_url',
  :display_name => "Hipchat Server url",
  :description => "The hipchat server url that jenkins will notify as part of the build process .",
  :type => "string",
  :required => "optional",
  :default => ''

attribute 'sous_chef/plugins/hipchat/build_server_url',
  :display_name => "Hipchat Build Server url",
  :description => "The jenkins build server url that the hipchat plugin will use in messages.",
  :type => "string",
  :required => "optional",
  :default => "http://#{node['fqdn']}:8080/"

attribute 'sous_chef/plugins/hipchat/default_room',
  :display_name => "Hipchat Default Room",
  :description => "If a room is not specified on the build level this is a fall back.",
  :type => "string",
  :required => "optional",
  :default => ''

attribute 'sous_chef/chef/manage_chef_config',
  :display_name => "Manage Chef Config",
  :description => "Should Sous Chef manage your chef server configuration giving the jenkins user the ability to upload cookbooks.",
  :type => "boolean",
  :required => "required",
  :default => false

attribute 'sous_chef/chef/username',
  :display_name => "Chef Username",
  :description => "If Sous Chef is managing your chef config, this is the username that would get used in the knife.rb and the user that will need to exist on your chef server",
  :type => "string",
  :required => "optional",
  :default => ''

attribute 'sous_chef/chef/server_url',
  :display_name => "Chef Server url",
  :description => "If Sous Chef is managing your chef config, the chef server url that will get put into knife.rb and cookbooks will be uploaded to.",
  :type => "string",
  :required => "optional",
  :default => ''

attribute 'sous_chef/chef/validation_client_name',
  :display_name => "Chef Validation Client Name",
  :description => "If Sous Chef is managing your chef config, the chef validator file name.",
  :type => "string",
  :required => "optional",
  :default => 'chef-validator'

attribute 'sous_chef/chef/chef-validator',
  :display_name => "Chef Validator PEM",
  :description => "If Sous Chef is managing your chef config, this is the chef-validator pem for your chef server.",
  :type => "string",
  :required => "optional",
  :default => ''

attribute 'sous_chef/chef/user_pem',
  :display_name => "Chef User PEM",
  :description => "If Sous Chef is managing your chef config, this is the private key for the user setup to upload cookbooks.",
  :type => "string",
  :required => "optional",
  :default => ''

attribute 'sous_chef/cookbooks',
  :display_name => "Cookbooks",
  :description => "An array of cookbook hashes where you define cookbooks that will run on Sous Chef and override any properties from the default_cookbook hash as needed..",
  :type => "array",
  :required => "required",
  :default => []

attribute 'sous_chef/default_cookbook',
  :display_name => "Default Cookbook",
  :description => "The cookbook template all cookbooks will be merged with",
  :type => "hash",
  :required => "required",
  :default => {
      cookbook_name: 'cookbook_name',
      cookbook_url: 'cookbook_url',
      notification: {
        email: {
          enabled: true,
          maintainers_email: 'email@example.com'
        },
        hipchat: {
          enabled: false,
          hipchat_room: '',
          notifyStarted: false,
          notifySuccess: true,
          notifyAborted: true,
          notifyNotBuilt: false,
          notifyUnstable: true,
          notifyFailure: true,
          notifyBackToNormal: true,
          startJobMessage: '',
          completeJobMessage: ''
        }
      },
      triggers: {
        poll_scm: {
          enabled: true,
          schedule: '*/1 * * * *'
        }
      },
      steps: {
        bundle: {
          enabled: true,
          command: 'bundle install --path vendor/bundle'
        },
        rubocop: {
          enabled: true,
          command: 'bundle exec rubocop'
        },
        foodcritic: {
          enabled: true,
          command: 'bundle exec foodcritic . -f any'
        },
        test_kitchen: {
          enabled: true,
          command: 'bundle exec kitchen test'
        },
        upload_cookbook: {
          enabled: true,
          command: 'rsync -avzq . ./replace_with_cookbook --exclude replace_with_cookbook --exclude \'vendor\'
          knife cookbook upload replace_with_cookbook --cookbook-path . --freeze
          rm -rf replace_with_cookbook'
        }
      }
    }

# rubocop:enable Style/HashSyntax, Style/AlignParameters
