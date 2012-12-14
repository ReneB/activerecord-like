require "active_record"

module ActiveRecord
  module QueryMethods
    module Like
      def like(opts, *rest)
        @scope.tap do |s|
          s.where_values += s.send(:build_where, opts, *rest).map do |r|
            Arel::Nodes::Matches.new(r.left, r.right)
          end
        end
      end

      def not_like(opts, *rest)
        @scope.tap do |s|
          s.where_values += s.send(:build_where, opts, *rest).map do |r|
            Arel::Nodes::DoesNotMatch.new(r.left, r.right)
          end
        end
      end
    end
  end
end

ActiveRecord::QueryMethods::WhereChain.send(:include, ActiveRecord::QueryMethods::Like)
