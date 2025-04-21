# 📊 Cloud project Deploy into RAILWAY PAAS service

Deploy your devops project's app to Railway PAAS with continuously delivered using **GitHub Actions**.

---

## 🎯 Objective

Create a basic full-stack app:



## 🛠️ Tech Stack

- **Backend**: Node.js, python or other programming language 
- **Database**: Hosted on Railway if possible (PostgreSQL for example) or mongo Atlas if you use mongoDB
- **CI/CD**: GitHub Actions
- **Deployment Platform**: [Railway](https://railway.app)

---

## 🚀 Deployment

### Railway Setup
1. Create a free account at [railway.app](https://railway.app).
2. Create a new project.
3. Add a PostgreSQL plugin (if you use postgres) to the project.
4. Link this GitHub repository to the Railway project.
5. Set necessary environment variables (if any).
6. Deploy directly via Railway dashboard or GitHub Actions.

---

### GitHub Actions Workflow

You can use the following github action workflow.

`.github/workflows/deploy.yml`:

```yaml
name: Deploy to Railway

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Set up Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'

      - name: Install dependencies
        run: npm install

      - name: Run tests (optional)
        run: npm test

      - name: Deploy to Railway
        uses: railwayapp/cli-action@v1
        with:
          railwayToken: ${{ secrets.RAILWAY_TOKEN }}
```
Submit your job with this[ Gform: ](https://forms.gle/gG6LZ2xhuCKM3xcN8)
