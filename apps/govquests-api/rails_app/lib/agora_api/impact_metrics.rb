module AgoraApi
  module ImpactMetrics
    def get_impact_metrics(round_id)
      handle_response(self.class.get("/retrofunding/rounds/#{round_id}/impactMetrics", @options))
    end

    def get_impact_metric(round_id, metric_id)
      handle_response(self.class.get("/retrofunding/rounds/#{round_id}/impactMetrics/#{metric_id}", @options))
    end

    def record_impact_metric_view(round_id, metric_id, address_or_ens)
      handle_response(self.class.post("/retrofunding/rounds/#{round_id}/impactMetrics/#{metric_id}/#{address_or_ens}", @options))
    end
  end
end
