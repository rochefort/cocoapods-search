require 'spec_helper'

include Cocoapods::Search

RSpec.describe Executor do
  describe 'proxy settings' do
    before do
      allow(ENV).to receive(:[]).with('http_proxy').and_return('http://proxy_user:proxy_pass@192.168.1.99:9999')
      @executor = Executor.new
    end
    subject { @executor.instance_variable_get(:@agent) }
    its(:proxy_addr) { should eq '192.168.1.99' }
    its(:proxy_user) { should eq 'proxy_user' }
    its(:proxy_pass) { should eq 'proxy_pass' }
    its(:proxy_port) { should eq 9999 }
  end

  describe '#search' do
    before do
      @executor = Executor.new
    end

    context 'with nonexistance pods' do
      before do
        expect(Open3).to receive(:capture3).and_return(
          [dummy_pod_search_nothing, '', double(success?: false)])
      end
      it { expect { @executor.search('no_match_pod_name') }.to raise_error(LibraryNotFound) }
    end

    context 'updating repository' do
      before do
        expect(Open3).to receive(:capture3).and_return(
          ["Setting up CocoaPods master repo\Updating 64e7f15..96d38c5", 'stderr', double(success?: true)])
      end
      it { expect { @executor.search('when updating repository') }.to raise_error(OldRepositoryError) }
    end

    context 'occored pods error' do
      before do
        expect(Open3).to receive(:capture3).and_return(
          ['stdout', 'stderr', double(success?: false)])
      end
      it { expect { @executor.search('when error occured') }.to raise_error(PodError) }
    end
  end

  private

  def dummy_pod_search_nothing
    "[!] Unable to find a pod with name matching `no_match_pod_name'"
  end
end
