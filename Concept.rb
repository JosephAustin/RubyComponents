# This code is MIT licensed, so enjoy!
#
# Author: Joseph Austin

# Nodes and components are concepts, which simply maintains a universal
# data structure that can be freely accessed in a thread safe manner.
class Concept
  @@fname = 'Data/core.data'
  @@file = nil
  @@mutex = Mutex.new

  # On startup load the data
  @@mutex.synchronize do
    begin
      File.open(@@fname, 'r') {|f| @@file = Marshal::load f}
    rescue
      @@file = {}
    end
  end

  def initialize(data)
    @data = data
  end

  def self.save
    if @@file
      @@mutex.synchronize do
        File.open(@@fname, 'w') {|f| f.write Marshal::dump(@@file) }
      end
    end
  end

  # Test dump of data
  def self.dump
    puts @@file
  end

  protected

  def _get(key)
    r = nil
    @@mutex.synchronize do
      r = @data[key]
    end
    r
  end

  def _set(key, val)
    @@mutex.synchronize do
      @data[key] = val
    end
  end

  def _remove(key)
    @@mutex.synchronize do
      @data.delete key unless @data[key].nil?
    end
  end
end
