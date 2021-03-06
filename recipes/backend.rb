#
# Cookbook Name:: islandora
# Recipe:: backend
#
# Copyright 2013, University of Toronto Libraries, Ryerson University Library and Archives
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Download Drupal filter
# TODO: rework this to build the filter against the installed version of fedora
remote_file "#{node[:tomcat][:webapp_dir]}/fedora/WEB-INF/lib/fcrepo-drupalauthfilter.jar" do
  source "http://freedaleaskey.plggta.org/sites/default/files/fcrepo-drupalauthfilter-3.7.0.jar"
  checksum node[:drupal_filter][:sha256]
  owner node[:tomcat][:user]
  owner node[:tomcat][:group]
end

# set Drupal auth type in jaas.conf (assumes FESL)
template "#{node[:fedora][:installpath]}/server/config/jaas.conf" do
  source "jaas.conf.erb"

  owner node[:tomcat][:user]
  group node[:tomcat][:group]
end

# template filter-drupal.xml
template "#{node[:fedora][:installpath]}/server/config/filter-drupal.xml" do
  source "filter-drupal.xml.erb"

  owner node[:tomcat][:user]
  group node[:tomcat][:group]

  # Force Tomcat to reload
  notifies :start, "service[tomcat]"#, :immediately
end
