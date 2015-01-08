
module Smali
  class Node
    attr_reader :children

    def initialize type=nil, text=nil, children=nil, token=nil
      if token.nil?
        @token = CommonToken.new type, text
      else
        @token = CommonToken.new token
      end
      @token.type = type if type
      @token.text = text if text
      @children = children.to_a.freeze
      freeze
    end

    def updated type=nil, text=nil, children=nil
      type ||= @token.type
      text ||= @token.text
      children ||= @children
      if @token.type == type and
          @token.text == text and
          @children == children
        self
      else
        self.class.new type, text, children, @token
      end
    end

    def type
      @token.type.freeze
    end

    def text
      @token.text.freeze
    end

    def line
      if @token.line == 0 and
          not @children.first.nil?
        @children.first.line
      else
        @token.line.freeze
      end
    end

    def type_name
      Smali::TOKEN_NAMES[type]
    end

    def child n
      # children should already be frozen
      @children[n].freeze
    end
    alias [] child

    def concat children
      updated nil, nil, [ *@children, *children.to_a ]
    end
    alias + concat

    def append child
      updated nil, nil, [ *@children, child ]
    end
    alias << append

    def to_a
      # children should already be frozen
      @children.freeze
    end

    def to_tree
      tree = CommonTree.new @token
      tree.add_children @children.map(&:to_tree)
      tree
    end
  end
end
