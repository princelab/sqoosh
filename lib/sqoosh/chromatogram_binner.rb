require 'mspire/mzml'
require 'mspire/mzml/chromatogram'
require 'andand'
require 'binneroc'
require 'sqoosh/chromatogram'

module Sqoosh
  class ChromatogramBlock

    attr_accessor :chromatograms

    # takes an Mspire::Mzml object and returns the first MS1 scan's scan
    # window lower and upper limit. Returns nil if no ms1 spectrum or no scan
    # information.  Returns a doublet of floats if there is a scan, although
    # values may be nil.
    def start_and_stop(mzml)
      spectrum = mzml.find {|spectrum| spectrum.ms_level == 1 }
      spectrum.andand.scan.andand.scan_window_limits
    end

    # if start or stop are not given, they are found from the data (assumes
    # the scan window of the first MS1 scan is representative of all others).
    def bin(mzml_file, increment: 0.1, start: nil, stop: nil, default: 0.0, behavior: :sum)
      exclude_end = true
      Mspire::Mzml.open(mzml_file) do |mzml|
        unless start && stop
          (found_start, found_stop) = start_and_stop(mzml)
          start ||= found_start
          stop ||= found_stop
        end
        binned_spectra = []
        retention_times = []
        chromatogram_bin_minima
        mz_values_array = nil
        mzml.each do |spectrum|
          next unless spectrum.ms_level == 1
          retention_times << spectrum.retention_time
          reply = Binneroc.bin(*spectrum.mzs_and_intensities, start: start, stop: stop, increment: increment, default: default, behavior: behavior, return_xvals: !mz_values_array, exclude_end: exclude_end)
          unless mz_values_array
            mz_values_array = reply.shift
          end
          # reply is now intensities
          binned_spectra << reply
        end
      end
      chromatograms = binned_spectra.transpose.zip(mz_values_array).map do |intensities, mz|
        Sqoosh::Chromatogram.new retention_times, intensities, Range.new(mz, mz + increment, exclude_end)
      end
    end
  end
end
