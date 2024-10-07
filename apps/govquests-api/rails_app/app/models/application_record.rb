class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  # https://github.com/Shopify/tapioca/pull/236#issuecomment-927971299
  PrivateRelation = ::ActiveRecord::Relation

  def reload(...)
    clear_memery_cache!

    super
  end
end
