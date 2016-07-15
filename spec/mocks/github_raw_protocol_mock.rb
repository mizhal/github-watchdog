require "easy/mock"

module GithubRawProtocolMock
  class << self
    def catalog
      @catalog ||= OpenStruct.new(
        "GithubTarget" => GithubTargetMock,
        "GithubRawContributionCount" => GithubRawContributionCountMock
      )
    end
  end
end

class GithubTargetMock
  include Easy::Mock::ObjectMock
  extend Easy::Mock::CollectionMock

  set_model_class GithubTargetMock

  attr_accessor :username

  def url
    "https://github.com/#{@username}"
  end

end

class GithubRawContributionCountMock
  include Easy::Mock::ObjectMock
  extend Easy::Mock::CollectionMock

  set_model_class GithubRawContributionCountMock

  attr_accessor :username, :date, :count
end