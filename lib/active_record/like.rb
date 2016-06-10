require "active_record"

module ActiveRecord
  module QueryMethods
    module Like
      def like(opts, *rest)
        opts.each do |k,v|
          if v.is_a?(Array) && v.empty?
            opts[k] = ''
          end
        end

        chain_node(Arel::Nodes::Matches, opts, *rest) do |nodes|
          nodes.inject { |memo, node| Arel::Nodes::Or.new(memo, node) }
        end
      end

      def not_like(opts, *rest)
        opts = opts.reject { |_, v| v.is_a?(Array) && v.empty? }
        chain_node(Arel::Nodes::DoesNotMatch, opts, *rest) do |nodes|
          Arel::Nodes::And.new(nodes)
        end
      end

    private

      def chain_node(node_type, opts, *rest, &block)
        @scope.tap do |s|
          s.where_values += s.send(:build_where, opts, *rest).map do |r|
            if r.right.is_a?(Array)
              nodes = r.right.map { |expr| node_type.new(r.left, expr) }
              Arel::Nodes::Grouping.new block.call(nodes)
            else
              node_type.new(r.left, r.right)
            end
          end
        end
      end
    end
  end
end

ActiveRecord::QueryMethods::WhereChain.send(:include, ActiveRecord::QueryMethods::Like)
