#
# Cookbook Name:: sous_chef
# Recipe::_chef_repo_job
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

node['sous_chef']['merged_chef_repos'].each do |chef_repo|
  xml = File.join(Chef::Config['file_cache_path'], "#{chef_repo['chef_repo_name']}.xml")

  template xml do
    source 'chef_repo_job_xml.erb'
    variables(
      chef_repo_url: chef_repo['chef_repo_url'],
      notification: chef_repo['notification'],
      triggers: chef_repo['triggers'],
      steps: chef_repo['steps'],
      private_keys: node['sous_chef']['jenkins_private_key_credentials']
    )
  end

  jenkins_job chef_repo['chef_repo_name'] do
    config xml
  end
end
