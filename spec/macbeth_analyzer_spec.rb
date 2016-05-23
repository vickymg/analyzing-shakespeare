require 'macbeth_analyzer'

describe MacbethAnalyzer do

  subject(:analyzer) { described_class.new(doc = "spec/test_xml.xml") }
  let(:speech) {double :speech}
  let(:node_set) {double :node_set}

  it 'parses the xml document on initialization' do
    test_play = Nokogiri::HTML(open("spec/test_xml.xml"))
    expect(analyzer.play.text).to eq(test_play.text)
  end

  describe "#get_character_lines" do
    it 'finds the speeches' do
      expect(analyzer.get_character_lines).to eq({"First Witch"=>4, "Second Witch"=>4, "Third Witch"=>3})
    end
  end

  describe "#get_characters" do
    it 'finds all the characters' do
      allow(speech).to receive(:xpath).with(".//speaker").and_return([node_set, node_set])
      allow(node_set).to receive(:text).twice.and_return("First Witch")
      expect(analyzer.get_characters(speech)).to eq(['First Witch', 'First Witch'])
    end
  end

  describe "#count_lines" do
    it "counts the lines in a given speech" do
      allow(speech).to receive(:xpath).with(".//line").and_return(node_set)
      allow(node_set).to receive(:count).and_return(5)
      count = analyzer.count_lines(speech)
      expect(count).to eq 5
    end
  end

  describe "#print_speeches" do
    it "prints the number of lines for each character" do
      expect {analyzer.print_speeches}.to output("First Witch: 4\nSecond Witch: 4\nThird Witch: 3\n").to_stdout
    end
  end
end
