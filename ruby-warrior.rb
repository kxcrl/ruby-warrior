class Player
  def play_turn(w)
    @warrior = w
    @health = 20
    @captive_location = nil
    take_turn
    set_status
  end

  def at_start
    feel(:backward).wall?
  end

  def captive_nearby
    if feel.captive?
      @captive_location = nil
      return true
    elsif feel.captive?(:backward)
      @captive_location = :backward
      return true
    else
      return false
    end
  end

  def fighting
    health < @health && !feel.empty?
  end

  def need_rest
    health < 20 && feel.empty?
  end

  def ranged_damage
    health < @health && feel.empty?
  end

  def take_turn
    if !at_start? || ranged_damage?
      walk!(:backward)
    elsif captive_nearby?
      rescue!(@captive_location)
    elsif fighting?
      attack!
    elsif need_rest?
      rest!
    else
      walk!
    end
  end

  def method_missing(w)
   @warrior.send(m)
  end
end
