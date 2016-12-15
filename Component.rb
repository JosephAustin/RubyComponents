# This code is MIT licensed, so enjoy!
#
# Author: Joseph Austin

require "./Concept.rb"

# Components are attached to nodes and are self-maintained. You can keep an
# object to use its functions, but Node.getComponent can rebuild it for you.
#
# One major rule: every child class should have a class constant called
# NAME set to a field such as :my_name
class Component < Concept
  attr_reader :name, :data
  def initialize(name, template, data = nil)
    @name = name
    if data
      super data
    else
      super template
    end
  end
end
