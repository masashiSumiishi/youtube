class BaseController < ApplicationController
  require 'google/apis/youtube_v3'
  require 'wikipedia'

  GOOGLE_API_KEY = Rails.application.credentials.youtube[:api]
  def home
    if params[:keyword].blank?
      @wiki = Wikipedia.find("ハリーポッター")
      @youtube = find_videos("ハリーポッター")
    else
      @wiki = Wikipedia.find(params[:keyword])
      @youtube = find_videos(params[:keyword])
    end
  end

  def find_videos(keyword)
    service = Google::Apis::YoutubeV3::YouTubeService.new
    service.key = GOOGLE_API_KEY
    next_page_token = nil
    opt = {
      q: keyword,
      type: 'video',
      max_results: 3,
      page_token: next_page_token,
    }
    service.list_searches(:snippet, opt)
  end
end
