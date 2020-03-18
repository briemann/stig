#
# Cookbook Name:: stig
# Recipe:: auditd
# Author: Ivan Suftin < isuftin@usgs.gov >
#
# Description: Installs the auditd cookbook with the CIS ruleset
#
# See: https://supermarket.chef.io/cookbooks/auditd

auditd_config_dir = '/etc/audit/'

directory auditd_config_dir

# Create auditd configuration file
template File.join(auditd_config_dir, 'auditd.conf') do
  source 'etc_audit_auditd.conf.erb'
  owner 'root'
  group 'root'
  mode 0o640
  notifies :restart, 'service[auditd]', :immediately
end

service 'auditd' do
  action :nothing
end

cookbook_file '/etc/audisp/audispd.conf' do
  source 'audispd.conf'
  owner 'root'
  group 'root'
  mode 0600
  notifies :stop, 'service[auditd]', :before
  notifies :start, 'service[auditd]', :delayed
end

cookbook_file '/etc/audisp/plugins.d/af_unix.conf' do
  source 'af_unix.conf'
  owner 'root'
  group 'root'
  mode 0600
  notifies :restart, 'service[auditd]', :delayed
end
