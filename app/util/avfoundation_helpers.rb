class CMTime
  def valid?
    (self.flags & KCMTimeFlags_Valid) != 0
  end

  def positive_infinity?
    self.valid? and (self.flags & KCMTimeFlags_PositiveInfinity) != 0
  end

  def negative_infinity?
    self.valid? and (self.flags & KCMTimeFlags_NegativeInfinity) != 0
  end

  def infinity?
    positive_infinity? or negative_infinity?
  end

  def indefinite?
    self.valid? and (self.flags & KCMTimeFlags_Indefinite) != 0
  end

  def numeric?
    self.valid? and (self.flags & (KCMTimeFlags_Valid | KCMTimeFlags_ImpliedValueFlagsMask)) == KCMTimeFlags_Valid
  end

  def has_been_rounded?
    self.numeric? and (self.flags & KCMTimeFlags_HasBeenRounded) != 0
  end

  def seconds
    CMTimeGetSeconds(self)
  end
end