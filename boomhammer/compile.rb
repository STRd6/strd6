#!/usr/bin/ruby1.9
# Requires Ruby 1.9.1
# The license of this source is "Ruby License"

require 'json'

OutputCompileOption = {
  :peephole_optimization    =>true,
  :inline_const_cache       =>false,
  :specialized_instruction  =>false,
  :operands_unification     =>false,
  :instructions_unification =>false,
  :stack_caching            =>false,
}

puts RubyVM::InstructionSequence.compile(ARGF.read, "src", 1, OutputCompileOption).to_a.to_json
