#
# Cookbook Name:: sous_chef
# Recipe:: _cookbook_job
#
# Copyright (C) 2014
#
#
#

node['sous_chef']['merged_cookbooks'].each do |cookbook|
  xml = File.join(Chef::Config['file_cache_path'], "#{cookbook['cookbook_name']}.xml")

  template xml do
    source 'cookbook_job_xml.erb'
    variables(
      cookbook_url: cookbook['cookbook_url'],
      notification: cookbook['notification'],
      triggers: cookbook['triggers'],
      steps: cookbook['steps']
    )
  end

  jenkins_job cookbook['cookbook_name'] do
    config xml
  end
end
