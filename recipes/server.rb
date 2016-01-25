#
# Cookbook Name:: sous_chef
# Recipe::server
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

include_recipe 'sous_chef::_base'
include_recipe 'sous_chef::_plugins'
include_recipe 'sous_chef::_chef_config' if node['sous_chef']['chef']['manage_chef_config']

## Setup Private Keys
node['sous_chef']['jenkins_private_key_credentials'].each do |credential|
  jenkins_private_key_credentials credential['name'] do
    id credential['id']
    description credential['description']
    private_key credential['private_key']
  end
end

# Cycle through all the cookbooks and merge with default cookbook setup
# Add result to merged_cookbooks array for use later when setting up job steps
node['sous_chef']['cookbooks'].each do |cookbook|
  default_cookbook_def = node['sous_chef']['default_cookbook'].to_hash

  configured_cookbook = cookbook

  merged_cookbook = Chef::Mixin::DeepMerge.deep_merge(configured_cookbook, default_cookbook_def)

  # replace token with actual cookbook name for upload step
  merged_cookbook['steps'].each do |step, step_hash|
    if step == 'upload_cookbook' && step_hash['command'].include?('replace_with_cookbook')
      merged_cookbook['steps'][step]['command'] = step_hash['command'].gsub('replace_with_cookbook', merged_cookbook['cookbook_name'])
    end
  end

  node.default['sous_chef']['merged_cookbooks'].push(merged_cookbook)
end

# Cycle through all the chef repos and merge with default chef repo setup
# Add result to merged_chef_repos array for use later when setting up job steps
node['sous_chef']['chef_repos'].each do |chef_repo|
  default_chef_repo = node['sous_chef']['default_chef_repo'].to_hash

  configured_repo = chef_repo

  merged_repo = Chef::Mixin::DeepMerge.deep_merge(configured_repo, default_chef_repo)

  node.default['sous_chef']['merged_chef_repos'].push(merged_repo)
end

## Setup Jobs
include_recipe 'sous_chef::_cookbook_job'
include_recipe 'sous_chef::_chef_repo_job' if node['sous_chef']['manage_chef_repo']
