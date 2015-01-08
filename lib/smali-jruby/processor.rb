
module Smali
  class Processor
    TOKEN_NAMES = Smali::TOKEN_NAMES.dup.freeze
    TOKEN_HANDLERS = ([:on_any] * Smali::TOKEN_NAMES.size).freeze

    def process node
      method = self.class::TOKEN_HANDLERS[node.type]
      self.send(method, node) || node
    end

    def process_all nodes
      nodes.to_a.map do |child|
        process child
      end
    end

    def on_any node
      children = process_all node.children
      node.updated nil, nil, children
    end

    class << self
      # This may not be the cleanest solution,
      # but it prevents the need of modifying
      # Processor to use super.
      alias old_new new
      def new
        klass = Class.new(self)
        class << klass
          alias new old_new
          undef old_new
        end
        klass
      end

      private
      def inherited klass
        # Token names are copied to allow renaming to
        # more user friendly names.
        klass.const_set :TOKEN_NAMES, self::TOKEN_NAMES.dup
        klass.const_set :TOKEN_HANDLERS, self::TOKEN_HANDLERS.dup
      end

      def add_handler token_name, method_name
        raise StandardError, "Method name must start with 'on_'." if method_name !~ /^on_/
        i = self::TOKEN_NAMES.find_index token_name.to_s
        self::TOKEN_HANDLERS[i] = method_name.to_sym
        self.superclass.class_eval do
          if not instance_methods.include? method_name.to_sym
            alias_method method_name, :on_any
          end
        end
      end
    end

    freeze
  end
end
