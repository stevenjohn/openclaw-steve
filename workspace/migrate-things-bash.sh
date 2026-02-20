#!/bin/bash
set -euo pipefail

csv_file=&quot;/home/steve/.openclaw/workspace/things-import.csv&quot;
project=&quot;Things Migration&quot;

imported=0

tail -n +2 &quot;$csv_file&quot; | while IFS= read -r line; do
  title=$(echo &quot;$line&quot; | awk -F, '{gsub(/^ /, &quot;&quot;, $2); gsub(/ $/, &quot;&quot;, $2); print $2}')
  if [ -z &quot;$title&quot; ]; then continue; fi

  proj=$(echo &quot;$line&quot; | awk -F, '{gsub(/^ /, &quot;&quot;, $3); gsub(/ $/, &quot;&quot;, $3); print $3}')
  dead=$(echo &quot;$line&quot; | awk -F, '{gsub(/^ /, &quot;&quot;, $7); gsub(/ $/, &quot;&quot;, $7); print $7}')

  # Notes: from field 9 to end
  notes_pos=$(echo &quot;$line&quot; | awk -F, '{print index($0,$9)}')
  notes=&quot;${line:$notes_pos}&quot;
  notes=$(echo &quot;$notes&quot; | sed 's/^,//; s/,$//')

  # Labels
  label_str=&quot;&quot;
  if [ -n &quot;$proj&quot; ] &amp;&amp; [ &quot;$proj&quot; != &quot;None&quot; ]; then
    label_str=&quot;project-${proj:0:12}&quot;
  fi
  label_str=$(echo &quot;$label_str&quot; | sed 's/,$//')

  # Add task
  cmd=(todoist add &quot;$title&quot;)
  cmd+=(--project &quot;$project&quot; --order top)
  if [ -n &quot;$label_str&quot; ]; then
    cmd+=(--label &quot;$label_str&quot;)
  fi
  if [ -n &quot;$dead&quot; ] &amp;&amp; [ &quot;$dead&quot; != &quot;None&quot; ]; then
    cmd+=(--due &quot;$dead&quot;)
  fi

  out=$( &quot;${cmd[@]}&quot; 2&gt;&amp;1 )
  if [ $? -ne 0 ]; then
    echo &quot;Error adding '$title': $out&quot;
    continue
  fi

  # Parse ID
  task_id=$(echo &quot;$out&quot; | grep -oP '#\K\d+')
  if [ -z &quot;$task_id&quot; ]; then
    echo &quot;No ID for '$title': $out&quot;
    continue
  fi

  # Add notes as comment
  if [ -n &quot;$notes&quot; ] &amp;&amp; [ &quot;$notes&quot; != &quot;None&quot; ]; then
    todoist comment &quot;$task_id&quot; &quot;$notes&quot; &gt;/dev/null 2&gt;&amp;1
  fi

  echo &quot;✓ $((++imported)). '$title' #$task_id$([[ -n &quot;$dead&quot; &amp;&amp; $dead != 'None' ]] &amp;&amp; echo &quot; [due $dead]&quot; )&quot;
done

echo &quot;\nMigration complete: $imported tasks imported to '$project'.&quot;
echo &quot;Run: todoist tasks -p '$project' --all&quot;