require 'andand'

require 'mspire/mzml'
require 'sqoosh/chromatogram'
require 'binneroc'

module Sqoosh
  module CreatesChromatograms

    # if start or stop are not given, they are found from the data (assumes
    # the scan window of the first MS1 scan is representative of all others).
    # If no scan window, then floors the lowest m/z and ceil's the highest.
    def create_chromatograms(mzml_file, increment: 0.1, start: nil, stop: nil, default: 0.0, behavior: :sum)
      exclude_end = true
      binned_spectra = []
      retention_times = []
      mz_values_array = nil
      Mspire::Mzml.open(mzml_file) do |mzml|
        unless start && stop
          spectrum = mzml.find {|spectrum| spectrum.ms_level == 1 }
          scan = spectrum.andand.scan
          if scan.scan_window
            (found_start, found_stop) = scan.scan_window_limits
          end
          unless found_start && found_stop
            (min, max) = spectrum.mzs.minmax
            found_start = min.floor unless found_start
            found_stop = max.ceil unless found_stop
          end
          start ||= found_start
          stop ||= found_stop
          puts "Found start m/z: #{start} and stop m/z: #{stop}" if $VERBOSE
        end

        print "binning spectra [100 per .]:" if $VERBOSE
        cnt = 0
        mzml.each do |spectrum|
          next unless spectrum.ms_level == 1
          cnt += 1
          if $VERBOSE && cnt % 100 == 0
            print "."
            $stdout.flush
          end
          retention_times << spectrum.retention_time
          reply = Binneroc.bin(
            *spectrum.mzs_and_intensities, 
            start: start, 
            stop: stop, 
            increment: increment, 
            default: default, 
            behavior: behavior, 
            return_xvals: !mz_values_array, 
            exclude_end: exclude_end
          )
          unless mz_values_array
            mz_values_array = reply.shift
            reply = reply.first 
          end
          # reply is now intensities
          binned_spectra << reply
        end
      end

      puts "transposing into chromatograms" if $VERBOSE
      binned_spectra.transpose.zip(mz_values_array).map do |intensities, mz|
        Sqoosh::Chromatogram.new retention_times, intensities, Range.new(mz, mz + increment, exclude_end)
      end
    end
  end
end
