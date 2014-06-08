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
      it { expect{ @executor.search('no_match_pod_name') }.to raise_error(LibraryNotFound) }
    end

    context 'updating repository' do
      before do
        expect(Open3).to receive(:capture3).and_return(
          ["Setting up CocoaPods master repo\Updating 64e7f15..96d38c5", 'stderr', double(success?: true)])
      end
      it { expect{ @executor.search('when updating repository') }.to raise_error(OldRepositoryError) }
    end

    context 'occored pods error' do
      before do
        expect(Open3).to receive(:capture3).and_return(
          ['stdout', 'stderr', double(success?: false)])
      end
      it { expect{ @executor.search('when error occured') }.to raise_error(PodError) }
    end

    context 'with exisiting pods' do
      before do
        stub_request_on_github 'AaronBratcher/ABSQLite'
        stub_request_on_github 'dodikk/CsvToSqlite'
        stub_request_on_github 'youknowone/sqlite3-objc'
        expect(Open3).to receive(:capture3).and_return([dummy_pod_search_result, '', double(success?: true)])
      end

      it 'display pods ordering by score' do
        res = <<-'EOS'.unindent
          |Name(Ver)                                 Score  Star  Fork
          |---------------------------------------- ------ ----- -----
          |CsvToSqlite (1.0)                            42    17     5
          |sqlite3-objc (0.2)                           17    12     1
          |ABSQLite (1.2.0)                              5     5     0
          |sqlite3 (3.8.4.3)                             -     -     -
        EOS
        expect { @executor.search('sqlite') }.to output(res).to_stdout
      end
    end

    context 'format with long pod name' do
      before do
        stub_request_on_github 'acerbetti/ACECoreDataManager'
        stub_request_on_github 'AFNetworking/AFNetworking'
        stub_request_on_github 'arlophoenix/AKANetworkLogging'
        expect(Open3).to receive(:capture3).and_return([dummy_pod_search_result_with_long_name, '', double(success?: true)])
      end

      after do
        # reset initialize
        # warning measure: already initialized constant
        [40, 6, 5, 5].each_with_index { |n, i| Rendering::DEFAULT_RULED_LINE_SIZE[i] = n }
      end

      it 'display with expanding name column' do
        res = <<-'EOS'.unindent
          |Name(Ver)                                      Score  Star  Fork
          |--------------------------------------------- ------ ----- -----
          |AFNetworking (2.2.3)                           28241 11941  3260
          |ACECoreDataNetworkTableViewController (0.0.2)      2     2     0
          |AKANetworkLogging (0.1.0)                          1     1     0
        EOS
        expect { @executor.search('sqlite') }.to output(res).to_stdout
      end
    end

    context 'bitbucket pod' do
      before do
        allow(Open3).to receive(:capture3).and_return([dummy_pod_search_result_with_bitbucket_pod, '', double(success?: true)])
      end

      it 'display with expanding name column' do
        res = <<-'EOS'.unindent
          |Name(Ver)                                 Score  Star  Fork
          |---------------------------------------- ------ ----- -----
          |CDSParticleFilter (0.5)                       -     -     -
        EOS
        expect { @executor.search('sqlite') }.to output(res).to_stdout
      end
    end
  end

  private
    def dummy_pod_search_nothing
      "[!] Unable to find a pod with name matching `no_match_pod_name'"
    end

    def dummy_pod_search_result
      <<-'EOS'.unindent
        |
        |
        |-> ABSQLite (1.2.0)
        |   ABSQLite is an Objective-C wrapper to SQLite making it easy to use the database.
        |   pod 'ABSQLite', '~> 1.2.0'
        |   - Homepage: https://github.com/AaronBratcher/ABSQLite
        |   - Source:   https://github.com/AaronBratcher/ABSQLite.git
        |   - Versions: 1.2.0, 1.1.0 [master repo]
        |
        |
        |-> CsvToSqlite (1.0)
        |   An iOS library to import a CSV file to the SQLite table
        |   pod 'CsvToSqlite', '~> 1.0'
        |   - Homepage: https://github.com/dodikk/CsvToSqlite
        |   - Source:   https://github.com/dodikk/CsvToSqlite.git
        |   - Versions: 1.0 [master repo]
        |
        |
        |-> sqlite3 (3.8.4.3)
        |   SQLite is an embedded SQL database engine.
        |   pod 'sqlite3', '~> 3.8.4.3'
        |   - Homepage: http://www.sqlite.org
        |   - Source:   http://www.sqlite.org/2014/sqlite-amalgamation-3080403.zip
        |   - Versions: 3.8.4.3, 3.8.4.2, 3.8.4.1, 3.8.1, 3.8.0.2, 3.8.0, 3.7.17.0, 3.7.16.2, 3.7.16.1, 3.7.16, 3.7.15.2,
        |   3.7.15.1, 3.7.15, 3.7.14.1 [master repo]
        |   - Sub specs:
        |     - sqlite3/common (3.8.4.3)
        |     - sqlite3/fts (3.8.4.3)
        |     - sqlite3/unicode61 (3.8.4.3)
        |     - sqlite3/coldata (3.8.4.3)
        |     - sqlite3/unlock_notify (3.8.4.3)
        |     - sqlite3/rtree (3.8.4.3)
        |     - sqlite3/stat3 (3.8.4.3)
        |     - sqlite3/stat4 (3.8.4.3)
        |     - sqlite3/soundex (3.8.4.3)
        |
        |
        |-> sqlite3-objc (0.2)
        |   Sqlite3 Objective-C wrapper.
        |   pod 'sqlite3-objc', '~> 0.2'
        |   - Homepage: https://github.com/youknowone/sqlite3-objc
        |   - Source:   https://github.com/youknowone/sqlite3-objc.git
        |   - Versions: 0.2 [master repo]
      EOS
    end

    def dummy_pod_search_result_with_long_name
      <<-'EOS'.unindent
        |
        |
        |-> AFNetworking (2.2.3)
        |   A delightful iOS and OS X networking framework.
        |   pod 'AFNetworking', '~> 2.2.3'
        |   - Homepage: https://github.com/AFNetworking/AFNetworking
        |   - Source:   https://github.com/AFNetworking/AFNetworking.git
        |   - Versions: 2.2.3, 2.2.2, 2.2.1, 2.2.0, 2.1.0, 2.0.3, 2.0.2, 2.0.1, 2.0.0, 2.0.0-RC3, 2.0.0-RC2, 2.0.0-RC1, 1.3.4, 1.3.3, 1.3.2, 1.3.1, 1.3.0, 1.2.1, 1.2.0,
        |   1.1.0, 1.0.1, 1.0, 1.0RC3, 1.0RC2, 1.0RC1, 0.10.1, 0.10.0, 0.9.2, 0.9.1, 0.9.0, 0.7.0, 0.5.1 [master repo]
        |   - Sub specs:
        |     - AFNetworking/Serialization (2.2.3)
        |     - AFNetworking/Security (2.2.3)
        |     - AFNetworking/Reachability (2.2.3)
        |     - AFNetworking/NSURLConnection (2.2.3)
        |     - AFNetworking/NSURLSession (2.2.3)
        |     - AFNetworking/UIKit (2.2.3)
        |
        |
        |-> ACECoreDataNetworkTableViewController (0.0.2)
        |   Adding pull to refresh to the table view controller included in the ACECoreDataManager.
        |   pod 'ACECoreDataNetworkTableViewController', '~> 0.0.2'
        |   - Homepage: https://github.com/acerbetti/ACECoreDataManager
        |   - Source:   https://github.com/acerbetti/ACECoreDataManager.git
        |   - Versions: 0.0.2 [master repo]
        |
        |
        |-> AKANetworkLogging (0.1.0)
        |   Network request logging of customizable verbosity, now with added CURL!
        |   pod 'AKANetworkLogging', '~> 0.1.0'
        |   - Homepage: https://github.com/arlophoenix/AKANetworkLogging
        |   - Source:   https://github.com/arlophoenix/AKANetworkLogging.git
        |   - Versions: 0.1.0 [master repo]
      EOS
    end

    def dummy_pod_search_result_with_bitbucket_pod
      <<-'EOS'.unindent
        |
        |
        |-> CDSParticleFilter (0.5)
        |   Implements a particle filter in Objective C
        |   pod 'CDSParticleFilter', '~> 0.5'
        |   - Homepage: http://codeswell.com/downloads/ios-particle-filter/
        |   - Source:   https://bitbucket.org/codeswell/cdsparticlefilter.git
        |   - Versions: 0.5, 0.4 [master repo]
      EOS
    end
end
