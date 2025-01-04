require File.expand_path('../../helper', __FILE__)

describe ActiveRecord::QueryMethods::WhereChain do
  describe :like do
    before do
      Post.create(id: 1, title: 'We need some content to test with')
      Post.create(id: 2, title: 'I really like DSLs - see what I did there?')
    end

    after do
      Post.delete_all
    end

    it "finds records with attributes matching the criteria" do
      _(Post.where.like(title: '%there?').map(&:id)).must_include 2
    end

    it "is case-insensitive" do
      search_term = "%dsls"

      lowercase_posts = Post.where.like(title: search_term)
      uppercase_posts = Post.where.like(title: search_term.upcase)

      _(lowercase_posts.map(&:id)).must_equal(uppercase_posts.map(&:id))
    end

    it "is chainable" do
      Post.where.like(title: '%there?').order(:title).update_all(title: 'some title')

      _(Post.find(2).title).must_equal('some title')
    end

    it "does not find records with attributes not matching the criteria" do
      _(Post.where.like(title: '%this title is not used anywhere%').map(&:id)).wont_include 2
    end

    describe "array behavior" do
      it "finds records with attributes matching multiple criteria" do
        _(Post.where.like(title: ['%DSLs%', 'We need some%']).map(&:id)).must_equal [1, 2]
      end

      it "finds records with attributes matching one criterion" do
        _(Post.where.like(title: ['%there?']).map(&:id)).must_equal [2]
      end

      it "does not find any records with an empty array" do
        _(Post.where.like(title: [])).must_be_empty
      end
    end

    describe "security-related behavior"  do
      before do
        @user_input = "unused%' OR 1=1); -- "
      end

      # This test is only here to provide the contrast for the test below
      # Interpolating input strings into LIKE queries is an all-too-common
      # mistake that is prevented by the syntax this plugin provides
      it "is possible to inject SQL into literal query strings" do
        _(Post.where("title LIKE '%#{@user_input}%'").count).must_equal(2)
      end

      it "prevents SQL injection" do
        _(Post.where.like(title: @user_input).count).must_equal(0)
      end

      it "prevents SQL injection when provided an array" do
        _(Post.where.like(title: [@user_input]).count).must_equal(0)
      end
    end
  end
end
