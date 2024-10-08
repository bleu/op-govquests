module ActionTracking
  class ReadDocumentActionStrategy < ActionStrategy
    def action_type
      "read_document"
    end

    def description
      "Read a document"
    end

    def action_data(data)
      {document_url: data[:document_url]}
    end

    def verify_completion(data)
      true
    end
  end
end
