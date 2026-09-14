user = User.find_or_create_by!(email: "demo@kickstart.dev") { |u| u.name = "Demo User" }

if user.credit_accounts.none?
  builder = user.credit_accounts.create!(
    name: "KickStart Credit Builder", credit_limit_cents: 75_000,
    balance_cents: 12_500, opened_on: 14.months.ago.to_date
  )
  card = user.credit_accounts.create!(
    name: "Everyday Secured Card", credit_limit_cents: 50_000,
    balance_cents: 21_000, opened_on: 6.months.ago.to_date
  )

  # Payment history: mostly on time, one late, one upcoming, one overdue.
  10.downto(2) do |i|
    p = builder.payments.create!(amount_cents: 1_000, due_on: i.months.ago.to_date)
    p.mark_paid!(on: i.months.ago.to_date - 1.day)
  end
  late = builder.payments.create!(amount_cents: 1_000, due_on: 45.days.ago.to_date)
  late.mark_paid!(on: 40.days.ago.to_date)
  builder.payments.create!(amount_cents: 1_000, due_on: 15.days.from_now.to_date)
  card.payments.create!(amount_cents: 3_500, due_on: 5.days.ago.to_date) # overdue

  user.disputes.create!(
    bureau: "Equifax",
    item_description: "Collections account #4432 from Acme Telecom",
    reason: "Not my account"
  ).submit!
  user.disputes.create!(
    bureau: "TransUnion",
    item_description: "Everyday Secured Card reported balance $2,900",
    reason: "Incorrect balance"
  )

  [[10, 588], [8, 597], [6, 610], [4, 624], [2, 641], [0, 655]].each do |months_ago, score|
    user.score_entries.create!(score: score, recorded_on: months_ago.months.ago.to_date)
  end

  user.create_score_goal!(target_score: 700, target_date: Date.current.end_of_year)
end

puts "Seeded: #{User.count} user, #{CreditAccount.count} accounts, " \
     "#{Payment.count} payments, #{Dispute.count} disputes, #{ScoreEntry.count} score entries"
