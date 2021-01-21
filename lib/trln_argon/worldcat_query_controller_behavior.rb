module TrlnArgon
  module WorldcatQueryControllerBehavior
    extend ActiveSupport::Concern

    included do
      # def show
      #   render json: hathi_links_grouped_by_oclc_number
      # end

      def worldcat_query
        old_wq = WorldcatQueryService.new(session[:worldcat]) unless session[:worldcat].nil?
        new_wq = WorldcatQueryService.new(@current_search_session)
        if !old_wq || (old_wq.id != new_wq.id)
          session[:worldcat] = nil
          session[:worldcat] = new_wq.to_h
          session[:worldcat][:count] = new_wq.count
          session[:worldcat][:query_url] = new_wq.query_url
          new_wq
        else
          old_wq
        end
      end
      private
      
  end
end
