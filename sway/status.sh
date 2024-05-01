# Produces "21 days", for example
uptime_formatted=$(uptime | cut -d ',' -f1 | cut -d ' ' -f7)

# The abbreviated weekday (e.g., "Sat"), followed by the ISO-formatted date
# like 2018-10-06 and the time (e.g., 14:01)
date_formatted=$(date "+%a %F %H:%M")

# Get the Linux version but remove the "-1-ARCH" part
linux_version=$(uname -r | cut -d '-' -f1)

# Returns the battery status: "Full", "Discharging", or "Charging".
battery_status=$(cat /sys/class/power_supply/BAT0/capacity)%

ip_local=$(ip -4 addr show wlp0s20f3 | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | awk '{print $0}')
ip_pub=$(curl ifconfig.me)
hostn=$(hostname -s)
usrname=$(whoami)

network_name=$(nmcli -t -f active,ssid dev wifi | egrep '^yes' | cut -d\' -f2 | cut -d ':' -f2)

# Emojis and characters for the status bar
# 💎 💻 💡 🔌 ⚡ 📁 \|
echo "DATE: "$date_formatted"    IP:" $ip_local@$ip_pub on $network_name"    HOST:" $usrname@$hostn "    UP:" $uptime_formatted"    " $linux_version"     " $battery_status"    "
