module AgoraApi
  module Comments
    def get_impact_metric_comments(round_id, metric_id, limit: 10, offset: 0, sort: "newest")
      query = {limit: limit, offset: offset, sort: sort}
      handle_response(self.class.get("/retrofunding/rounds/#{round_id}/impactMetrics/#{metric_id}/comments", @options.merge(query: query)))
    end

    def create_impact_metric_comment(round_id, metric_id, comment)
      body = {comment: comment}
      handle_response(self.class.put("/retrofunding/rounds/#{round_id}/impactMetrics/#{metric_id}/comments", @options.merge(body: body.to_json)))
    end

    def update_impact_metric_comment(round_id, metric_id, comment_id, comment)
      body = {comment: comment}
      handle_response(self.class.put("/retrofunding/rounds/#{round_id}/impactMetrics/#{metric_id}/comments/#{comment_id}", @options.merge(body: body.to_json)))
    end

    def delete_impact_metric_comment(round_id, metric_id, comment_id)
      handle_response(self.class.delete("/retrofunding/rounds/#{round_id}/impactMetrics/#{metric_id}/comments/#{comment_id}", @options))
    end

    def get_impact_metric_comment_votes(round_id, metric_id, comment_id)
      handle_response(self.class.get("/retrofunding/rounds/#{round_id}/impactMetrics/#{metric_id}/comments/#{comment_id}/votes", @options))
    end

    def vote_on_impact_metric_comment(round_id, metric_id, comment_id, vote)
      body = {vote: vote}
      handle_response(self.class.put("/retrofunding/rounds/#{round_id}/impactMetrics/#{metric_id}/comments/#{comment_id}/votes", @options.merge(body: body.to_json)))
    end
  end
end
