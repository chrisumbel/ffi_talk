require 'rubygems'
require 'ffi'

SMART_ATTRIBUTES = {
  0x01 => 'Read Error Rate',
  0x02 => 'Throughput Performance',
  0x03 => 'Spin-Up Time',
  0x04 => 'Start/Stop Count',
  0x05 => 'Reallocated Sectors Count',
  0x06 => 'Read Channel Margin',
  0x07 => 'Seek Error Rate',
  0x08 => 'Seek Time Performance',
  0x09 => 'Power-On Hours (POH)',
  0x0a => 'Spin Retry Count',
  0x0b => 'Recalibration Retries Calibration_Retry_Count',
  0x0c => 'Power Cycle Count',
  0x0d => 'Soft Read Error Rate',
  0xb7 => 'SATA Downshift Error Count',
  0xb8 => 'End-to-End error',
  0xb9 => 'Head Stability',
  0xba => 'Induced Op-Vibration Detection',
  0xbb => 'Reported Uncorrectable Errors',
  0xbc => 'Command Timeout',
  0xbd => 'High Fly Writes',
  0xbe => 'Airflow Temperature (WDC)',
  0xbe => 'Temperature Difference from 100',
  0xbf => 'G-sense error rate',
  0xc0 => 'Power-off Retract Count Emergency Retract Cycle count (Fujitsu)[16]',
  0xc1 => 'Load Cycle Count Load/Unload Cycle Count (Fujitsu)',
  0xc2 => 'Temperature',
  0xc3 => 'Hardware ECC Recovered',
  0xc4 => 'Reallocation Event Count',
  0xc5 => 'Current Pending Sector Count',
  0xc6 => 'Uncorrectable Sector Count',
  0xc7 => 'UltraDMA CRC Error Count',
  0xc8 => 'Multi-Zone Error Rate [23]',
  0xc8 => 'Write Error Rate (Fujitsu)',
  0xc9 => 'Soft Read Error Rate',
  0xca => 'Data Address Mark errors',
  0xcb => 'Run Out Cancel',
  0xcc => 'Soft ECC Correction',
  0xcd => 'Thermal Asperity Rate (TAR)',
  0xce => 'Flying Height',
  0xcf => 'Spin High Current',
  0xd0 => 'Spin Buzz',
  0xd1 => 'Offline Seek Performance',
  0xd2 => 'Maxtor Error',
  0xd3 => 'Vibration During Write',
  0xd4 => 'Shock During Write',
  0xdc => 'Disk Shift',
  0xdd => 'G-Sense Error Rate',
  0xde => 'Loaded Hours',
  0xdf => 'Load/Unload Retry Count',
  0xe0 => 'Load Friction',
  0xe1 => 'Load/Unload Cycle Count',
  0xe2 => 'Load "In"-time',
  0xe3 => 'Torque Amplification Count',
  0xe4 => 'Power-Off Retract Cycle',
  0xe6 => 'GMR Head Amplitude',
  0xe7 => 'Temperature',
  0xf0 => 'Head Flying Hours',
  0xf0 => 'Transfer Error Rate (Fujitsu)',
  0xf1 => 'Total LBAs Written',
  0xf2 => 'Total LBAs Read',
  0xfa => 'Read Error Retry Rate',
  0xfe => 'Free Fall Protection'
}

NR_ATTRIBUTES = 30

class DataCollectionStruct < FFI::Struct
  def to_hash
    Hash[*self[:values].select {|v| 
      v[:id] > 0}.map{|v| 
        [v[:id], v[:data]]}.flatten]
  end
end

class Threshold < FFI::Struct
  layout    :id, :uchar, 0,
            :data, :uchar, 1,
            :reserved, [:uchar, 10], 2
end

class ThresholdTable < DataCollectionStruct
  layout    :revision, :ushort, 0,
            :values, [Threshold, NR_ATTRIBUTES], 2,
            :reserved, [:uchar, 18], 14,
            :vendor, [:uchar, 131], 32,
            :checksum, :uchar, 163
end

class Value < FFI::Struct
  layout    :id, :uchar, 0,
            :status, :ushort, 1,
            :data, :uchar, 3,
            :vendor, [:uchar, 8], 4 
end

class ValueTable < DataCollectionStruct
  layout    :revision, :ushort, 0,
            :values, [Value, NR_ATTRIBUTES], 2,
            :offline_status, :uchar, 362,
            :vendor1, :uchar, 363,
            :offline_timeout, :ushort, 364,
            :vendor2, :uchar, 366,
            :offline_capability, :uchar, 367,
            :smart_capability, :ushort, 368,
            :reserved, [:uchar, 16], 370,
            :vendor, [:uchar, 125], 386,
            :checksum, [:uchar, 511]
end

class Drive 
  extend FFI::Library

  ffi_lib './libsmart.so'
  attach_function :smart_open, [:string], :int
  attach_function :smart_close, [:int], :int
  attach_function :smart_get_values, [:int, :pointer], :int
  attach_function :smart_get_thresholds, [:int, :pointer], :int

  attr_accessor :thresholds

  def values
    value_table_ptr = FFI::MemoryPointer.new(:pointer, ValueTable.size)
    smart_get_values(@fd, value_table_ptr)
    ValueTable.new(value_table_ptr).to_hash
  end

  def initialize(device_path)
    @fd = smart_open device_path

    threshold_table_ptr = FFI::MemoryPointer.new(:pointer, ThresholdTable.size)
    smart_get_thresholds(@fd, threshold_table_ptr)
    @thresholds = ThresholdTable.new(threshold_table_ptr).to_hash
  end
end

# smartctl -a /dev/sda1
drive = Drive.new('/dev/sda1')
thresholds = drive.thresholds
values = drive.values

values.each_pair do |key, value|
  puts "#{key}\t#{SMART_ATTRIBUTES[key]}: #{value}\t(#{thresholds[key]})"
end
