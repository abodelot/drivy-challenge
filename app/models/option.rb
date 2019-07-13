class Option < ActiveRecord::Base
  belongs_to :rental, required: true

  # 'type' is already taken
  self.inheritance_column = :sti_type

  def type=(value)
    # name (baby_seat) => sti name (Option::BabySeat)
    self.sti_type = 'Option::' + value.camelcase
  end

  def name
    # sti name => name
    self.sti_type.gsub('Option::', '').underscore
  end

  def price
    raise NotImplementedError
  end

  def payee
    raise NotImplementedError
  end
end
