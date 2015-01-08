
module Smali
  class CommonTree
    def add_children children
      children.each { |child| add_child child }
    end

    def to_node
      if child_count.zero?
        Node.new nil, nil, nil, token
      else
        children = child_count.times.map { |i| child(i).to_node }
        Node.new nil, nil, children, token
      end
    end
  end
end
