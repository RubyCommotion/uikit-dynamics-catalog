class DecorationView < UIView

  attr_accessor :arrow_view, :attachment_point_view, :attached_view, :attachment_offset, :attachment_decoration_layers, :center_point_view

  def init
    super
    if self
      create_arrow_view
      @attachment_decoration_layers = create_attachment_decoration_layers
    else
      return nil
    end
    self
  end


  def initWithCoder(aDecoder)
    super
    if (self)
    end
    self
  end


  def dealloc
    if attachment_point_view && attached_view
      self.attachment_point_view.removeObserver(self, forKeyPath: 'center')
      self.attached_view.removeObserver(self, forKeyPath: 'center')
    end
  end


  def drawMagnitudeVectorWithLength(length, angle:angle, color:arrowColor, forLimitedTime:temporary)
    arrow_view.bounds = CGRectMake(0, 0, length, self.arrow_view.bounds.size.height)
    arrow_view.transform = CGAffineTransformMakeRotation(angle)
    arrow_view.tintColor = arrowColor
    arrow_view.alpha = 1
    if (temporary)
      UIView.animateWithDuration(1.0, animations: ->{ arrow_view.alpha = 0 })
    end
  end


  def trackAndDrawAttachmentFromView(attachment_point_view, toView: attached_view, withAttachmentOffset: attachment_offset)
    self.attachment_point_view = attachment_point_view; self.attached_view = attached_view;  self.attachment_offset = attachment_offset

    # Tracking changes to the properties (see layoutSubviews) of any id<UIDynamicItem> involved in  a simulation incurs a performance cost.
    # Observe the 'center' property of both views to know when they move.
    attachment_point_view.addObserver(self, forKeyPath: 'center', options:0, context: nil)
    attached_view.addObserver(self, forKeyPath: 'center', options: 0, context: nil)
    self.setNeedsLayout
  end


  def layoutSubviews
    super
    arrow_view.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))

    if @center_point_view
      center_point_view.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
    end

    if attachment_point_view && attached_view
      max_dashes = attachment_decoration_layers.count
      attachment_point_view_center = CGPointMake(self.attachment_point_view.bounds.size.width/2, self.attachment_point_view.bounds.size.height/2)
      attachment_point_view_center = self.attachment_point_view.convertPoint(attachment_point_view_center, toView: self)
      attached_view_attachment_point = CGPointMake(self.attached_view.bounds.size.width/2 + self.attachment_offset.x, self.attached_view.bounds.size.height/2 + self.attachment_offset.y)
      attached_view_attachment_point =  self.attached_view.convertPoint(attached_view_attachment_point, toView: self)
      distance = Math.sqrt( ((attached_view_attachment_point.x-attachment_point_view_center.x) ** 2.0) +
                            ((attached_view_attachment_point.y-attachment_point_view_center.y) ** 2.0) )
      angle = Math.atan2( attached_view_attachment_point.y-attachment_point_view_center.y,
                          attached_view_attachment_point.x-attachment_point_view_center.x )
      required_dashes = 0
      d = 0.0

      # Depending on the distance between the two views, a smaller number of dashes may be needed to adequately visualize the attachment.  Starting
      # with a distance of 0, we add the length of each dash until we exceed 'distance' computed previously or we use the maximum number of allowed
      # dashes, 'max_dashes'.
      while required_dashes < max_dashes
        dash_layer = attachment_decoration_layers[required_dashes]
        if (d + dash_layer.bounds.size.height) < distance
          d += dash_layer.bounds.size.height
          dash_layer.hidden = false
          required_dashes = required_dashes + 1
        else
          break
        end

        # Based on the total length of the dashes we previously determined were  necessary to visualize the attachment, determine the spacing between
        # each dash.
        dash_spacing = (distance - d) / (required_dashes + 1)
      end

      # Hide the excess dashes.
      while required_dashes < max_dashes
        attachment_decoration_layers[required_dashes].setHidden(true)
        required_dashes = required_dashes + 1
      end

      # Disable any animations.  The changes must take full effect immediately.
      CATransaction.begin
      CATransaction.setAnimationDuration(0)

      # Each dash layer is positioned by altering its affineTransform.  We combine the position of rotation into an affine transformation matrix
      # that is assigned to each dash.
      transform = CGAffineTransformMakeTranslation(attachment_point_view_center.x, attachment_point_view_center.y)
      transform = CGAffineTransformRotate(transform, angle - Math::PI/2)

      drawn_dashes = 0
      while (drawn_dashes < required_dashes)
        dash_layer = attachment_decoration_layers[drawn_dashes]
        transform = CGAffineTransformTranslate(transform, 0, dash_spacing)
        dash_layer.setAffineTransform(transform)
        transform = CGAffineTransformTranslate(transform, 0, dash_layer.bounds.size.height)
        drawn_dashes = drawn_dashes + 1
      end
      CATransaction.commit
    end
  end


  def observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)

    if (object == self.attachment_point_view || object == self.attached_view)
      self.setNeedsLayout
    else
      super
    end
  end

  private

  def create_arrow_view
      # First time initialization.
      arrow_image = UIImage.imageNamed('arrow').imageWithRenderingMode(UIImageRenderingModeAlwaysTemplate)
      self.arrow_view = UIImageView.alloc.initWithImage(arrow_image)
      arrow_view.bounds = CGRectMake(0, 0, arrow_image.size.width, arrow_image.size.height)
      arrow_view.contentMode = UIViewContentModeRight
      arrow_view.clipsToBounds = true
      arrow_view.layer.anchorPoint = CGPointMake(0.0, 0.5)
      arrow_view.alpha = 0
      self.addSubview(arrow_view)
  end


  def create_attachment_decoration_layers
    attachment_decoration_layers = []
    for i in 0..3
       dash_image = UIImage.imageNamed("dash#{(i % 3) + 1}")
       dash_layer = CALayer.layer
       dash_layer.contents = dash_image.CGImage
       dash_layer.bounds = CGRectMake(0, 0, dash_image.size.width, dash_image.size.height)
       dash_layer.anchorPoint = CGPointMake(0.5, 0)
       self.layer.insertSublayer(dash_layer, atIndex: 0)
       attachment_decoration_layers << dash_layer
    end
    attachment_decoration_layers
  end
end