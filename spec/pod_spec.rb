require 'spec_helper'

describe Cocoapods::Search::Pod do
  context 'proxy settings' do
    before do
      @pod = Cocoapods::Search::Pod.new
    end
    subject { @pod }
    its(:has_github) { should be_false }
  end
end