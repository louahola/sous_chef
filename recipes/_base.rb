#
# Cookbook Name:: sous_chef
# Recipe::_base
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

include_recipe 'apt'
include_recipe 'build-essential::default'
include_recipe 'git::default'
include_recipe 'sous_chef::_chef_config' if node['sous_chef']['chef']['manage_chef_config']

package 'ruby1.9.3'
package 'vagrant'
package 'zlib1g-dev'
gem_package 'bundler'
gem_package 'rake'
gem_package 'thor'
gem_package 'thor-scmversion'
