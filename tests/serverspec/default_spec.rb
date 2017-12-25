require "spec_helper"

package = "cbsd"
service = "cbsdd"
# config = "/usr/local/etc/cbsd.conf"
workdir = "/usr/local/jails"

describe package(package) do
  it { should be_installed }
end

describe file("/etc/rc.conf.d/cbsdd") do
  it { should be_file }
  it { should be_mode 644 }
  its(:content) { should match(/^cbsd_workdir="#{ Regexp.escape(workdir) }"$/) }
end

describe file(workdir) do
  it { should be_directory }
  it { should be_mode 755 }
end

describe file("#{workdir}/nodename") do
  it { should be_file }
  it { should be_mode 644 }
  its(:content) { should match(/^#{ Regexp.escape("default-freebsd-103-amd64.localhost") }$/) }
end

describe service(service) do
  it { should be_enabled }
end

describe service("cbsd") do
  it { should be_running }
end

describe command("env NOCOLOR=1 workdir='#{workdir}' cbsd jls") do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should match(/^$/) }
  its(:stdout) { should match(/^JNAME  JID  IP4_ADDR  HOST_HOSTNAME  PATH  STATUS$/) }
end

describe command("env NOCOLOR=1 workdir='#{workdir}' cbsd -c 'cbsdsql local \"SELECT 1\"'") do
  its(:exit_status) { should eq 0 }
  its(:stderr) { should match(/^$/) }
  its(:stdout) { should match(/^1$/) }
end
