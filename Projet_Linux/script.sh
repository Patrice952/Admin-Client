#!/bin/bash


html_file="index.html"
echo "<p>Date et heure actuelles : $(date)</p>" >> "$html_file"
cpu_usage=$(top -bn1 | grep "%Cpu(s)" | sed "s/.*,\s*\([0-9]*\.[0-9]*\)%* id.*/\1/")
memory_usage=$(free -m | awk 'NR==2{print $3}')

echo "Page HTML générée avec succès. ."

