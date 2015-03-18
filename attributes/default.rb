#
# Cookbook Name:: sous_chef
# Attribute::default
#
# Copyright 2015 Larry Zarou <larry.zarou@gmail.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

## sous_chef
default['sous_chef']['cookbooks'] = []
default['sous_chef']['merged_cookbooks'] = []

default['sous_chef']['default_cookbook'] =
    {
      cookbook_name: 'cookbook_name',
      cookbook_url: 'cookbook_url',
      notification: {
        email: {
          enabled: true,
          maintainers_email: 'email@address.com'
        },
        hipchat: {
          enabled: false,
          hipchat_room: 'Chef',
          notifyStarted: false,
          notifySuccess: true,
          notifyAborted: true,
          notifyNotBuilt: false,
          notifyUnstable: true,
          notifyFailure: true,
          notifyBackToNormal: true
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

# General sous_chef properties
default['sous_chef']['master_executors'] = 4

## Mailer Notifier
default['sous_chef']['smtp_host'] = 'yourmail.server.com'
default['sous_chef']['smtp_port'] = '25'
default['sous_chef']['smtp_reply_to_address'] = 'email@address.com'
default['sous_chef']['smtp_admin_address'] = 'email@address.com'
default['sous_chef']['smtp_email_suffix'] = '@address.com'

## Hipchat Notifier
default['sous_chef']['hipchat_enabled'] = false
default['sous_chef']['hipchat_auth_token'] = ''
default['sous_chef']['hipchat_send_as'] = 'Sous Chef'
default['sous_chef']['hipchat_server_url'] = 'yourhipchat.server.com'
default['sous_chef']['hipchat_build_server_url'] = "http://#{node['fqdn']}:8080/"
default['sous_chef']['hipchat_default_room'] = 'Chef'

## Jenkins Cookbook
default['jenkins']['master']['install_method'] = 'package'
default['jenkins']['master']['version'] = nil

## Private Key Credentials
default['sous_chef']['jenkins_private_key_credentials'] = []

## Gitlab Service Account Credentials
default['sous_chef']['gitlab_service_account_key'] = ''

## Chef
default['sous_chef']['chef']['manage_chef_config'] = false
default['sous_chef']['chef']['username'] = 'jenkins_cookbook'
default['sous_chef']['chef']['server_url'] = 'https://chef.server.url.com'
default['sous_chef']['chef']['validation_client_name'] = 'chef-validator'
default['sous_chef']['chef']['chef-validator'] = ''
default['sous_chef']['chef']['user_pem'] = ''
