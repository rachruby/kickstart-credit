# ⚡ KickStart Credit

A Rails 7.2 CRUD app modeled on a credit-building fintech product (inspired by
Kikoff's 2026 product suite). Built as a learning project to demonstrate Rails
fundamentals: models, views, endpoints, migrations, validations, service
objects, and tests.

**Not affiliated with Kikoff.** Demo data only — no real financial data.

## What it does (and what it mirrors)

| Feature | Real-world analog |
|---|---|
| **Credit accounts** with limits, balances, utilization | Kikoff's Credit Account (reported tradeline) |
| **Payments** with on-time/late tracking and history | Payment history furnished to bureaus (~35% of FICO) |
| **Disputes** with a generated FCRA dispute letter | Kikoff's AI Credit Disputes |
| **Score check-ins + goals** with a progress bar | Score tracking / Equifax Optimal Path planner |
| **Rule-based "Coach" tips** | Fynn, Kikoff's AI credit coach |
| **JSON API** (`/api/v1/credit_accounts`) | Mobile-app backend endpoints |

## Setup

Requires Ruby >= 3.1.

```bash
bundle install
bin/rails db:prepare db:seed
bin/rails server        # → http://localhost:3000
```

Or just: `bin/setup && bin/rails server`

## Tests

```bash
bin/rails test
```

Covers: utilization math, on-time-rate calculation, payment state
transitions, dispute lifecycle (submit/resolve guards, letter generation),
full CRUD request specs, and JSON API serialization + 404 handling.

## Design notes

- **Money is stored as integer cents** — never floats for currency.
- **State transitions live on the models** (`Payment#mark_paid!`,
  `Dispute#submit!`) with guard clauses, not scattered in controllers.
- **`CreditCoach` is a plain Ruby service object.** It's rule-based here;
  the interface (user in, tips out) is deliberately shaped so an LLM could
  replace the rules without touching the call site.
- **`Dispute#generate_letter` is deterministic** — the comment in the model
  marks exactly where an AI-drafted letter would slot in.
- **No JavaScript at all.** Deletes and state changes use `button_to`
  (plain HTML forms), so the app works with zero JS dependencies.

## Natural extensions

- Real auth (`has_secure_password` / Devise) — currently single demo user
- LLM-generated dispute letters + coach tips
- Background jobs (Sidekiq) for simulated bureau furnishing
- React frontend consuming the existing JSON API
