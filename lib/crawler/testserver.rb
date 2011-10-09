#!/usr/bin/env ruby
puts File.expand_path(File.dirname(__FILE__))
$: << File.expand_path(File.dirname(__FILE__))
require 'crawler'
require 'sinatra'
require 'sinatra/reloader'

get "/" do
  result =<<EOS
<ul>
  <li><a href = 'http://localhost:4567/page1'>page 1</a></li>
  <li><a href = 'http://localhost:4567/page2'>page 2</a></li>
  <li><a href = 'http://localhost:4567/page1'>page 1</a></li>  
</ul>
EOS
  result
end

get "/page1" do
  result =<<EOS
<p>hello from page 1</p>
<ul>
  <li><a href = 'http://localhost:4567/page1'>go to page 1 (self reference)</a></li>
  <li><a href = 'http://localhost:4567/page2'>go to page 2 (circular reference)</a></li>
</ul>
EOS
end

get "/page2" do
  result =<<EOS
<p>hello from page 2</p>
<ul>
  <li><a href = 'http://localhost:4567/page1'>go to page 1 (circular reference)</a></li>
  <li><a href = 'http://localhost:4567/page3'>go to page 3</a></li>
  <li><a href = 'http://localhost:4567/page99'>go to page 99 (not found)</a></li>
</ul>
EOS
end

get "/page3" do
  result =<<EOS
<p>hello from page 3</p>
EOS
end

get "/crawl" do
  url = params["url"] || "http://localhost:4567"
  depth = params["url"].to_i || 2
  crawl(url,depth).inspect
end