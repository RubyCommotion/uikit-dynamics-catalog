module ResizableDynamicItemModule

  class PositionToBoundsMapping < NSObject

  def initWithTarget(target)
   init
   @target = target
   self
  end


  #  Manual implementation of the getter for the bounds property required by
  #  UIDynamicItem.
   def bounds
     # Pass through
     @target.bounds
   end


  # The Obj-C version of PositionToBoundsMapping had set Bounds implemented implicitly via a property directive bounds
  # RM has to have the setBounds setter implemented manually as described in this RM support ticket.
  # https://hipbyte.freshdesk.com/support/tickets/1693

   def setBounds
     true
   end


  #  Manual implementation of the getter for the center property required by
  #  UIDynamicItem.
   def center
     CGPointMake(@target.bounds.size.width, @target.bounds.size.height)
   end


  #  Manual implementation of the setter for the center property required by
  #  UIDynamicItem.
   def setCenter(center)
     # center.x -> bounds.size.width, center.y -> bounds.size.height
     @target.bounds = CGRectMake(0, 0, center.x, center.y)
   end


  #  Manual implementation of the getter for the transform property required by
  #  UIDynamicItem.
   def transform
     # Pass through
     @target.transform
   end


  #  Manual implementation of the setter for the transform property required by
  #  UIDynamicItem.
   def setTransform(transform)
     # Pass through
     @target.transform = transform
   end

  end
 end
