require "spec_helper"

class ServiceNotReady < StandardError
end

sleep 10 if ENV["JENKINS_HOME"]

context "after provisioning finished" do
  describe server(:server1) do
    it "gets base" do
      result = current_server.ssh_exec("sudo env NOCOLOR=1 workdir=/usr/local/jails cbsd repo action=get sources=base")
      expect(result).to match(/Done\.\.\./)
    end

    it "starts a jail, foo" do
      result = current_server.ssh_exec("sudo env NOCOLOR=1 workdir=/usr/local/jails cbsd jcreate jconf=/usr/local/etc/foo.jconf")
      expect(result).to match(/^Creating foo complete: Enjoy!$/)
    end
  end
end
