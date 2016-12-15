# This code is MIT licensed, so enjoy!
#
# Author: Joseph Austin

require 'yaml'

# Open a yaml file if it exists, otherwise create it with blank contents
def open_create_yaml(file)
  file_structure = nil
  begin
    file_structure = YAML.load_file file
  rescue
    File.open(file, 'w') {|f| f.write '{}' }
    file_structure = YAML.load_file file
  end
  file_structure
end

# This handles the 'global data' such as largest max id number
$global_mutex = Mutex.new
$max_id = 0
begin
  file_structure = open_create_yaml "Data/global.data"
  if file_structure[:max_id].nil?
    file_structure[:max_id] = 0
  else
    $max_id = file_structure[:max_id]
  end
end

require "./Node.rb"
require "./Component.rb"

# Here is a test component with its very own field
class Test < Component
  NAME = :test

  def initialize(data = nil)
    super NAME, {
      test_field: ""
    }, data
  end

  def setTestField(strng)
    _set :test_field, strng
  end
end

# Make a node
n = Node.new "TestNode"
n.description = "This is a test"
n.name = "test"

# Make a component
n.addComponent Test.new
c = n.getComponent Test # Proof you can get components back without referencing

# Use the component's own functionality
c.setTestField "Victory is ours"

# Proof of result
Concept.dump

# Now save to binary
Concept.save

# Also save the globals - next time it all just exists
$global_mutex.synchronize do
  file_structure = open_create_yaml "Data/global.data"
  file_structure[:max_id] = $max_id
  File.open("Data/global.data", 'w') {|f| f.write file_structure.to_yaml}
end
