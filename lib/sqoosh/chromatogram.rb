module Sqoosh
  class Chromatogram
    # note that this may be shared with other chromatograms
    attr_accessor :retention_times
    attr_accessor :intensities
    # a range object specifying the m/z values captured
    attr_accessor :range

    def initialize(retention_times, intensities, range)
      @retention_times, @intensities, @range = retention_times, intensities, range
    end
  end
end
