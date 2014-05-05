require 'rubygems'
require 'webmock/rspec'
require 'cocoapods/search'

def load_http_stub(file_name)
  file_path = File.join(File.dirname(__FILE__), 'http_stubs', file_name)
  File.read(file_path)
end

def stub_request_on_github(url)
  project = url.split('/').last
  stub_request(:get, url).
    with(:headers => {'Accept'=>'*/*'}).
    to_return(
      :status => 200,
      :headers => {content_type: 'text/html'},
      :body => load_http_stub(project))
end

# http://d.hatena.ne.jp/POCHI_BLACK/20100324
# This method is written by wycats
def capture(stream)
  begin
    stream = stream.to_s
    eval "$#{stream} = StringIO.new"
    yield
    result = eval("$#{stream}").string
  ensure
    eval("$#{stream} = #{stream.upcase}")
  end

  result
end