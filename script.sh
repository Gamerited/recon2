#!/bin/bash
banner(){
    echo " ____                        _____           _ "
    echo "|  _ \ ___  ___ ___  _ __   |_   _|__   ___ | |"
    echo "| |_) / _ \/ __/ _ \| '_ \    | |/ _ \ / _ \| |"
    echo "|  _ <  __/ (_| (_) | | | |   | | (_) | (_) | |"
    echo "|_| \_\___|\___\___/|_| |_|   |_|\___/ \___/|_|"
    echo "@gamerited"
    echo "+------------------------------------------+"
    printf "| %-40s |\n" "`date`"
    echo "| STARTED AT                               |"
    printf "|`tput bold` %-40s `tput sgr0`|\n" "$@"
     echo "+------------------------------------------+"
}
samaya(){
    echo "+------------------------------------------+"
    printf "| %-40s |\n" "`date`"
    echo "| Completed at                             |"
    printf "|`tput bold` %-40s `tput sgr0`|\n" "$@"
    echo "+------------------------------------------+"
}
error () {
    echo "  ___ _ __ _ __ ___  _ __ "
    echo " / _ \ '__| '__/ _ \| '__|"
    echo "|  __/ |  | | | (_) | | "
    echo " \___|_|  |_|  \___/|_|   "
    

}
complete() {
    echo "  ____ ___  __  __ ____  _     _____ _____ _____ ____ "
    echo " / ___/ _ \|  \/  |  _ \| |   | ____|_   _| ____|  _ \ "
    echo "| |  | | | | |\/| | |_) | |   |  _|   | | |  _| | | | |"
    echo "| |__| |_| | |  | |  __/| |___| |___  | | | |___| |_| |"
    echo " \____\___/|_|  |_|_|   |_____|_____| |_| |_____|____/ "
}
jyudo(){
    echo "    _    _     _____     _______ "
    echo "   / \  | |   |_ _\ \   / / ____|"
    echo "  / _ \ | |    | | \ \ / /|  _|  "
    echo " / ___ \| |___ | |  \ V / | |___ "
    echo "/_/   \_\_____|___|  \_/  |_____|"
}
banner
echo "Resolving target"
if [ "$1" == "" ]
then
error
echo ""
echo "NO TARGET FOUND !!!!"
echo "Domain is missing"
echo ""
echo "The Syntax is ./script.sh domain.com "
exit
fi
echo "Target found *.$1"
echo "Starting Finddomain to find subdomain of $1"
echo "please wait"
findomain -t $1 -o 
complete
samaya
echo "Subdomain finding has completed"
echo "Checking for alive domain.."
jyudo
echo "Starting httprobe to test the subdomains"
cat $1.txt | httprobe | tee hosts
complete
echo "All the alive domain test has been completed"
samaya
echo "Now fuzzing for directories" 
while read dom; do
ffuf -c -w wordlist -u $dom/FUZZ -o dirs.json
cat a.json >> results.json
done < hosts
complete
echo "Fuzzing for directory has been completed please check dirs.json"
samaya
echo "Editing the file in order to give input for namp"
cat hosts | cut -d/ -f3 | tee lists
complete
echo "Now starting namp scan with heartbleed vulns"
nmap -p- --script ssl-heartbleed -oA nmap -iL lists 
complete
echo "All done please check the files in the directory for output"
echo "Happy hunting"
samaya


