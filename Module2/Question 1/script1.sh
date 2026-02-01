echo "Question 1"
echo "-------------------------------------"
ls -lb /var/log | awk '{if ($5 > 1000000) print $0}' > output.txt
cat output.txt
echo "-------------------------------------"
