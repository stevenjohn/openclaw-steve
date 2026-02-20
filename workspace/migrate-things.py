#!/usr/bin/env python3
import csv
import subprocess
import json
import re
import sys

csv_file = '/home/steve/.openclaw/workspace/things-import.csv'
project_name = 'Things Migration'

# Get project ID
result = subprocess.run(['todoist', 'projects', '--json'], capture_output=True, text=True)
if result.returncode != 0:
    print('Error getting projects:', result.stderr)
    sys.exit(1)
projects = json.loads(result.stdout)
project_map = {p['name']: p['id'] for p in projects}
if project_name not in project_map:
    print(f'Project {project_name} not found')
    sys.exit(1)
project_id = project_map[project_name]
print(f'Using project "{project_name}" (ID: {project_id})')

imported = 0
with open(csv_file, 'r') as f:
    reader = csv.DictReader(f)
    for row_num, row in enumerate(reader, start=2):
        title = row.get('title', '').strip()
        if not title:
            continue

        proj = row.get('project', '').strip()
        area = row.get('area', '').strip()
        tags = row.get('tags', '').strip()
        deadline = row.get('deadline', '').strip()
        notes = row.get('notes', '').strip()

        # Labels
        labels = []
        if proj:
            labels.append(f'project-{proj[:12]}')
        if area:
            labels.append(f'area-{area[:12]}')
        if tags:
            labels.extend([t.strip() for t in tags.split(',')])
        label_str = ','.join(set(labels))  # unique

        # Command
        cmd = ['todoist', 'add', title]
        cmd += ['--project', project_name]
        if label_str:
            cmd += ['--label', label_str]
        if deadline and deadline != 'None':
            cmd += ['--due', deadline]
        cmd += ['--order', 'top']

        result = subprocess.run(cmd, capture_output=True, text=True)
        if result.returncode != 0:
            print(f'Error row {row_num} "{title}": {result.stderr.strip()}')
            continue

        # Parse task ID
        task_match = re.search(r'Added task #(\d+)', result.stdout)
        if not task_match:
            print(f'No ID for row {row_num} "{title}": {result.stdout.strip()}')
            continue
        task_id = task_match.group(1)

        # Add notes as comment
        if notes:
            comment_cmd = ['todoist', 'comment', task_id, notes]
            subprocess.run(comment_cmd, capture_output=True)

        print(f'✓ {imported+1:3d}. "{title}" #{task_id} {"[due "+deadline+"]" if deadline and deadline!="None" else ""} {label_str[:30] or ""}')
        imported += 1

print(f'\nMigration complete: {imported} tasks imported to "{project_name}".')
print('Next: todoist tasks -p "Things Migration"')