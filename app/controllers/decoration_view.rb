class DecorationView < UIView
  attr_accessor :attachment_point_view, :attached_view, :attachment_offset, :attachment_decoration_layers, :arrow_view, :center_point_view

  def initWithCoder(aDecoder)
    super

    @attachment_decoration_layers = []
    self.backgroundColor = UIColor.colorWithPatternImage(UIImage.imageNamed('BackgroundTile'))
    self
  end

  def dealloc
    self.attachment_point_view.removeObserver(self, forKeyPath: 'center')
    self.attached_view.removeObserver(self, forKeyPath: 'center')
  end

  def drawMagnitudeVectorWithLength(length, angle:angle, color:arrowColor, forLimitedTime:temporary)
    unless self.arrow_view
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

    if temporary
      UIView.animateWithDuration(1.0, animations: ->{ self.arrow_view.alpha = 0 })
    end
  end

  def trackAndDrawAttachmentFromView(attachment_point_view, toView: attached_view, withAttachmentOffset: attachment_offset)

    unless self.attachment_decoration_layers
      self.attachment_decoration_layers = []

      3.times do |i|
        dashImage = UIImage.imageNamed("dash#{i+1}")

        dashLayer = CALayer.layer
        dashLayer.contents = dashImage.CGImage
        dashLayer.bounds = CGRectMake(0, 0, dashImage.size.width, dashImage.size.height)
        dashLayer.anchorPoint = CGPointMake(0.5, 0)

        self.layer.insertSublayer(dashLayer, atIndex: 0)
        self.attachment_decoration_layers << dashLayer
      end
    end

    self.attachment_point_view.removeObserver(self, forKeyPath: 'center') if self.attachment_point_view
    self.attached_view.removeObserver(self, forKeyPath: 'center')         if self.attached_view

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

    if self.arrow_view
      self.arrow_view.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
    end

    if self.center_point_view
      self.center_point_view.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
    end

    if (self.attachment_decoration_layers)
      max_dashes = self.attachment_decoration_layers.count

      attachment_point_view_center = CGPointMake(self.attachment_point_view.bounds.size.width/2, self.attachment_point_view.bounds.size.height/2)
      attachment_point_view_center = self.attachment_point_view.convertPoint(attachment_point_view_center, toView: self)
      attached_view_attachment_point = CGPointMake(self.attached_view.bounds.size.width/2 + self.attachment_offset.x, self.attached_view.bounds.size.height/2 + self.attachment_offset.y)
      attached_view_attachment_point =  self.attached_view.convertPoint(attached_view_attachment_point, toView: self)

      distance = Math.sqrt( (attached_view_attachment_point.x-attachment_point_view_center.x)**2.0 +
                           (attached_view_attachment_point.y-attachment_point_view_center.y)**2.0 )

      angle = Math.atan2( attached_view_attachment_point.y-attachment_point_view_center.y,
                         attached_view_attachment_point.x-attachment_point_view_center.x )

      required_dashes = 0
      d = 0.0

      while required_dashes < max_dashes
        dash_layer = self.attachment_decoration_layers[required_dashes]

        if (d + dash_layer.bounds.size.height) < distance
          d += dash_layer.bounds.size.height
          dash_layer.hidden = false
          required_dashes = required_dashes + 1
        else
          break
        end

        dash_spacing = (distance - d) / (required_dashes + 1)
      end

      while required_dashes < max_dashes
        self.attachment_decoration_layers[required_dashes].setHidden(true)
        required_dashes = required_dashes + 1
      end

      # Disable any animations.  The changes must take full effect immediately.
      CATransaction.begin
      CATransaction.setAnimationDuration(0)

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
