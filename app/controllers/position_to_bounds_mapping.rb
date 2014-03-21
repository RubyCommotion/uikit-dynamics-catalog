class PositionToBoundsMapping < NSObject

attr_accessor :target, :bounds, :center, :transform

def initWithTarget(target)
  init
  if self
    @target = target
    @bounds = target.bounds
    puts "PtoB init target class and bounds: #{target.class} #{target.bounds.origin.x} #{target.bounds.origin.y} #{target.bounds.size.width} #{target.bounds.size.height}"
  else
    nil
  end
  self
end


#  Manual implementation of the getter for the bounds property required by
#  UIDynamicItem.
  def bounds
    # Pass through
    puts "PtoB bounds def bounds: #{self.target.bounds.origin.x} #{self.target.bounds.origin.y} #{self.target.bounds.size.width} #{self.target.bounds.size.height}"
    self.target.bounds
  end


#  Manual implementation of the getter for the center property required by
#  UIDynamicItem.
  def center
    #center.x <- bounds.size.width, center.y <- bounds.size.height
    puts "PtoB def center: #{self.target.bounds.size.width} #{self.target.bounds.size.height}"
    CGPointMake(self.target.bounds.size.width, self.target.bounds.size.height)
  end


#  Manual implementation of the setter for the center property required by
#  UIDynamicItem.
  def center=(center)
    # center.x -> bounds.size.width, center.y -> bounds.size.height
    self.target.bounds = CGRectMake(0, 0, center.x, center.y)
  end



#  Manual implementation of the getter for the transform property required by
#  UIDynamicItem.
  def transform
    # Pass through
    self.target.transform
  end


#  Manual implementation of the setter for the transform property required by
#  UIDynamicItem.
  def transform=(transform)
    # Pass through
    self.target.transform = transform
  end


end