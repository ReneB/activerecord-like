require File.expand_path('../../helper', __FILE__)

describe ActiveRecord::QueryMethods::WhereChain do
  describe :like do
    it "creates an Arel Matches node in the relation" do
      relation = Post.where.like(title: '')

      relation.where_clause.send(:predicates).first.must_be_instance_of(Arel::Nodes::Matches)
    end

    describe "the Arel Node" do
      before do
        @attribute = "title"
        @value = '%value%'

        relation = Post.where.like(@attribute => @value)
        @first_predicate  = relation.where_clause.send(:predicates).first
        @first_bind       = relation.where_clause.send(:binds).first
      end

      it "has the attribute as the left operand" do
        @first_predicate.left.name.must_equal @attribute
      end

      it "has the value as the right operand" do
        @first_bind.value.must_equal @value
      end
    end
  end
end
