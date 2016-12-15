# This code is MIT licensed, so enjoy!
#
# Author: Joseph Austin

require "./Concept.rb"

# The node is an instance of an object which you attach your components to
class Node < Concept
  attr_reader :identifier

  def initialize(identifier)
    @identifier = identifier.downcase
    @component_mutex = Mutex.new

    @@mutex.synchronize do
      # Create or load this specific object from the data
      if @@file[@identifier].nil?
        $global_mutex.synchronize do
          $max_id += 1
          @@file[@identifier] = {
            id: $max_id
          }
        end
      end

      # Ensure universal fields are present
      @@file[@identifier] = {
          name: "",
          description: ""
      }.merge @@file[@identifier]

      super @@file[@identifier]
    end
  end

  def id
    _get :id
  end

  def name
    _get :name
  end

  def name=(val)
    _set :name, val
  end

  def description
    _get :description
  end

  def description=(val)
    _set :description, val
  end

  def addComponent(component)
    _set component.name, component.data
  end

  def removeComponent(component)
    _remove component.name
  end

  def getComponent(type)
    data = _get type::NAME
    if data.nil?
      return nil
    else
      return type.new data
    end
  end
end
