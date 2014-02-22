class DecorationView < UIView

  #@interface APLDecorationView ()
  #@property (nonatomic, strong) UIView *attachmentPointView;
  #@property (nonatomic, strong) UIView *attachedView;
  #@property (nonatomic, readwrite) CGPoint attachmentOffset;
  ##! Array of CALayer objects, each with the contents of an image
  ##! for a dash.
  #@property (nonatomic, strong) NSMutableArray *attachmentDecorationLayers;
  #@property (nonatomic, weak) IBOutlet UIImageView *centerPointView;
  #@property (nonatomic, weak) UIImageView *arrowView;
  #@end

  attr_accessor :attachment_point_view, :attached_view, :attachment_offset, :attachment_decoration_layers, :arrow_view


  def initWithCoder(aDecoder)
    super
    if (self)
      @attachment_decoration_layers = []
      self.backgroundColor = UIColor.colorWithPatternImage(UIImage.imageNamed('BackgroundTile'))
    end
    self
  end


  def dealloc
    self.attachment_point_view.removeObserver(self, forKeyPath: 'center')
    self.attached_view.removeObserver(self, forKeyPath: 'center')
  end


  #  Draws an arrow with a given @a length anchored at the center of the receiver,
  #  that points in the direction given by @a angle.
  #
  def drawMagnitudeVectorWithLength(length, angle:angle, color:arrowColor, forLimitedTime:temporary)
    unless self.arrow_view
      # First time initialization.

      arrowImage = UIImage.imageNamed('Arrow').imageWithRenderingMode(UIImageRenderingModeAlwaysTemplate)

      arrowImageView = UIImageView.alloc.initWithImage(arrowImage)
      arrowImageView.bounds = CGRectMake(0, 0, arrowImage.size.width, arrowImage.size.height)
      arrowImageView.contentMode = UIViewContentModeRight
      arrowImageView.clipsToBounds = true
      arrowImageView.layer.anchorPoint = CGPointMake(0.0, 0.5)

      self.addSubview(arrowImageView)
      self.sendSubviewToBack(arrowImageView)
      self.arrow_view = arrowImageView
    end

    self.arrow_view.bounds = CGRectMake(0, 0, length, self.arrow_view.bounds.size.height)
    self.arrow_view.transform = CGAffineTransformMakeRotation(angle)
    self.arrow_view.tintColor = arrowColor
    self.arrow_view.alpha = 1

    if (temporary)
      # TODO check this syntax for lambda
      UIView.animateWithDuration(1.0, animations: ->{ self.arrow_view.alpha = 0 })
    end
  end

  # Draws a dashed line between @a attachment_point_view and @a attached_view
  # that is updated as either view moves.
  #
  def trackAndDrawAttachmentFromView(attachment_point_view, toView: attached_view, withAttachmentOffset: attachment_offset)

    unless self.attachment_decoration_layers
      # First time initialization.
      #self.attachment_decoration_layers = [NSMutableArray arrayWithCapacity:4]

      (0..4).each do |i|
        #for (NSUInteger i=0; i<4; i++)
        dashImage = UIImage.imageNamed(NSString.stringWithFormat("DashStyle#{(i % 3) + 1}"))

        dashLayer = CALayer.layer
        dashLayer.contents = dashImage.CGImage
        #dashLayer.contents = (__bridge id)(dashImage.CGImage)
        dashLayer.bounds = CGRectMake(0, 0, dashImage.size.width, dashImage.size.height)
        dashLayer.anchorPoint = CGPointMake(0.5, 0)

        self.layer.insertSublayer(dashLayer, atIndex: 0)
        self.attachment_decoration_layers.addObject(dashLayer)
      end
    end

      # A word about performance.
      # Tracking changes to the properties of any id<UIDynamicItem> involved in
      # a simulation incurs a performance cost.  You will receive a callback
      # during each step in the simulation in which the tracked item is not at
      # rest.  You should therefore strive to make your callback code as
      # efficient as possible.

      self.attachment_point_view.removeObserver(self, forKeyPath: 'center')
      self.attached_view.removeObserver(self, forKeyPath: 'center')

      self.attachment_point_view = attachment_point_view
      self.attached_view = attached_view
      self.attachment_offset = attachment_offset

      # Observe the 'center' property of both views to know when they move.
      self.attachment_point_view.addObserver(self, forKeyPath: 'center', options:0, context: nil)
      self.attached_view.addObserver(self, forKeyPath: 'center', options: 0, context: nil)

      self.setNeedsLayout
  end


  def layoutSubviews

    super

    self.arrow_view.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))

    if self.center_point_view
      self.center_point_view.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
    end

    if (self.attachment_decoration_layers)

      # Here we adjust the line dash pattern visualizing the attachement
      # between attachment_point_view and attached_view to account for a change
      # in the position of either.

      max_dashes = self.attachment_decoration_layers.count

      attachment_point_view_center = CGPointMake(self.attachment_point_view.bounds.size.width/2, self.attachment_point_view.bounds.size.height/2)
      attachment_point_view_center = self.attachment_point_view.convertPoint(attachment_point_view_center, toView: self)
      attached_view_attachment_point = CGPointMake(self.attached_view.bounds.size.width/2 + self.attachment_offset.x, self.attached_view.bounds.size.height/2 + self.attachment_offset.y)
      attached_view_attachment_point =  self.attached_view.convertPoint(attached_view_attachment_point, toView: self)

      distance = sqrtf( powf(attached_view_attachment_point.x-attachment_point_view_center.x, 2.0) +
                             powf(attached_view_attachment_point.y-attachment_point_view_center.y, 2.0) )

      angle = atan2( attached_view_attachment_point.y-attachment_point_view_center.y,
                     attached_view_attachment_point.x-attachment_point_view_center.x )

      required_dashes = 0
      d = 0.0

      # Depending on the distance between the two views, a smaller number of
      # dashes may be needed to adequately visualize the attachment.  Starting
      # with a distance of 0, we add the length of each dash until we exceed
      # 'distance' computed previously or we use the maximum number of allowed
      # dashes, 'max_dashes'.

      while required_dashes < max_dashes

        dash_layer = self.attachment_decoration_layers[required_dashes]

        if (d + dash_layer.bounds.size.height) < distance
          d += dash_layer.bounds.size.height
          dash_layer.hidden = false
          required_dashes = required_dashes + 1
        else
          break
        end

      # Based on the total length of the dashes we previously determined were
      # necessary to visualize the attachment, determine the spacing between
      # each dash.
      dash_spacing = (distance - d) / (required_dashes + 1)
      end

      # Hide the excess dashes.
      while required_dashes < max_dashes
        self.attachment_decoration_layers[required_dashes].setHidden(true)
        required_dashes = required_dashes + 1
      end

      # Disable any animations.  The changes must take full effect immediately.
      CATransaction.begin
      CATransaction.setAnimationDuration(0)

      # Each dash layer is positioned by altering its affineTransform.  We
      # combine the position of rotation into an affine transformation matrix
      # that is assigned to each dash.
      transform = CGAffineTransformMakeTranslation(attachment_point_view_center.x, attachment_point_view_center.y)
      transform = CGAffineTransformRotate(transform, angle - Math::PI/2)

      drawn_dashes = 0
      while (drawn_dashes < required_dashes)

        dash_layer = self.attachment_decoration_layers[drawn_dashes]

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

end