require 'spec_helper'

describe Cocoapods::Search::Cli do
  context '#search' do
    context 'with exisiting pods' do
      before do
        @cli = Cocoapods::Search::Cli.new('sqlite')
        stub_request(:get, "https://github.com/AaronBratcher/ABSQLite").
          with(:headers => {'Accept'=>'*/*'}).
          to_return(
            :status => 200,
            :headers => {content_type: 'text/html'},
            :body => load_http_stub('ABSQLite'))
      end

      it 'should display pods ordering by score' do
        Open3.should_receive(:capture2).and_return(dummy_pod_search_result)
        capture(:stdout) { @cli.search }.should == <<-'EOS'
Name(Ver)                                 Score  Star  Fork
---------------------------------------- ------ ----- -----
ABSQLite (1.2.0)                              5     5     0
EOS
      end
    end
  end

  private
    def dummy_pod_search_result
<<'EOS'


-> ABSQLite (1.2.0)
   ABSQLite is an Objective-C wrapper to SQLite making it easy to use the database.
   pod 'ABSQLite', '~> 1.2.0'
   - Homepage: https://github.com/AaronBratcher/ABSQLite
   - Source:   https://github.com/AaronBratcher/ABSQLite.git
   - Versions: 1.2.0, 1.1.0 [master repo]
EOS
    end
end