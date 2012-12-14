require File.expand_path('../../helper', __FILE__)

describe ActiveRecord::QueryMethods::WhereChain do
  describe :like do
    it "creates an Arel Matches node in the relation" do
      relation = Post.where.like(title: '')

      relation.where_values.first.must_be_instance_of(Arel::Nodes::Matches)
    end

    describe "the Arel Node" do
      before do
        @attribute = :title
        @value = '%value%'

        @relation_specifier = Post.where.like(@attribute => @value).where_values.first
      end

      it "has the attribute as the left operand" do
        @relation_specifier.left.name.must_equal @attribute
      end

      it "has the value as the left operand" do
        @relation_specifier.right.must_equal @value
      end
    end
  end
end
