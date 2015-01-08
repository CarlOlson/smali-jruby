
require_relative '../lib/smali.rb'

class SmaliPrintProcessor < Smali::Processor.new

  add_handler 'ACCESS_SPEC', :on_visibility

  def on_visibility node
    if node.text =~ /private|protected/
      node.updated nil, "public", nil
    end
  end

end

if ARGV[0].nil? or
    not File.exist? ARGV[0]
  puts "Smali file not specified or doesn't exist."
  exit
end

tree = Smali.parse_file ARGV[0]
node = SmaliPrintProcessor.new.process tree.to_node
builder = Smali::DexBuilder.make_dex_builder 15
builder.add node.to_tree
builder.save_as 'out.dex'
