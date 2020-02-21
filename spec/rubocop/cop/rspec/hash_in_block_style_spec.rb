# frozen_string_literal: true

RSpec.describe RuboCop::Cop::RSpec::HashInBlockStyle do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  it "registers an offense when using `{ {} }`" do
    expect_offense(<<~RUBY)
      let(:params) { {} }
                     ^^ Please use Hash[] in inline block
    RUBY
  end

  it "does not register an offense when using `Hash[]`" do
    expect_no_offenses(<<~RUBY)
      let(:params) { Hash[] }
    RUBY
  end

  it "does not register an offense when using `Hash[foo: {baz: 123}]`" do
    expect_no_offenses(<<~RUBY)
      let(:params) { Hash[foo: {baz: 123}] }
    RUBY
  end

  it "does not register an offense when using `method {}`" do
    expect_no_offenses(<<~RUBY)
      let(:params) { }
    RUBY
  end

  it "autocorrect `{ {} }` to `{ Hash[] }` " do
    expect(autocorrect_source("let(:params) { {} }")).to eq("let(:params) { Hash[] }")
  end

  it "autocorrect `{ {foo: :baz} }` to `{ Hash[foo: :baz] }` " do
    expect(autocorrect_source("let(:params) { {foo: :baz} }"))
      .to eq("let(:params) { Hash[foo: :baz] }")
  end

  it "autocorrect `{ { foo: :baz } }` to `{ Hash[ foo: :baz ] }` " do
    # this case fix other cop :)
    expect(autocorrect_source("let(:params) { { foo: :baz } }"))
      .to eq("let(:params) { Hash[ foo: :baz ] }")
  end
end
