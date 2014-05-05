require 'rubygems'
require 'webmock/rspec'
require 'cocoapods/search'


def load_http_stub(file_name)
  file_path = File.join(File.dirname(__FILE__), 'http_stubs', file_name)
  File.read(file_path)
end

# http://d.hatena.ne.jp/POCHI_BLACK/20100324
# this method is written by wycats
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