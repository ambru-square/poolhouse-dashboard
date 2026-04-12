# Deploy Poolhouse Dashboard to Vercel

The Vercel CLI is having issues with file scanning. Here's how to deploy via the web interface instead:

## Option 1: Vercel Web Interface (Recommended)

1. **Go to Vercel Dashboard:**
   https://vercel.com/new

2. **Import Git Repository** OR **Deploy without Git:**
   - Click "Add New Project"
   - Select "Continue with GitHub" or "Deploy without Git"

3. **If using "Deploy without Git":**
   - Drag and drop ONLY the `public` folder
   - Or upload just the `index.html` file

4. **Configure:**
   - Project Name: `poolhouse-voids-dashboard`
   - Framework Preset: Other
   - Root Directory: `./` (or leave blank)
   - Build Command: (leave blank)
   - Output Directory: `public` (or `.` if you uploaded just index.html)

5. **Deploy!**
   - Click "Deploy"
   - Wait ~30 seconds
   - Your dashboard will be live!

## Option 2: Netlify (Alternative)

Netlify is simpler for static HTML:

1. **Go to:** https://app.netlify.com/drop

2. **Drag and drop** the `public` folder

3. **Done!** Your site is live immediately

## Option 3: GitHub Pages

1. Create a new GitHub repository
2. Upload `public/index.html` as `index.html` in the root
3. Go to Settings → Pages
4. Select "Deploy from main branch"
5. Your site will be at: `https://yourusername.github.io/repo-name`

## Option 4: View Locally

The dashboard is already working locally! Just open:
```
/Users/ambru/Documents/poolhouse-final/public/index.html
```

In your browser (should have opened automatically).

## Files Included

- `public/index.html` - Complete dashboard with embedded data (486 records)
- All data, charts, and styling are self-contained in this single file
- No dependencies, no build process needed

## What's in the Dashboard

✅ 486 void records from April 2-11, 2026  
✅ $15,701.40 total voided amount  
✅ Daily trends chart  
✅ Top voided items table  
✅ Void reasons pie chart  
✅ Employee activity bar chart  

## Troubleshooting Vercel CLI

The CLI is uploading too many files from parent directories. The web interface avoids this issue by letting you upload only the specific files needed.
