module ActionExporter
  def generate_actions_from_rental(rental)
    [
      {
        who: :driver,
        type: :debit,
        amount: rental.price
      },
      {
        who: :owner,
        type: :credit,
        amount: rental.owner_share
      },
      {
        who: :insurance,
        type: :credit,
        amount: rental.insurance_fee
      },
      {
        who: :assistance,
        type: :credit,
        amount: rental.assistance_fee
      },
      {
        who: :drivy,
        type: :credit,
        amount: rental.drivy_share
      }
    ]
  end
end
