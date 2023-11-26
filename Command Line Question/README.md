# Command Line Question

* `CommandLine.sh`: This script merges extracted data into file named merged_courses.tsv and uses Linux commands to answer the following questions:
    - Which country offers the most Master's Degrees? Which city?
    - How many colleges offer Part-Time education?
    - Print the percentage of courses in Engineering (the word "Engineer" is contained in the course's name).

* `Output.png`: This image contains the screenshot of an output produced by the script

---

## Script Review

### Merging files

```bash
ulimit -n 6100
cd ../files_tsv
```
Sets the maximum number of file descriptors that a process can have to 6100, since we have 6000 files and hanges the current working directory to `../files_tsv`.

```bash
cat course1.tsv > merged_courses.tsv
tail -q -n +2 course*.tsv >> merged_courses.tsv
```
Concatenates the content of the file `course1.tsv` and writes it to a new file called `merged_courses.tsv` and appends all `.tsv` files starting with 'course'. `-q` is needed to disable headers with file names and `-n +2` to start from the second line of each file.

---

### Country and City with the Most Master's Degrees

```bash
country_most_occurrences=$(awk -F'\t' '{print $11}' all_courses.tsv | sort | uniq -c | sort -nr | head -n 1)
echo "Country with the most occurrences:"
echo "$country_most_occurrences"
echo
```
```bash
city_most_masters=$(awk -F'\t' 'tolower($8) ~ /msc/ {print $10}' all_courses.tsv | sort | uniq -c | sort -nr | head -n 1)
echo "City with the most Master's Degrees:"
echo "$city_most_masters"
echo
```
We use `awk` with `-F'\t'` setting field separator to `Tab` and print content of 10th and 11th column respectively. The output is piped to `sort` sorting lines alphanumerically, which then passed to `| uniq -c` counting unique occurrences. `| sort -nr` sorts again in numerical descending order and `head -n 1` extracts the top result.

---

### Number of Colleges Offering Part-Time Education

```bash
part_time_colleges=$(grep -i 'part-time' all_courses.tsv | cut -f 2 | sort -u | wc -l)
echo "Number of colleges offering Part-Time education: $part_time_colleges"
echo
```
Searches for lines containing "part-time" in the TSV file. `cut -f 2` extracts second field, which is then sorted removing duplicates and counts number of lines.

---

### Percentage of Courses in Engineering

```bash
engineering_percentage=$(awk -F'\t' '{if (tolower($2) ~ /engineer/) count++} END {print (count/NR)*100 "%"}' all_courses.tsv)
echo "Percentage of courses in Engineering: $engineering_percentage"
echo
```
Counts the occurrences where the content of the second column (universityName) in lowercase contains the substring "engineer" and counts the percentage of occurrences afterwards.
