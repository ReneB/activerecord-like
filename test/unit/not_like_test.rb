require File.expand_path('../../helper', __FILE__)

describe ActiveRecord::QueryMethods::WhereChain do
  describe :not_like do
    it "creates an Arel DoesNotMatch node in the relation" do
      relation = Post.where.not_like(title: '')

      _(relation.where_clause.send(:predicates).first).must_be_instance_of(Arel::Nodes::DoesNotMatch)
    end

    describe "the Arel Node" do
      before do
        @attribute = "title"
        @value = '%value%'

        @relation = Post.where.like(@attribute => @value)
        @first_predicate = @relation.where_clause.send(:predicates).first
      end

      it "has the attribute as the left operand" do
        _(@first_predicate.left.name).must_equal @attribute
      end

      it "has the value as the right operand" do
        # Rails 5.0 & 5.1
        first_bind = if @relation.where_clause.respond_to?(:binds)
          @relation.where_clause.send(:binds).first
        else
          # Rails 5.2+
          @first_predicate.right.value
        end

        first_bind_value = if first_bind.respond_to?(:value)
          # Rails 5 & 6
          first_bind.value
        else
          # Rails 7.0
          first_bind
        end

        _(first_bind_value).must_equal @value
      end
    end
  end
end
