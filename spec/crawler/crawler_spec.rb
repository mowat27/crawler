require 'spec_helper'

describe 'crawl' do
  before :all do
    @test_url = "http://localhost:4567"
    begin
      open(@test_url)
    rescue
      fail "The test server is not running"
    end
  end
  
  context "starting at localhost:4567" do
    it "walks the page hierarchy and calculates a hash of urls and pages that link to them" do
      expected = {
        "#{@test_url}/page1"=>["#{@test_url}", "#{@test_url}/page1", "#{@test_url}/page2", "#{@test_url}"], 
        "#{@test_url}/page2"=>["#{@test_url}/page1", "#{@test_url}"],
        "#{@test_url}/page3"=>["#{@test_url}/page2"], 
        "#{@test_url}/page99"=>["#{@test_url}/page2"]
      }
      crawl(@test_url, 5).should == expected
    end
  end
end