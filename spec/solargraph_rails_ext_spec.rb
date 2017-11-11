describe SolargraphRailsExt do
  before :all do
    @workspace = File.realpath(File.join(File.dirname(__FILE__), '..', 'rails-test'))
    @api_map = Solargraph::ApiMap.new(@workspace)
  end

  it "finds a model's runtime methods" do
    sugg = @api_map.get_methods('ApplicationRecord').map(&:to_s)
    expect(sugg).to include('where')
  end

  it "finds a model's instance methods" do
    sugg = @api_map.get_instance_methods('ApplicationRecord').map(&:to_s)
    expect(sugg).to include('save')
  end
end
