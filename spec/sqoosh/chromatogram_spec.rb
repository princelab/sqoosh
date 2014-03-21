require 'spec_helper'

require 'sqoosh/chromatogram'

describe 'creating chromatograms from mzml' do
  it 'works' do
    mousefile = TESTFILES + "/MOUSE.mzml"
    chromatograms = Sqoosh::Chromatogram.create_chromatograms(mousefile)
    p chromatograms.size
    p chromatograms.first
  end
end
