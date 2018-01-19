require 'spec_helper'
describe 'cls_conf_iptables' do

  context 'with defaults for all parameters' do
    it { should contain_class('cls_conf_iptables') }
  end
end
