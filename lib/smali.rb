
module Smali
  require 'java'
  require 'smali-2.0.3.jar'

  import org.antlr.runtime.CommonToken
  import org.antlr.runtime.CommonTokenStream
  import org.antlr.runtime.tree.CommonTree
  import org.antlr.runtime.tree.CommonTreeNodeStream
  import org.jf.dexlib2.writer.builder.DexBuilder;
  import org.jf.dexlib2.writer.io.FileDataStore;
  SmaliFlexLexer = Class.new(org.jf.smali.smaliFlexLexer)
  SmaliParser = Class.new(org.jf.smali.smaliParser)
  SmaliTreeWalker = Class.new(org.jf.smali.smaliTreeWalker)

  TOKEN_NAMES = org.jf.smali.smaliParser.tokenNames.to_a.freeze

  require_relative 'smali-jruby/common_tree.rb'
  require_relative 'smali-jruby/dex_builder.rb'
  require_relative 'smali-jruby/node.rb'
  require_relative 'smali-jruby/processor.rb'

  def self.parse_file filename
    data = File.new(filename, 'r').read
    reader = java.io.StringReader.new data

    lexer = SmaliFlexLexer.new reader

    tokens = CommonTokenStream.new lexer

    parser = SmaliParser.new tokens

    if not parser.number_of_syntax_errors.zero? or
        not lexer.number_of_syntax_errors.zero?
      raise SyntaxError, filename
    end

    parser.smali_file.tree
  end

end
