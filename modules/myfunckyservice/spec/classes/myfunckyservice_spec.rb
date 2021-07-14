require_relative '../../../../rake_modules/spec_helper'
describe 'myfunckyservice' do
  on_supported_os(WMFConfig.test_on).each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }
      let(:params) { {api_key: 'foobar' } }

      # describe your test
      describe 'test with default settings' do
        # for our test module this is probably enough as we dont do much
        it { is_expected.to compile.with_all_deps }
        # however lets be verbose and add some more test
        # In the following example `it` means the compiled catalog
        # and contain_$resource_type checks for the given resource type
        # i.e. this tests that the catalog  is expected to contain a package with
        # a title of myfunckyservice, not it dosn't care if the ensure parameter is present or absent e.g.
        #   package{'myfunckyservice':}
        #
        # As this test fit on on line we use the curly brackets syntax e.g. it { ...}
        # for multi-line statements we will use it do ... end
        it { is_expected.to contain_package('myfunckyservice') }

        # Here we introduce the with_$parameter keyword.  this ensures that the $resource_type been checked
        # is configured with the $paramter matching the value passed
        # i.e. here we are saying that
        # the catalog is expected to contain a service resource with a title of myfunckyservice, the ensure
        # parameter set to 'running' and the enabled parmeter set to true e.g.
        #   service{'myfunckyservice':
        #     ensure  => 'running',
        #     enabled => 'true',
        #   }
        #
        it { is_expected.to contain_service('myfunckyservice').with_ensure('running').with_enabled(true) }

        it do
          is_expected.to contain_file('/etc/myfunckyservice/config.yaml')
            # We can chain as many with_$parameter calls together as we like but sometimes its easier to just pass
            # everything as a hash, this is what the with method is for
            .with(ensure: file, owner: 'root', group: 'root', mode: '0500')
            # one of the more attributes to check is the content of template file
            # this allows users to test that the erb logic is working as expected
            # in theory we could pass the entire string however itsd more common to just check for a regex pattern
            .with_content(
              %r{api_key: foobar}
            )
            # without works the same as with except we are that the resource doesn't have the specific parameter
            # we are calling the function here without an argument which means we don't want this parameter to exist at all
            .without_source
            # but we can also check for specific values just like `with`
            .without_mode('0777')
        end
      end
      # Another common usage pattern is to ensure that various parameter changes have the desired affect
      # most often the paramteter may change some logic of code path that you want to garuntee.  our module is pretty simple
      # however we can check that flippnig the ensure parameter dos the right thing
      describe 'test with changing the owner' do
        # We could redifine the entrie params hash here, however often you want to use a standard set of paremeters and only
        # change and test one at a time.  the super() function allows us to reuse the param,s defenitions higher up in the hierarcy
        # i.e. the define on line 6
        let(:params) { super().merge(ensure: 'absent') }

        it { is_expected.to contain_package('myfunckyservice').with_ensure('absent') }
        # remember because we are using stdlib::ensure we should get a value of stopped here not absent
        it { is_expected.to contain_service('myfunckyservice').with_ensure('stopped') }
        it { is_expected.to contain_file('/etc/myfunckyservice/config.yaml').with_ensure('absent') }
      end
    end
  end
end
