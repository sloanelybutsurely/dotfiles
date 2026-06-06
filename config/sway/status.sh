date_str=$(date +'%a, %b %d, %Y')
time_str=$(date +'%I:%M %p')
bat0_str=$(cat /sys/class/power_supply/BAT0/capacity)
bat1_str=$(cat /sys/class/power_supply/BAT1/capacity)

echo "$date_str | $time_str | $bat0_str% $bat1_str%"
