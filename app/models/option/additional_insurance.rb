class Option::AdditionalInsurance < Option
  # 10EUR/day, all the money goes to Drivy
  COST_PER_DAY = 1000

  def price
    rental.days * COST_PER_DAY
  end

  def payee
    :drivy
  end
end
