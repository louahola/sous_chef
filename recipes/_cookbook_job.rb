#
# Cookbook Name:: sous_chef
# Recipe::_cookbook_job
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

node['sous_chef']['merged_cookbooks'].each do |cookbook|
  xml = File.join(Chef::Config['file_cache_path'], "#{cookbook['cookbook_name']}.xml")

  template xml do
    source 'cookbook_job_xml.erb'
    variables(
      cookbook_url: cookbook['cookbook_url'],
      notification: cookbook['notification'],
      triggers: cookbook['triggers'],
      steps: cookbook['steps'],
      private_keys: node['sous_chef']['jenkins_private_key_credentials']
    )
  end

  jenkins_job cookbook['cookbook_name'] do
    config xml
  end
end
