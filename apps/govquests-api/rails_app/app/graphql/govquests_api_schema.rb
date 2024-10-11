# frozen_string_literal: true

class GovquestsApiSchema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)

  # For batch-loading (see https://graphql-ruby.org/dataloader/overview.html)
  use GraphQL::Dataloader

  rescue_from ActiveModel::ValidationError do |err, _obj, _args, _ctx, _field|
    raise GraphQL::ExecutionError, err.message
  end

  rescue_from(ActionPolicy::Unauthorized) do |exp|
    raise GraphQL::ExecutionError.new(
      # use result.message (backed by i18n) as an error message
      exp.result.message,
      # use GraphQL error extensions to provide more context
      extensions: {
        code: :unauthorized,
        fullMessages: exp.result.reasons.full_messages,
        details: exp.result.reasons.details
      }
    )
  end

  # GraphQL-Ruby calls this when something goes wrong while running a query:
  def self.type_error(err, context)
    # if err.is_a?(GraphQL::InvalidNullError)
    #   # report to your bug tracker here
    #   return nil
    # end
    super
  end

  # Union and Interface Resolution
  def self.resolve_type(abstract_type, obj, ctx)
    # TODO: Implement this method
    # to return the correct GraphQL object type for `obj`
    raise(GraphQL::RequiredImplementationMissingError)
  end

  # Limit the size of incoming queries:
  max_query_string_tokens(5000)

  # Stop validating when it encounters this many errors:
  validate_max_errors(100)

  # Relay-style Object Identification:

  # Return a string UUID for `object`
  def self.id_from_object(object, type_definition, query_ctx)
    # For example, use Rails' GlobalID library (https://github.com/rails/globalid):
    object.to_gid_param
  end

  # Given a string UUID, find the object
  def self.object_from_id(global_id, query_ctx)
    # For example, use Rails' GlobalID library (https://github.com/rails/globalid):
    GlobalID.find(global_id)
  end
end
