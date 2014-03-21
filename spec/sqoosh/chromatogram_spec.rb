require 'spec_helper'

#require 'gnuplot'
require 'sqoosh/chromatogram'

describe 'creating chromatograms from mzml' do
  it 'works' do
    mousefile = TESTFILES + "/MOUSE.mzml"
    chromatograms = Sqoosh::Chromatogram.create_chromatograms(mousefile)

    # plot it:
    #chrom = chromatograms[100]
    #Gnuplot.open do |gp|
      #Gnuplot::Plot.new( gp ) do |plot|

        #plot.title "#{chrom.range.to_s}"
        #plot.ylabel "intensities"
        #plot.xlabel "retention time (s)"

        #plot.data << Gnuplot::DataSet.new( [chrom.retention_times, chrom.intensities] ) do |ds|
          #ds.with = "lines"
        #end
      #end
    #end

  end
end
