#!/bin/bash

echo "🔄 Poolhouse Dashboard Update Script"
echo "===================================="
echo ""

# Check if raw_data.csv exists
if [ ! -f "raw_data.csv" ]; then
    echo "❌ Error: raw_data.csv not found"
    echo ""
    echo "Please ask Goose to run:"
    echo '  "Run the Poolhouse voids query and save to /Users/ambru/Documents/poolhouse-final/raw_data.csv"'
    echo ""
    exit 1
fi

echo "✅ Found raw_data.csv"
echo "📊 Converting CSV to JSON and updating HTML..."
echo ""

# Run the Python conversion script
python3 << 'EOF'
import csv
import json
from datetime import datetime
from collections import defaultdict

# Read the CSV
data = []
with open('raw_data.csv', 'r') as f:
    reader = csv.DictReader(f)
    for row in reader:
        try:
            reason_obj = json.loads(row['void_reason'])
            reason = reason_obj.get('reason_detail', 'Unknown')
        except:
            reason = row['void_reason'] if row['void_reason'] else 'Unknown'
        
        data.append({
            'order_id': row['order_id'],
            'order_date': row['order_date'],
            'order_time': row['order_time'],
            'order_state': row['order_state'],
            'void_timestamp': row['void_timestamp'],
            'void_reason': reason,
            'voided_by_employee_id': row['voided_by_employee_id'],
            'void_scope': row['void_scope'],
            'voided_item_name': row['voided_item_name'],
            'voided_quantity': float(row['voided_quantity']) if row['voided_quantity'] else 0,
            'voided_amount_dollars': float(row['voided_amount_dollars']) if row['voided_amount_dollars'] else 0
        })

# Calculate summary stats
total_voids = len(data)
total_amount = sum(v['voided_amount_dollars'] for v in data)
avg_amount = total_amount / total_voids if total_voids > 0 else 0

dates = sorted(set(v['order_date'] for v in data))
date_range = f"{dates[0]} to {dates[-1]}" if dates else "No data"

# Calculate daily trends
daily = defaultdict(lambda: {'count': 0, 'amount': 0})
for v in data:
    daily[v['order_date']]['count'] += 1
    daily[v['order_date']]['amount'] += v['voided_amount_dollars']

daily_trends = [
    {'date': date, 'count': stats['count'], 'amount': stats['amount']}
    for date, stats in sorted(daily.items())
]

# Calculate top items
items = defaultdict(lambda: {'count': 0, 'amount': 0})
for v in data:
    name = v['voided_item_name'] or 'Unknown'
    items[name]['count'] += 1
    items[name]['amount'] += v['voided_amount_dollars']

top_items = sorted(
    [{'name': name, **stats} for name, stats in items.items()],
    key=lambda x: x['count'],
    reverse=True
)[:10]

# Calculate void reasons
reasons = defaultdict(int)
for v in data:
    reasons[v['void_reason'] or 'Unknown'] += 1

void_reasons = sorted(
    [{'reason': reason, 'count': count} for reason, count in reasons.items()],
    key=lambda x: x['count'],
    reverse=True
)

# Calculate employee activity
employees = defaultdict(lambda: {'count': 0, 'amount': 0})
for v in data:
    emp_id = v['voided_by_employee_id'] or 'Unknown'
    employees[emp_id]['count'] += 1
    employees[emp_id]['amount'] += v['voided_amount_dollars']

employee_activity = sorted(
    [{'id': emp_id, **stats} for emp_id, stats in employees.items()],
    key=lambda x: x['count'],
    reverse=True
)[:10]

# Create dashboard data
dashboard_data = {
    'summary': {
        'total_voids': total_voids,
        'total_amount': total_amount,
        'avg_amount': avg_amount,
        'date_range': date_range,
        'last_updated': datetime.now().isoformat()
    },
    'daily_trends': daily_trends,
    'top_items': top_items,
    'void_reasons': void_reasons,
    'employee_activity': employee_activity,
    'all_voids': data
}

# Read the HTML template
with open('public/index.html', 'r') as f:
    html = f.read()

# Replace the data
start_marker = 'const dashboardData = '
end_marker = ';\n        \n        // Store original data'

start_idx = html.find(start_marker)
end_idx = html.find(end_marker, start_idx)

if start_idx != -1 and end_idx != -1:
    new_html = (
        html[:start_idx + len(start_marker)] +
        json.dumps(dashboard_data, indent=12) +
        html[end_idx:]
    )
    
    with open('public/index.html', 'w') as f:
        f.write(new_html)
    
    print(f"✅ Dashboard updated successfully!")
    print(f"   Total voids: {total_voids}")
    print(f"   Total amount: £{total_amount:,.2f}")
    print(f"   Date range: {date_range}")
    exit(0)
else:
    print("❌ Error: Could not find data markers in HTML")
    exit(1)
EOF

if [ $? -eq 0 ]; then
    echo ""
    echo "🎨 Opening dashboard for preview..."
    open public/index.html
    echo ""
    echo "📤 Ready to deploy?"
    echo ""
    read -p "Push to GitHub and auto-deploy? (y/n): " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "📦 Committing changes..."
        git add public/index.html
        git commit -m "Update dashboard data - $(date +%Y-%m-%d)"
        
        echo "🚀 Pushing to GitHub..."
        git push
        
        if [ $? -eq 0 ]; then
            echo ""
            echo "✅ SUCCESS! Dashboard deployed!"
            echo "   Vercel will auto-deploy in ~30 seconds"
            echo "   Check your Vercel dashboard for the live URL"
        else
            echo ""
            echo "❌ Git push failed. Check your GitHub connection."
        fi
    else
        echo ""
        echo "⏸️  Skipped deployment. Run 'git push' when ready."
    fi
else
    echo ""
    echo "❌ Update failed. Check the error above."
fi
