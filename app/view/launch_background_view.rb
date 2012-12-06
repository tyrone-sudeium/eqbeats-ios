class TestView < UIView
  attr_accessor :num

  @@static_num_count = 1
  def num
    @num ||= (@@static_num_count += 1)
  end

  def drawRect(rect)
    UIColor.blackColor.set
    UIBezierPath.bezierPathWithRect(rect).stroke
    "#{self.num}".drawInRect(rect, withFont:UIFont.fontWithName('Helvetica-Bold', size: 16))
  end

  def desiredHeight
    self.frame.size.height
  end

  def desiredWidth
    self.frame.size.width
  end

end

class LaunchBackgroundView < UIView
  attr_accessor :cell_size, :offscreen_cols, :offscreen_rows

  def cell_size
    @cell_size ||= CGSizeMake(40,40)
  end

  def offscreen_cols
    @offscreen_cols ||= 3
  end

  def offscreen_rows
    @offscreen_rows ||= 3
  end

  def column_size
    CGSizeMake(cell_size.width, self.frame.size.height)
  end

  def animation_offset
    cell_size.width * offscreen_cols
  end

  def layoutSubviews
    # (╯°□°）╯︵ ┻━┻ 
    @layout_view ||= begin
      v = HorizontalLayoutView.alloc.initWithFrame(self.bounds)
      f = v.frame
      f.origin.y = -40
      f.origin.x = -20
      v.frame = f
      self.addSubview(v)
      transform = CATransform3DIdentity
      transform.m34 = 1.0 / -500
      transform = CATransform3DRotate(transform, -0.3, 0.0, 1.0, 0.0)
      v.layer.transform = transform
      v
    end
    @columns ||= []
    num_columns = (self.frame.size.width / cell_size.width).ceil + offscreen_cols
    rows_per_col = (self.frame.size.height / cell_size.height).ceil + offscreen_rows
    needed_columns = num_columns - @columns.count
    needed_columns.times do
      view = VerticalLayoutView.alloc.initWithFrame([[0,0],column_size])
      rows_per_col.times do
        cell = TestView.alloc.initWithFrame([[0,0],cell_size])
        cell.backgroundColor = 'white'.to_color
        view.addSubview(cell)
      end
      @layout_view.addSubview(view)
      @columns << view
    end
  end

  def start_animating
    @animating ||= false
    if @animating then return; end
    @animating = true
    move_columns
  end

  def stop_animating
    @animating = false
  end

  def willMoveToWindow(newWindow)
    if newWindow.nil?
      stop_animating
    end
  end

  def didMoveToWindow
    unless self.window.nil?
      App.run_after(0.1) { start_animating }
    end
  end

  protected

  def move_columns
    @columns ||= []
    UIView.animateWithDuration(1, 
      delay:0, 
      options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear, 
      animations: -> {
        @columns.each do |view|
          f = view.frame
          f.origin.x -= animation_offset
          view.frame = f
        end
      }, 
      completion: -> complete {
        if complete and @animating
          rotate_columns
          move_columns
        end
      }
    )
  end

  def rotate_columns
    @columns.take(3).each do |view|
      f = view.frame
      f.origin.x += cell_size.width * @columns.count
      view.frame = f
    end
    @columns.rotate!(3)
  end

end