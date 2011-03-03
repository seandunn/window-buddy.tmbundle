require 'singleton'

module WindowBuddy
  module TmBaseWindow
    # Create the width and height attributes and they're
    # half_width, half_height helper methods
    %w{width height}.each do |attribute|
      attr_reader attribute.to_sym
      
      define_method :"half_#{attribute}" do
        instance_variable_get("@#{attribute}") / 2
      end
    end
     
    # returns [width, height]
    # where width and height are integers
    def dimentions
      @dimentions.split(',').map! { |dim| dim.to_i }
    end
    private :dimentions
  end
  
  class MainScreen
    include TmBaseWindow
    include Singleton
    
    def initialize
      @dimentions = `"$TMTOOLS" get mainScreenSize`
      @width  = dimentions.first
      @height = dimentions.last
    end

  end
  
  class CurrentWindow
    include TmBaseWindow
    attr_reader :origin_x, :origin_y
    
    def initialize
      @dimentions = `"$TMTOOLS" get windowOriginAndSize`
      @origin_x   = dimentions[0]
      @origin_y   = dimentions[1]
      @width      = dimentions[2]
      @height     = dimentions[3]
    end
    
    def origin!(new_x, new_y)
      `"$TMTOOLS" set windowOrigin '{x=#{new_x};y=#{new_y};}'`
    end
    
    def size!(new_x, new_y)
      `"$TMTOOLS" set windowSize '{width=#{new_x};height=#{new_y};}'`
    end
  end

end
