class Option::BabySeat < Option
  # 2 EUR/day, all the money goes to the owner
  COST_PER_DAY = 200

  def price
    rental.days * COST_PER_DAY
  end

  def payee
    :owner
  end
end
