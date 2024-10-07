module AgoraApi
  module RetroFunding
    def get_retro_funding_rounds(limit: 10, offset: 0)
      query = {limit: limit, offset: offset}
      handle_response(self.class.get("/retrofunding/rounds", @options.merge(query: query)))
    end

    def get_retro_funding_round(round_id)
      handle_response(self.class.get("/retrofunding/rounds/#{round_id}", @options))
    end

    def get_retro_funding_ballot(round_id, address_or_ens)
      handle_response(self.class.get("/retrofunding/rounds/#{round_id}/ballots/#{address_or_ens}", @options))
    end

    def submit_retro_funding_ballot(round_id, address_or_ens, ballot_content, signature)
      body = {
        address: address_or_ens,
        ballot_content: ballot_content,
        signature: signature
      }
      handle_response(self.class.post("/retrofunding/rounds/#{round_id}/ballots/#{address_or_ens}/submit", @options.merge(body: body.to_json)))
    end

    def get_retro_funding_projects(round_id, limit: 10, offset: 0, category: nil)
      query = {limit: limit, offset: offset, category: category}.compact
      handle_response(self.class.get("/retrofunding/rounds/#{round_id}/projects", @options.merge(query: query)))
    end

    def get_retro_funding_project(round_id, project_id)
      handle_response(self.class.get("/retrofunding/rounds/#{round_id}/projects/#{project_id}", @options))
    end

    def update_retro_funding_project_allocation(round_id, address_or_ens, project_id, allocation)
      handle_response(self.class.post("/retrofunding/rounds/#{round_id}/ballots/#{address_or_ens}/projects/#{project_id}/allocation/#{allocation}", @options))
    end

    def update_retro_funding_project_impact(round_id, address_or_ens, project_id, impact)
      handle_response(self.class.post("/retrofunding/rounds/#{round_id}/ballots/#{address_or_ens}/projects/#{project_id}/impact/#{impact}", @options))
    end

    def update_retro_funding_project_position(round_id, address_or_ens, project_id, position)
      handle_response(self.class.post("/retrofunding/rounds/#{round_id}/ballots/#{address_or_ens}/projects/#{project_id}/position/#{position}", @options))
    end

    def update_retro_funding_category_allocation(round_id, address_or_ens, category_data)
      handle_response(self.class.post("/retrofunding/rounds/#{round_id}/ballots/#{address_or_ens}/categories", @options.merge(body: category_data.to_json)))
    end

    def update_retro_funding_budget(round_id, address_or_ens, budget)
      handle_response(self.class.post("/retrofunding/rounds/#{round_id}/ballots/#{address_or_ens}/budget/#{budget}", @options))
    end

    def update_retro_funding_distribution_method(round_id, address_or_ens, distribution_method)
      handle_response(self.class.post("/retrofunding/rounds/#{round_id}/ballots/#{address_or_ens}/distribution_method/#{distribution_method}", @options))
    end
  end
end
