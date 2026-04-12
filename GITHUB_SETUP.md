# 🚀 GitHub + Vercel Auto-Deploy Setup

## Step 1: Create GitHub Repository (2 minutes)

1. Go to: https://github.com/new
2. Fill in:
   - Repository name: `poolhouse-dashboard`
   - Description: "Poolhouse Voided Orders Dashboard"
   - Visibility: Public (or Private if you prefer)
3. DO NOT initialize with README, .gitignore, or license
4. Click "Create repository"

## Step 2: Push Your Code to GitHub (1 minute)

After creating the repo, GitHub will show you commands. Run these:

```bash
cd /Users/ambru/Documents/poolhouse-final
git remote add origin https://github.com/YOUR_USERNAME/poolhouse-dashboard.git
git branch -M main
git push -u origin main
```

Replace YOUR_USERNAME with your actual GitHub username.

## Step 3: Connect Vercel to GitHub (2 minutes)

1. Go to: https://vercel.com/new
2. Click "Import Git Repository"
3. Find and select "poolhouse-dashboard"
4. Click "Import"
5. Configure:
   - Framework Preset: Other
   - Root Directory: ./
   - Build Command: (leave empty)
   - Output Directory: public
6. Click "Deploy"

Done! Your dashboard will be live in 30 seconds.

---

## 🔄 Daily Update Workflow (After Setup)

```bash
cd /Users/ambru/Documents/poolhouse-final

# 1. Ask Goose: "Run the Poolhouse voids query and save to raw_data.csv"

# 2. Convert and update (run the Python script from DEPLOY_INSTRUCTIONS.md)

# 3. Push to GitHub (auto-deploys!)
git add public/index.html
git commit -m "Update data"
git push
```

Wait 30 seconds - your dashboard is updated!

---

## 📝 What You'll Get

- GitHub Repo: https://github.com/YOUR_USERNAME/poolhouse-dashboard
- Live Dashboard: https://poolhouse-dashboard.vercel.app
- Auto-deploy: Every git push updates the live site in 30 seconds

---

## Next Steps

1. Follow Step 1 above to create GitHub repo
2. Come back and tell me your GitHub username
3. I'll help you push the code
4. Then we'll connect Vercel
