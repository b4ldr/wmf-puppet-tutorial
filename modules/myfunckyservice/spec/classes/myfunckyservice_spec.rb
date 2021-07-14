# When working with the WMF control repo aka operations/puppet the following line is one of the
# more useful/important lines.  By default rspec runs a module in a dedicated directory and
# you have to specify all dependencies explicitly so that rspec also copies theses to the testing
# directory.
#
# For this module it would mean specifying stdlib and wmflib as dependences. in this case that should
# be fairly simple to add and we are unlikely to have any further dependencies imported based on wmflib/stdlib
# however in real environments one can quickly find them self recursing through multiple dependencies which can
# be painful.
#
# Another common practice is to just mock out external dependencies so we can get the tests working e.g.
#   ```ruby
#   let(:pre_condition) { 'type Wmflib::Ensure = String ' }
#   ```
#
# Bother of theses work arounds are perfectly fine, however as we know all our modules will exist
# in the control repo we may as well ad an implicit dependency on all modules. This is what the following line dose
#
# Specifically this line
#  * updates the puppet modules path to include all modules in the modules directory of the control repo
#  * updates the puppet hiera path to the hieradata folder in the control repo
#  * injects some custom facts and global variables used in our repo
# All of this should mean that module authors can simply includ this require and not have to worry about dependencies,
#  mocking and other hacks required to just get something running
require_relative '../../../../rake_modules/spec_helper'
# This should be the name of the class been tested
describe 'myfunckyservice' do
  # on_supported_on is a function provided by factedb, given an argument representing an array of OS's it will return
  # a set of mocked puppet facts this means things like the following are all avalible
  #  $facts['os']
  #  $facts['fqdn']
  #  $facts['networking']['ip']
  on_supported_os(WMFConfig.test_on).each do |os, facts|
    # describe this loop iteration
    context "on #{os}" do
      # Here we create a rspec facts variable from the ruby facts hash return from on_supported_os
      let(:facts) { facts }
      # Our module has a mandatory parameter so we need to provide some value otherwise the class
      # will fail to complie
      let(:params) { {api_key: 'foobar' } }

      # describe your test
      describe 'test with default settings' do
        # This is the most basic test do do, it simply tries to instantiate the class e.g.
        # class {'myfunckyservice':
        #   'api_key' => 'foobar',
        # }
        it { is_expected.to compile.with_all_deps }
      end
    end
  end
end
