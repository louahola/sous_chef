# sous_chef

Description
===========
Installs and configures a Jenkins server for cookbook testing.  This cookbook sets up a continuous deployment pipeline for your chef cookbooks. Sous_Chef is an opinionated cookbook designed to simplify the process of testing and publishing your cookbooks to chef.

This cookbook sets up a jenkins server which will execute your specified cookbook testing workflow in addition to machine configuration for ruby environment, gem installation, bundler tasks, git and needed deploy keys.

Notes
=====
This cookbook is not yet ready for the general use-case, as it has been written to the specifics of CommerceHub's environment.  The largest assumptions made here are vSphere as hypervisor, and Ubuntu Linux as the client OS.  In addition to that we are currently running open source chef server 11.X.

If you would like to extend/adapt for your usage, we encourage you to file issues and welcome
Pull Requests.

Requirements
============

This cookbook depends on several other cookbooks to accomplish the task of configuring a jenkins server to test cookbooks.

* 'jenkins'
* 'git'
* 'build-essential'
* 'apt'

Platforms
---------
* Ubuntu 12.04 LTS
* Ubuntu 14.04 LTS

Contributing
============
Refer to [Contributing](CONTRIBUTING.md) for more information about contributing to the sous_chef project.

Usage
=====

The sous\_chef cookbook will setup a jenkins server with the end goal of having a continuous deployment pipeline for chef cookbooks. Many of the recipes are
designed to only be included in other recipes, these are noted by starting with underscore('_').

To setup just the jenkins server with no cookbook jobs refer to [Jenkins Server](#server) role file example.

In addition to configuring the jenkins server with everything needed to start cookbook testing, Sous_Chef provides an attribute driven system to create jenkins jobs for cookbooks.  This job will represent the deployment pipeline for the chef cookbook.  These jobs will be broken into several steps as part of a cookbook testing pipeline. These steps include:

* bundle install
* rubocop
* foodcritic
* test_kitchen
* upload_cookbook

This cookbook stresses convention over configuration.  There is a default job structure including defaults for
many of the configuration options.  These defaults are designed to be sane and reasonable, but may be overridden as needed.  Keep in mind this cookbook makes assumptions on how the steps should execute and run by default.  The default setup for each cookbook job can be found in the `default['sous_chef']['default_cookbook']` attribute, and is also described in the Attributes section below.  Refer to the [Role File Examples](#role_examples) for an idea of how this functions.

Pre-Requisites
--------------
### SSH Keys for Git Access
When jenkins clones a cookbook it may require ssh access to successfully pull down the remote repository.  Sous_Chef will provide a relatively basic way to get your ssh keys setup for a cookbook job.  You can configure an array of hashes in `node['sous_chef']['jenkins_private_key_credentials']` to manage the private keys on sous_chef.  Each hash should look like the example below.

#### Attributes:
```
{
  name: '', - The name of your jenkins credential
  id: '', - The ID for the credential
  description: '', - A human readable friendly description describing the credential
  private_key: '', - The private key associated with this credential.
}
```

The ID field must match regular expression /[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-[89aAbB][a-f0-9]{3}-[a-f0-9]{12}/.  An example key taken from the jenkins cookbook readme looks as follows: 'fa3aab48-4edc-446d-b1e2-1d89d86f4458'

Long term plans are to rely on data_bags for the private_key or even the entire credential object but for now setting the private key as an attribute will suffice.

### Chef Server Access:

Sous_Chef can upload your cookbook to your chef server after completion of your pipeline.  To do this you need an account on your chef server with access to upload cookbooks.  Sous_Chef provides a very basic and way to configure your jenkins node to communicate with your chef server.  Simply set a few attributes as they pertain to your chef server and sous chef can configure the jenkins user with this information.

#### Attributes:
```
node['sous_chef']['chef']['manage_chef_config'] - Have Sous_Chef cookbook manage your chef configuration
node['sous_chef']['chef']['username'] - Username on the chef server
node['sous_chef']['chef']['server_url'] - Chef server URL
node['sous_chef']['chef']['validation_client_name'] -
node['sous_chef']['chef']['chef-validator'] - Your chef-validator pem
node['sous_chef']['chef']['user_pem'] - Your private key for the chef user your created
```

Long term there are plans to rely on data_bags for the chef-validator and user_pem but for now simply putting the keys as attributes will suffice.

Recipes
-------

* \_base - This recipe includes pre-req and shared requirements for jenkins servers both master and slave.
* \_cookbook_job - The recipe to setup a job for cookbook testing
* \_plugins - The recipe which contains plugin installations and configuration
* \_chef_config - The recipe which will configure a .chef directory inside of the jenkins home directory for chef server access
* default - The recipe that does nothing. Don't use it.
* server - The recipe which sets up a jenkins master instance.

<a name="role_examples"></a>Role File Examples
------------------
In the below examples any and all combinations of attributes are supported.  Each cookbook will be merged with the
default cookbook. Feel free to only provide one attribute in a hash if you are only changing that attribute.  You
can refer to the `default['sous_chef']['default_cookbook']` attribute for all possible configurable options.

<a name="server"></a>#### Setup the jenkins cookbook testing server with all defaults

```ruby
run_list *%w[
recipe[sous_chef::server]
]

default_attributes({})
```

#### Bare Bones: Configure a cookbook to leverage the service with all defaults

```ruby
default_attributes(
sous_chef: {
  cookbooks: [
    {
      cookbook_name: 'sous_chef',
      cookbook_url: '<replace with github clone url>',
      notification: {
        email: {
          maintainers_email: 'email@example.com'
        },
      }
    }
  ]
})
```

#### Hipchat Notification: Configure a cookbook to leverage the hipchat notification plugin

```ruby
default_attributes(
sous_chef: {
  cookbooks: [
    {
      cookbook_name: 'sous_chef',
      cookbook_url: '<replace with github clone url>',
      notification: {
        email: {
          maintainers_email: 'email@example.com'
        },
        hipchat: {
          enabled: true,
          hipchat_room: 'Chef'
        }
      }
    }
  ]
})
```

#### Triggers: Change how often a job polls SCM

```ruby
default_attributes(
    sous_chef: {
        cookbooks: [
        {
            cookbook_name: 'sous_chef',
            cookbook_url: '<replace with github clone url>',
            triggers: {
                poll_scm: {
                    schedule: '*/5 * * * *'
                }
            }
        }
        ]
    }
)
```

#### Custom Job Definition: Not happy with defaults? Customize the job definition for any given job

```ruby
default_attributes(
sous_chef: {
  cookbooks: [
    {
      cookbook_name: 'sous_chef',
      cookbook_url: '<replace with github clone url>',
      notification: {
        email: {
          maintainers_email: 'email@example.com'
        },
      },
      steps: {
        foodcritic: {
          enabled: true,
          command: 'bundle exec foodcritic . -f correctness',
        }
      }
    }
  ]
})
```

Attributes
==========

Below is the definition of the default cookbook attribute.  This is the base for the job and steps being setup.  This allows convention > configuration with minimal configuration.

### Default Cookbook

```ruby
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
```

### Jenkins Configuration

```ruby
default['sous_chef']['master_executors'] = 4
default['jenkins']['master']['install_method'] = 'package'
default['jenkins']['master']['version'] = nil
```

### Plugins

```ruby
## Mailer Notifier
default['sous_chef']['plugins']['mailer']['smtp_host'] = 'yourmailserver.example.com'
default['sous_chef']['plugins']['mailer']['smtp_port'] = '25'
default['sous_chef']['plugins']['mailer']['smtp_reply_to_address'] = 'email@example.com'
default['sous_chef']['plugins']['mailer']['smtp_admin_address'] = 'email@example.com'
default['sous_chef']['plugins']['mailer']['smtp_email_suffix'] = '@example.com'

## Hipchat Notifier
default['sous_chef']['plugins']['hipchat']['enabled'] = false
default['sous_chef']['plugins']['hipchat']['auth_token'] = ''
default['sous_chef']['plugins']['hipchat']['send_as'] = 'Sous Chef'
default['sous_chef']['plugins']['hipchat']['server_url'] = 'yourhipchatserver.example.com'
default['sous_chef']['plugins']['hipchat']['build_server_url'] = "http://#{node['fqdn']}:8080/"
default['sous_chef']['plugins']['hipchat']['default_room'] = 'Chef'
```

### Chef

```ruby
default['sous_chef']['chef']['manage_chef_config'] = false
default['sous_chef']['chef']['username'] = 'jenkins_cookbook'
default['sous_chef']['chef']['server_url'] = 'https://yourchefserver.example.com'
default['sous_chef']['chef']['validation_client_name'] = 'chef-validator'
default['sous_chef']['chef']['chef-validator'] = ''
default['sous_chef']['chef']['user_pem'] = ''
```

### Private Keys

```ruby
default['sous_chef']['jenkins_private_key_credentials'] = []
```

The Hash(s) under the jenkins_private_key_credentials should look like this

```
{
  name: '', - The name of your jenkins credential
  id: '', - The ID for the credential
  description: '', - A human readable friendly description describing the credential
  private_key: '', - The private key associated with this credential.
}
```

License and Author
==================

Author:: CommerceHub  
Author\_Website:: [www.commercehub.com](www.commercehub.com)  
Twitter:: [@CommerceHubTech ](http://twitter.com/CommerceHubTech)  

Copyright 2015, CommerceHub

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
