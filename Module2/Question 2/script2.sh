echo "Question 2"
echo "-----------------------------------------"
echo "Before Replacing....."
cat config.txt
echo
sed 's/localhost/127.0.0.1/g' config.txt > updated_config.txt
echo "After Replacing......"
cat updated_config.txt
echo "------------------------------------------"
