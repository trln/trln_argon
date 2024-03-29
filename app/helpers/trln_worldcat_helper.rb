module TrlnWorldcatHelper
  include ApplicationHelper

  def worldcat_url_available?
    WorldcatQueryService.available?
  end

  def worldcat_query
    old_wq = WorldcatQueryService.new(session[:worldcat]) unless session[:worldcat].nil?
    new_wq = WorldcatQueryService.new(@current_search_session)
    return old_wq if old_wq && old_wq.id == new_wq.id

    session[:worldcat] = nil
    session[:worldcat] = new_wq.to_h
    session[:worldcat][:query_url] = new_wq.query_url
    new_wq
  end
end
