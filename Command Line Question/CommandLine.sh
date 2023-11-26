ulimit -n 6100
cd ../files_tsv
cat course1.tsv > merged_courses.tsv
tail -q -n +2 course*.tsv >> merged_courses.tsv

# Country with the most occurrences
echo
country_most_occurrences=$(awk -F'\t' '{print $11}' merged_courses.tsv | sort | uniq -c | sort -nr | head -n 1)
echo "Country with the most occurrences:"
echo "$country_most_occurrences"
echo

# City with the most Master's Degrees
city_most_masters=$(awk -F'\t' 'tolower($8) ~ /msc/ {print $10}' merged_courses.tsv | sort | uniq -c | sort -nr | head -n 1)
echo "City with the most Master's Degrees:"
echo "$city_most_masters"
echo

# Number of colleges offering Part-Time education
part_time_colleges=$(grep -i 'part-time' merged_courses.tsv | cut -f 2 | sort -u | wc -l)
echo "Number of colleges offering Part-Time education: $part_time_colleges"
echo

# Percentage of courses in Engineering
engineering_percentage=$(awk -F'\t' '{if (tolower($2) ~ /engineer/) count++} END {print (count/NR)*100 "%"}' merged_courses.tsv)
echo "Percentage of courses in Engineering: $engineering_percentage"
echo
