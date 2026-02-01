echo "Question 5"
echo "--------------------------------------------"
echo "The gateways available are.."
netstat -rn | grep "^0.0.0.0" | awk '{print $2}' | sort
echo "-------------------------------------------"
