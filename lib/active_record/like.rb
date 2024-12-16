require "active_record"
require_relative "like/scope_spawner"

module ActiveRecord
  module Like
    module WhereChainExtensions
      def like(opts, *rest)
        ActiveRecord::Like::ScopeSpawners::LikeScopeSpawners.spawn(@scope, opts, rest)
      end

      def not_like(opts, *rest)
        ActiveRecord::Like::ScopeSpawners::NotLikeScopeSpawners.spawn(@scope, opts, rest)
      end
    end
  end
end

ActiveSupport.on_load(:active_record) do
  ActiveRecord.eager_load!

  ActiveRecord::QueryMethods::WhereChain.send(:include, ::ActiveRecord::Like::WhereChainExtensions)
end
