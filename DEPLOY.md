# Deploying KickStart Credit

## Pre-flight (local)

    bin/rails test                          # 17 runs, 0 failures
    bin/rails server                        # smoke-test in browser
    curl localhost:3000/api/v1/credit_accounts   # JSON with utilization

Optional full production rehearsal (needs Docker Desktop):

    docker build -t kickstart .
    docker run -p 3000:3000 -e SECRET_KEY_BASE=$(openssl rand -hex 64) kickstart

## Deploy to Render (recommended, free)

1. Push the repo to GitHub (commit Gemfile.lock — it's created by
   `bundle install` and deploys need it for reproducible builds).
2. render.com → New → Blueprint → pick the repo. `render.yaml` does the
   rest, including generating SECRET_KEY_BASE.
3. First build takes a few minutes; you get
   `https://kickstart-credit-xxxx.onrender.com`.

### Known trade-offs on the free tier
- **SQLite data is ephemeral**: the disk resets on every deploy/restart,
  so the app re-seeds fresh demo data each boot. Fine for a portfolio
  demo. For real persistence: attach a paid persistent disk, or switch
  `database.yml`/Gemfile to Postgres (Render provides a free instance).
- Free services sleep after idle; first request takes ~30s to wake.

## Alternative: Fly.io
`fly launch` detects the Dockerfile; add a volume for persistent SQLite:
`fly volumes create data` and point database.yml at `/data/production.sqlite3`.
