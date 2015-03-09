#
# Cookbook Name:: sous_chef
# Recipe:: _base
#
# Copyright (C) 2014
#
#
#

include_recipe 'apt'
include_recipe 'build-essential::default'
include_recipe 'git::default'

package 'ruby1.9.3'
package 'vagrant'
package 'zlib1g-dev'
gem_package 'bundler'
gem_package 'rake'
gem_package 'thor'
gem_package 'thor-scmversion'
