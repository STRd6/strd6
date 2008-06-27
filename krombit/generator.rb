class Generator

  def self.generate(class_name)
    make_class_file class_name
    make_test_file class_name
  end

	def self.make_class_file(class_name)
    file_name = "lib/#{class_name.downcase}.rb"
    puts "Generating #{file_name}"
    write_file(file_name, class_skeleton(class_name))
	end

	def self.make_test_file(class_name)
    file_name = "test/#{class_name.downcase}_test.rb"
    puts "Generating #{file_name}"
    write_file(file_name, test_skeleton(class_name))	  
	end

	def self.write_file(file_name, data)
    if File.exists?(file_name)
      puts "File '#{file_name}' already exists!"
    else
  	  File.open(file_name, "w") do |file|
	      file.print data
	    end
    end
	end

	def self.class_skeleton (class_name)
    <<EOF
class #{class_name}

end
EOF
  end

	def self.test_skeleton (class_name)
    <<EOF
require File.dirname(__FILE__) + '/test_helper.rb'

class #{class_name}Test < Test::Unit::TestCase
  def test_new
    assert #{class_name}.new
  end
end
EOF
  end

end

if __FILE__ == $0
  Generator.generate(ARGV[0]) if ARGV[0]  
end
