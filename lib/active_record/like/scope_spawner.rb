module ActiveRecord
  module Like
    module ScopeSpawners
      module Shared
        module Rails7AndBelowSpawner
          private

          def chain_node(node_type, &block)
            @scope.tap do |s|
              # Assuming `opts` to be `Hash`
              opts.each_pair do |key, value|
                # 1. Build a where clause to generate "predicates" & "binds"
                # 2. Convert "predicates" into the one that matches `node_type` (like/not like)
                # 3. Re-use binding values to create new where clause
                equal_where_clause = begin
                  # ActiveRecord 6.1, maybe higher
                  s.send(:build_where_clause, {key => value}, rest)
                end
                equal_where_clause_predicate = equal_where_clause.send(:predicates).first

                new_predicate = if equal_where_clause_predicate.right.is_a?(Array)
                  nodes = equal_where_clause_predicate.right.map do |expr|
                    node_type.new(equal_where_clause_predicate.left, expr)
                  end
                  Arel::Nodes::Grouping.new block.call(nodes)
                else
                  node_type.new(equal_where_clause_predicate.left, equal_where_clause_predicate.right)
                end

                # Passing `Arel::Nodes::Node` into `where_clause_factory`
                # Will lose the binding values since 5.1
                # due to this PR
                # https://github.com/rails/rails/pull/26073
                new_where_clause = Relation::WhereClause.new([new_predicate])

                s.where_clause += new_where_clause
              end
            end
          end
        end
      end
      private_constant :Shared

      module LikeScopeSpawners
        # Spawn different scopes based on value
        # Data conversion and query string generation are handled by different spanwer classes
        #
        # @return [ActiveRecord::Relation] Relation or collection proxy or some AR classs
        def self.spawn(*args)
          RAILS_VERSION_TO_SPAWNER_CLASS_MAPPINGS.fetch(ActiveRecord.version.to_s[0..2]).
            spawn(*args)
        end


        # :nodoc:
        class AbstractSpawner
          # :nodoc:
          attr_reader :scope, :opts, :rest

          # Spawn different scopes based on value
          # Just delegates to new though
          #
          # @param args [Array] arguments that are passed to #initialize
          #
          # @see #initialize
          def self.spawn(*args)
            new(*args).spawn
          end

          # Assign ivar only
          # Actual operation is in #spawn
          #
          # @param scope [ActiveRecord::Relation]
          #   Relation or collection proxy or some AR classes
          # @param opts [Hash]
          #   Column value pairs
          # @param rest [Array]
          #   Rest of arguments
          #
          # @see #spawn
          def initialize(scope, opts, *rest)
            @scope  = scope
            @opts   = opts
            @rest   = rest
          end

          # Spawn different scopes based on value
          # Data conversion and query string generation are handled by different spanwer classes
          #
          # @return [ActiveRecord::Relation] Relation or collection proxy or some AR classs
          def spawn
            raise NotImplementedError
          end
        end

        # :nodoc:
        class Rails71AndBelowSpawner < AbstractSpawner
          include Shared::Rails7AndBelowSpawner

          # :nodoc:
          def spawn
            opts.each do |k,v|
              if v.is_a?(Array) && v.empty?
                opts[k] = ''
              end
            end

            chain_node(Arel::Nodes::Matches) do |nodes|
              nodes.inject { |memo, node| Arel::Nodes::Or.new(memo, node) }
            end
          end
        end

        # :nodoc:
        class Rails72Spawner < AbstractSpawner
          include Shared::Rails7AndBelowSpawner

          # :nodoc:
          def spawn
            opts.each do |k,v|
              if v.is_a?(Array) && v.empty?
                opts[k] = ''
              end
            end

            chain_node(Arel::Nodes::Matches) do |nodes|
              Arel::Nodes::Or.new(nodes)
            end
          end
        end

        RAILS_VERSION_TO_SPAWNER_CLASS_MAPPINGS = {
          "7.0" => Rails71AndBelowSpawner,
          "7.1" => Rails71AndBelowSpawner,
          "7.2" => Rails72Spawner,
          "8.0" => Rails72Spawner,
          "8.1" => Rails72Spawner,
          "8.2" => Rails72Spawner,
        }.freeze
        private_constant :RAILS_VERSION_TO_SPAWNER_CLASS_MAPPINGS
      end

      module NotLikeScopeSpawners
        # Spawn different scopes based on value
        # Data conversion and query string generation are handled by different spanwer classes
        #
        # @return [ActiveRecord::Relation] Relation or collection proxy or some AR classs
        def self.spawn(*args)
          RAILS_VERSION_TO_SPAWNER_CLASS_MAPPINGS.fetch(ActiveRecord.version.to_s[0..2]).
            spawn(*args)
        end

        # :nodoc:
        class AbstractSpawner
          # :nodoc:
          attr_reader :scope, :opts, :rest

          # Spawn different scopes based on value
          # Just delegates to new though
          #
          # @param args [Array] arguments that are passed to #initialize
          #
          # @see #initialize
          def self.spawn(*args)
            new(*args).spawn
          end

          # Assign ivar only
          # Actual operation is in #spawn
          #
          # @param scope [ActiveRecord::Relation]
          #   Relation or collection proxy or some AR classes
          # @param opts [Hash]
          #   Column value pairs
          # @param rest [Array]
          #   Rest of arguments
          #
          # @see #spawn
          def initialize(scope, opts, *rest)
            @scope  = scope
            @opts   = opts
            @rest   = rest
          end

          # Spawn different scopes based on value
          # Data conversion and query string generation are handled by different spanwer classes
          #
          # @return [ActiveRecord::Relation] Relation or collection proxy or some AR classs
          def spawn
            raise NotImplementedError
          end
        end

        # :nodoc:
        class Rails71AndBelowSpawner < AbstractSpawner
          include Shared::Rails7AndBelowSpawner

          # :nodoc:
          def spawn
            @opts = opts.reject { |_, v| v.is_a?(Array) && v.empty? }
            chain_node(Arel::Nodes::DoesNotMatch) do |nodes|
              Arel::Nodes::And.new(nodes)
            end
          end
        end

        RAILS_VERSION_TO_SPAWNER_CLASS_MAPPINGS = {
          "7.0" => Rails71AndBelowSpawner,
          "7.1" => Rails71AndBelowSpawner,
          "7.2" => Rails71AndBelowSpawner,
          "8.0" => Rails71AndBelowSpawner,
          "8.1" => Rails71AndBelowSpawner,
          "8.2" => Rails71AndBelowSpawner,
        }.freeze
        private_constant :RAILS_VERSION_TO_SPAWNER_CLASS_MAPPINGS
      end
    end

  end
end
