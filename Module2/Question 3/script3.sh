echo "Question 3"
echo "-----------------------------------------"
echo
echo "log.txt"
cat log.txt
echo
echo "filtered_log.txt"
grep "ERROR" log.txt | grep -v "DEBUG"  > filtered_log.txt
cat filtered_log.txt
echo "-----------------------------------------"
