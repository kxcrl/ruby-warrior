class Player
  def initialize
    @health = 20
    @captive_location = nil
  end

  def play_turn(w)
    @warrior = w
    take_turn
    set_status
  end

  def at_start?
    @warrior.feel(:backward).wall? || @warrior.feel.empty?
  end

  def captive_nearby?
    if @warrior.feel.captive?
      @captive_location = nil
      return true
    elsif @warrior.feel.captive?(:backward)
      @captive_location = :backward
      return true
    else
      return false
    end
  end

  def fighting?
    health < @health && !feel.empty?
  end

  def need_rest?
    health < 20 && feel.empty?
  end

  def ranged_damage?
    health < @health && feel.empty?
  end

  def set_status
    @health = health
  end

  def take_turn
    if !at_start? || ranged_damage?
      @warrior.walk!(:backward)
    elsif @warrior.captive_nearby?
      @warrior.rescue!(@captive_location)
    elsif fighting?
      attack!
    elsif need_rest?
      rest!
    else
      walk!
    end
  end

  def method_missing(m)
   @warrior.send(m)
  end
end
