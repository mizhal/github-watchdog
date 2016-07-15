require "nokogiri"
require "open-uri"

module Github
  module Watchdog
    class ContributionScanner

      def initialize(catalog)
        @catalog = catalog
        @stop = false
      end

      def execute
        @catalog.GithubTarget.all.each do |target|
          profile = get_profile_page target.url
          days_counts = parse_days_and_counts profile
          days_counts.each do |day, count|
            contribution = @catalog.GithubRawContributionCount.find_by(
              username: target.username,
              date: day
            )
            if contribution.empty?
              contribution = @catalog.GithubRawContributionCount.create(
                username: target.username,
                date: day
              )
            else
              contribution = contribution.first
            end

            contribution.count = count

            contribution.save

            yield

            break if @stop
          end
        end
      end

      def stop
        @stop = true
      end

      private 

      def get_profile_page url
        data = open(url).read

        return Nokogiri::HTML(data)
      end

      def parse_days_and_counts page
        daynodes = page.css(".day")
        return daynodes.map do |daynode|
          [daynode["data-date"], daynode["data-count"]]
        end
      end

    end
  end
end