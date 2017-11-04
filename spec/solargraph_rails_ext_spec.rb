describe SolargraphRailsExt do
  it "finds a model's runtime methods" do
    api_map = Solargraph::ApiMap.new(File.realpath('./rails-test'))
    puts "One..."
    sugg = api_map.get_methods('ApplicationRecord').map(&:to_s)
    expect(sugg).to include('where')
    puts "Two..."
    sugg = api_map.get_methods('User').map(&:to_s)
    expect(sugg).to include('where')
    puts "Three..."
    sugg = api_map.get_methods('User').map(&:to_s)
    expect(sugg).to include('where')
    api_map.live_map.close
  end
end
