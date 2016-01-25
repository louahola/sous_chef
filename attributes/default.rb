#
# Cookbook Name:: sous_chef
# Attribute::default
#
# Copyright 2015 CommerceHub
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
default['sous_chef']['chef_repos'] = []
default['sous_chef']['cookbooks'] = []
default['sous_chef']['merged_cookbooks'] = []
default['sous_chef']['merged_chef_repos'] = []
default['sous_chef']['manage_chef_repo'] = false

default['sous_chef']['default_chef_repo'] =
    {
      chef_repo_name: '',
      chef_repo_url: '',
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
        data_bags: {
          enabled: true,
          command: "git diff-tree --no-commit-id --name-only -r $(git log --oneline -n 1 | awk '{print $1}') | grep data_bags | while read line ; do
                      BAG=$(echo $line | cut -d / -f2)
                      echo knife data bag from file $BAG $line
                    done"
        },
        environments: {
          enabled: true,
          command: "git diff-tree --no-commit-id --name-only -r $(git log --oneline -n 1 | awk '{print $1}') | grep environments | while read line ; do
                        echo knife environment from file $line
                      done"
        },
        roles: {
          enabled: true,
          command: "git diff-tree --no-commit-id --name-only -r $(git log --oneline -n 1 | awk '{print $1}') | grep roles | while read line ; do
                        echo knife role from file $line
                      done"
        },
        cookbooks: {
          enabled: true,
          command: "git diff-tree --no-commit-id --name-only -r $(git log --oneline -n 1 | awk '{print $1}') | grep cookbooks | while read line ; do
                        COOKBOOK=$(echo $line | cut -d / -f2)
                        echo knife cookbook upload $COOKBOOK -o $line
                      done"
        }
      }
    }

default['sous_chef']['default_cookbook'] =
    {
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
          command: 'chef exec bundle install --path vendor/bundle'
        },
        rubocop: {
          enabled: true,
          command: 'chef exec bundle exec rubocop'
        },
        foodcritic: {
          enabled: true,
          command: 'chef exec bundle exec foodcritic . -f any'
        },
        test_kitchen: {
          enabled: true,
          command: 'chef exec bundle exec kitchen test'
        },
        version: {
          enabled: false,
          command: 'thor version:bump patch'
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
default['sous_chef']['plugins']['mailer']['smtp_host'] = ''
default['sous_chef']['plugins']['mailer']['smtp_port'] = ''
default['sous_chef']['plugins']['mailer']['smtp_reply_to_address'] = ''
default['sous_chef']['plugins']['mailer']['smtp_admin_address'] = ''
default['sous_chef']['plugins']['mailer']['smtp_email_suffix'] = ''

## Hipchat Notifier
default['sous_chef']['plugins']['hipchat']['enabled'] = false
default['sous_chef']['plugins']['hipchat']['auth_token'] = ''
default['sous_chef']['plugins']['hipchat']['send_as'] = 'Sous Chef'
default['sous_chef']['plugins']['hipchat']['server_url'] = ''
default['sous_chef']['plugins']['hipchat']['build_server_url'] = "http://#{node['fqdn']}:8080/"
default['sous_chef']['plugins']['hipchat']['default_room'] = ''

## Jenkins Cookbook
default['jenkins']['master']['install_method'] = 'package'
default['jenkins']['master']['version'] = nil

## Private Key Credentials
default['sous_chef']['jenkins_private_key_credentials'] = []

## Chef
default['sous_chef']['chef']['manage_chef_config'] = false
default['sous_chef']['chef']['username'] = ''
default['sous_chef']['chef']['server_url'] = ''
default['sous_chef']['chef']['validation_client_name'] = 'chef-validator'
default['sous_chef']['chef']['chef-validator'] = ''
default['sous_chef']['chef']['user_pem'] = ''
