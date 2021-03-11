class Link < ApplicationRecord
  GIST_URL = /^(https|http):\/\/gist\.github\.com\/([^\/]+)\/([a-f0-9]+)$/i

  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: { with: URI.regexp }, if: Proc.new { |a| a.url.present? }

  def gist_link?
    url =~ GIST_URL
  end

  def gist_link
    Octokit::Client.new.gist(url.split('/').last).files.map { |f| { name: f[0].to_s, content: f[1]['content'] } }
  end
end
