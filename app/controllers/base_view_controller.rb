class BaseViewController < UIViewController
  attr_accessor :box

  def viewDidLoad
    super
    self.view.backgroundColor = UIColor.colorWithPatternImage(UIImage.imageNamed('background_tile.png'))
  end

  # Pass in the desired location for the box. This may be different for each view.
  def new_box(x, y)
    image = UIImage.imageNamed("box1")
    image_view = UIImageView.alloc.initWithFrame([[x, y], [image.size.height, image.size.width]])
    image_view.image = image
    image_view
  end

  def animator
    @animator ||= UIDynamicAnimator.alloc.initWithReferenceView(self.view)
  end
end
