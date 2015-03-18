#
# Cookbook Name:: sous_chef
# Recipe::_chef_config.rb
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

# TODO: Databags for keys?
# TODO: Should sous_chef manage this at all?

directory "#{node['jenkins']['master']['home']}/.chef" do
  owner 'jenkins'
  group 'jenkins'
  mode '0741'
  action :create
end

file "#{node['jenkins']['master']['home']}/.chef/chef-validator.pem" do
  owner 'jenkins'
  group 'jenkins'
  content node['sous_chef']['chef']['chef-validator']
  mode '0644'
  action :create
end

file "#{node['jenkins']['master']['home']}/.chef/#{node['sous_chef']['chef']['username']}.pem" do
  owner 'jenkins'
  group 'jenkins'
  content node['sous_chef']['chef']['user_pem']
  mode '0644'
  action :create
end

template "#{node['jenkins']['master']['home']}/.chef/client.rb" do
  owner 'jenkins'
  group 'jenkins'
  source 'client.rb.erb'
  mode '0644'
  action :create
end

template "#{node['jenkins']['master']['home']}/.chef/knife.rb" do
  owner 'jenkins'
  group 'jenkins'
  source 'knife.rb.erb'
  mode '0644'
  action :create
end
