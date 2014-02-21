class BaseViewController < UIViewController
  attr_accessor :box

  def viewDidLoad
    super
    self.view.backgroundColor = UIColor.whiteColor
  end

  def new_box(x, y)
    image = UIImage.imageNamed("box1")
    image_view = UIImageView.alloc.initWithFrame([[x, y], [image.size.height, image.size.width]])
    image_view.image = image
    image_view
  end

  def animator
    @animator ||= UIDynamicAnimator.alloc.initWithReferenceView(view)
  end
end
