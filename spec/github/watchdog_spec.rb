require 'spec_helper'
require "mocks/github_raw_protocol_mock"

describe Github::Watchdog do
  it 'has a version number' do
    expect(Github::Watchdog::VERSION).not_to be nil
  end

  it 'scans contributions' do
    
  	catalog = GithubRawProtocolMock.catalog

  	targets = ["mizhal"]
  	targets.each do |target|
  		catalog.GithubTarget.create username: target
  	end

  	watchdog = Github::Watchdog::ContributionScanner.new catalog

  	watchdog.execute do 
  		puts "life" 
  		puts "is"
  		puts "life, "
  		puts "nana na nara"
  	end

  	expect(catalog.GithubRawContributionCount.count).to be > 0

  	catalog.GithubRawContributionCount.export_to_csv "raw-contributions.csv"

  	catalog.GithubTarget.destroy_all
  	catalog.GithubRawContributionCount.destroy_all

  end
end
