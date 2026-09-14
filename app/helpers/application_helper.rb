module ApplicationHelper
  def format_cents(cents)
    number_to_currency(cents / 100.0)
  end

  def status_badge(status)
    tag.span(status.to_s.humanize, class: "badge badge-#{status}")
  end
end
