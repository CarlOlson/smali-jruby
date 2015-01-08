
module Smali
  class DexBuilder
    def add tree
      tree_stream = CommonTreeNodeStream.new tree
      dex_gen = SmaliTreeWalker.new tree_stream
      dex_gen.set_dex_builder self
      dex_gen.smali_file
      raise SyntaxError if not dex_gen.number_of_syntax_errors.zero?
    end

    def save_as out
      write_to FileDataStore.new java.io.File.new out
    end
  end
end
