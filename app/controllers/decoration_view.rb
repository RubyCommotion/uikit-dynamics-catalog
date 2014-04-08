class DecorationView < UIView

  attr_accessor :arrow_view, :attachment_point_view, :attached_view, :attachment_offset, :attachment_decoration_layers, :center_point_view

  def init
    super
    if self
      create_arrow_view
      self.attachment_decoration_layers = create_attachment_decoration_layers
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
    arrow_view
  end


  def trackAndDrawAttachmentFromView(attachment_point_view, toView: attached_view, withAttachmentOffset: attachment_offset)
    self.attachment_point_view = attachment_point_view
    self.attached_view = attached_view
    self.attachment_offset = attachment_offset

    # Tracking changes to the properties (see layoutSubviews) of any id<UIDynamicItem> involved in  a simulation incurs a performance cost.
    # Observe the 'center' property of both views to know when they move.
    attachment_point_view.addObserver(self, forKeyPath: 'center', options:0, context: nil)
    attached_view.addObserver(self, forKeyPath: 'center', options: 0, context: nil)
    self.setNeedsLayout
  end


  def layoutSubviews
    super

    arrow_view.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))

    if center_point_view
      center_point_view.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds))
    end

    if attachment_point_view && attached_view

      attachment_points = create_attachment_points
      distance_and_angle = calc_distance_and_angle(attachment_points[:attachment_point_view_center], attachment_points[:attached_view_attachment_point])

      # Depending on the distance between the two views, a smaller number of dashes may be needed to adequately visualize the attachment.  Starting
      # with a distance of 0, we add the length of each dash until we exceed 'distance' computed previously or we use the maximum number of allowed
      # dashes, 'max_dashes'.

      dashes = number_of_required_dashes(distance_and_angle[:distance])

      dash_spacing = (distance_and_angle[:distance] - dashes[:d]) / (dashes[:required_dashes] + 1)

      # Hide the excess dashes.
      dashes[:required_dashes] = hide_dashes(dashes[:required_dashes], dashes[:max_dashes])


      transform_object = make_transform_object(attachment_points[:attachment_point_view_center], distance_and_angle[:angle])
      do_transform(dashes[:required_dashes], dashes[:dash_layer], dash_spacing, transform_object)

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

  def calc_distance_and_angle(attachment_point_view_center, attached_view_attachment_point)

    distance_and_angle = {distance:nil, angle: nil}

    distance_and_angle[:distance] = Math.sqrt( ((attached_view_attachment_point.x-attachment_point_view_center.x) ** 2.0) +
                          ((attached_view_attachment_point.y-attachment_point_view_center.y) ** 2.0) )
    distance_and_angle[:angle] = Math.atan2( attached_view_attachment_point.y-attachment_point_view_center.y,
                        attached_view_attachment_point.x-attachment_point_view_center.x )
    distance_and_angle
  end

  def create_attachment_points

    attachment_points = {attachment_point_view_center:nil, attached_view_attachment_point: nil}

    attachment_points[:attachment_point_view_center] = CGPointMake(self.attachment_point_view.bounds.size.width/2, self.attachment_point_view.bounds.size.height/2)
    attachment_points[:attachment_point_view_center] = self.attachment_point_view.convertPoint(attachment_points[:attachment_point_view_center], toView: self)
    attachment_points[:attached_view_attachment_point] = CGPointMake(self.attached_view.bounds.size.width/2 + self.attachment_offset.x, self.attached_view.bounds.size.height/2 + self.attachment_offset.y)
    attachment_points[:attached_view_attachment_point] =  self.attached_view.convertPoint(attachment_points[:attached_view_attachment_point], toView: self)
    attachment_points
  end


  def number_of_required_dashes(distance)
    dashes = {required_dashes: 0, d: 0.0, max_dashes:attachment_decoration_layers.count, dash_layer: nil }

    dashes[:d] = 0.0
    dashes[:max_dashes] = attachment_decoration_layers.count

    while dashes[:required_dashes] < dashes[:max_dashes]
      dashes[:dash_layer] = attachment_decoration_layers[dashes[:required_dashes]]
      if (dashes[:d] + dashes[:dash_layer].bounds.size.height) < distance
        dashes[:d] += dashes[:dash_layer].bounds.size.height
        dashes[:dash_layer].hidden = false
        dashes[:required_dashes] = dashes[:required_dashes] + 1
      else
        break
      end
    end
    dashes
  end

  def hide_dashes(required_dashes, max_dashes)
    while required_dashes < max_dashes
      attachment_decoration_layers[required_dashes].setHidden(true)
      required_dashes = required_dashes + 1
    end
    required_dashes
  end

  def make_transform_object(attachment_point_view_center, angle)
    # Disable any animations. The changes must take full effect immediately.
    CATransaction.begin
    CATransaction.setAnimationDuration(0)
      # Each dash layer is positioned by altering its affineTransform.  We combine the position of rotation into an affine transformation matrix
      # that is assigned to each dash.
      transform = CGAffineTransformMakeTranslation(attachment_point_view_center.x, attachment_point_view_center.y)
      transform = CGAffineTransformRotate(transform, angle - Math::PI/2)
  end

  def do_transform(required_dashes, dash_layer, dash_spacing, transform_object)
    drawn_dashes = 0
    while drawn_dashes < required_dashes
      dash_layer = attachment_decoration_layers[drawn_dashes]
      transform_object = CGAffineTransformTranslate(transform_object, 0, dash_spacing)
      dash_layer.setAffineTransform(transform_object)
      transform_object = CGAffineTransformTranslate(transform_object, 0, dash_layer.bounds.size.height)
      drawn_dashes = drawn_dashes + 1
    end
    CATransaction.commit
  end


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