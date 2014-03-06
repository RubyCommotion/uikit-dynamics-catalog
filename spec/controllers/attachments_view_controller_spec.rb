describe AttachmentsView do
  before do
    @subject = AttachmentsView.new
  end

  describe '#viewDidLoad' do
    it 'creates a DecorationView root view' do
      @subject.view.class.should.equal DecorationView
    end
  end

  describe '#viewDidLoad' do
    before do
      @subject.viewDidLoad
    end

    it 'added two behaviors' do
      @subject.animator.behaviors.count.should.equal 2
    end

    it 'added a collision behaviour with mode UICollisionBehaviorModeEverything' do
      @subject.collision_behavior.collisionMode.should.equal(-1)
    end

    it 'added an attachment behaviour with one item' do
      @subject.attachment_behavior.items.count.should.equal 1
    end

    it 'added three subviews' do
      @subject.self.view.subviews.count.should.not.equal 0
    end

    it 'added two subviews to the square1 subview ' do
      @subject.square1.subviews.count.should.equal 2
    end

    it 'added one panGestureRecognizer to the root view' do
      @subject.self.view.gestureRecognizers.count.should.equal 2
    end

  end
end
