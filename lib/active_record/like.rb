require "active_record"

module ActiveRecord
  module QueryMethods
    module Like
      def like(opts, *rest)
        chain_node(Arel::Nodes::Matches, opts, *rest)
      end

      def not_like(opts, *rest)
        chain_node(Arel::Nodes::DoesNotMatch, opts, *rest)
      end

    private
      def chain_node(node_type, opts, *rest)
        @scope.tap do |s|
          s.where_values += s.send(:build_where, opts, *rest).map do |r|
            node_type.new(r.left, r.right)
          end
        end
      end
    end
  end
end

ActiveRecord::QueryMethods::WhereChain.send(:include, ActiveRecord::QueryMethods::Like)
