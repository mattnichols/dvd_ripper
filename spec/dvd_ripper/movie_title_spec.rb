require 'spec_helper'

describe ::DvdRipper::MovieTitle do
  subject { described_class.new(filename) }

  let(:filename) { "/movies/for/me/Logan's  Run  (1973).mov" }

  it "should parse basename" do
    expect(subject.basename).to eq("Logan's  Run  (1973)")
  end

  context "with different year formats" do
    filenames = [
      "/movies/for/me/Logan's Run (1973).mov",
      "/movies/for/me/Logan's Run (  1973  ).mov",
      "/movies/for/me/Logan's      Run      (1973 ).mov"
    ]

    filenames.each do |fn|
      let(:filename) { fn }

      it "should parse year for #{fn}" do
        expect(subject.year).to eq("1973")
        expect(subject.title).to eq("Logan's Run")
      end
    end
  end
end
