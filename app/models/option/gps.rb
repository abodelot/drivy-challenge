class Option::Gps < Option
  # GPS: 5EUR/day, all the money goes to the owner
  COST_PER_DAY = 500

  def price
    COST_PER_DAY * rental.days
  end

  def payee
    :owner
  end
end
