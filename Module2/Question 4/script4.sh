echo "Question 4"
echo "--------------------------------------"
echo "Listing the information of all running process"
echo
ps aux
echo
echo "Listing the information of all running process after sorting by memory size"
echo
ps aux --sort=-%mem
echo
echo "This is the process having highest memory usage"
ps aux --sort=-%mem | sed -n '2p'
echo "The PID to kill is " 
ps aux --sort=-%mem | sed -n '2p' | awk '{print $2}'
kill $(ps aux --sort=-%mem | sed -n '2p' | awk '{print $2}')
echo "The process Killed"

