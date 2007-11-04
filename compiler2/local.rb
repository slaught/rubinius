class Compiler
  class Local
    def initialize(scope, name)
      @scope = scope
      @name = name
      @on_stack = true
      @argument = false
      @stack_position = nil
      @slot = nil
      @on_block = false
    end
    
    def inspect
      "#<#{self.class} #{@name}>"
    end
        
    def formalize!
      if @argument
        return if @on_stack
      elsif @on_stack
        @stack_position = @scope.allocate_stack
        # The scope returns nil if this local should not be
        # on the stack.
        return if @stack_position
        @on_stack = false
      end

      @slot = @scope.allocate_slot
    end
    
    def slot
      if @slot.nil?
        raise Error, "Attempted to use a unformalized local: #{@name}"
      end
      
      return @slot
    end
    
    def stack_position
      if @argument
        @position
      else
        @stack_position
      end
    end
        
    def in_locals!
      @on_stack = false
    end
    
    def created_in_block!
      @on_block = true
    end
    
    def created_in_block?
      @on_block
    end
    
    def access_in_block!
      @on_stack = false
    end
    
    def argument?
      @argument
    end
    
    def on_stack?
      @on_stack
    end
    
    def argument!(position)
      @position = position
      @argument = true
    end
  end
end
