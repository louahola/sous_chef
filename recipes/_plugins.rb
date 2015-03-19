#
# Cookbook Name:: sous_chef
# Recipe::_plugins
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

### Install Plugins ###

jenkins_plugin 'git' do
  # not_if { File.exist?("/var/lib/jenkins/plugins/git.jpi") }
  notifies :restart, 'service[jenkins]', :immediately
end

# TODO: Make hipchat plugin optional?
jenkins_plugin 'hipchat' do
  # not_if { File.exist?("/var/lib/jenkins/plugins/hipchat.jpi") }
  notifies :restart, 'service[jenkins]', :immediately
  only_if { node['sous_chef']['hipchat_enabled'] }
end

# AnsiColor
jenkins_plugin 'ansicolor' do
  # not_if { File.exist?('/var/lib/jenkins/plugins/ansicolor.jpi') }
  notifies :restart, 'service[jenkins]', :immediately
end

## The warnings plugin requires manual configuration ##
## Please see http://acrmp.github.io/foodcritic/#tracking_warnings_over_time
jenkins_plugin 'warnings' do
  # not_if { File.exist?("/var/lib/jenkins/plugins/warnings.jpi") }
  notifies :restart, 'service[jenkins]', :immediately
end

### Configure Plugins ###

## Setup number of executors
jenkins_script 'configure executors' do
  command <<-EOH.gsub(/^ {4}/, '')
    jenkins = jenkins.model.Jenkins.getInstance()
    jenkins.setNumExecutors(#{node['sous_chef']['master_executors']})
    jenkins.setNodes(jenkins.getNodes())
    jenkins.save()
    EOH
end

## Setup Mailer
jenkins_script 'configure mailer' do
  command <<-EOH.gsub(/^ {4}/, '')
    jenkins = jenkins.model.Jenkins.getInstance()
    mailer = jenkins.getDescriptorByType(hudson.tasks.Mailer.DescriptorImpl)
    mailer.setSmtpHost("#{node['sous_chef']['plugins']['mailer']['smtp_host']}")
    mailer.setSmtpPort("#{node['sous_chef']['plugins']['mailer']['smtp_port']}")
    mailer.setDefaultSuffix("#{node['sous_chef']['plugins']['mailer']['smtp_email_suffix']}")
    mailer.setReplyToAddress("#{node['sous_chef']['plugins']['mailer']['smtp_reply_to_address']}")
    mailer.save()
    EOH
end

jenkins_script 'configure admin address' do
  command <<-EOH.gsub(/^ {4}/, '')
    jenkins = jenkins.model.Jenkins.getInstance()
    location_conf = jenkins.getDescriptor(jenkins.model.JenkinsLocationConfiguration)
    location_conf.setAdminAddress("#{node['sous_chef']['plugins']['mailer']['smtp_admin_address']}")
    location_conf.save()
    EOH
end

jenkins_script 'configure hipchat notifier' do
  command <<-EOH.gsub(/^ {4}/, '')
    jenkins = jenkins.model.Jenkins.getInstance()
    hipchat = jenkins.getDescriptorByType(jenkins.plugins.hipchat.HipChatNotifier.DescriptorImpl)
    hipchat.server = "#{node['sous_chef']['plugins']['hipchat']['server_url']}"
    hipchat.sendAs = "#{node['sous_chef']['plugins']['hipchat']['send_as']}"
    hipchat.token = "#{node['sous_chef']['plugins']['hipchat']['auth_token']}"
    hipchat.buildServerUrl = "#{node['sous_chef']['plugins']['hipchat']['build_server_url']}"
    hipchat.room = "#{node['sous_chef']['plugins']['hipchat']['default_room']}"
    hipchat.save()
    EOH
  only_if { node['sous_chef']['plugins']['hipchat']['enabled'] }
end
