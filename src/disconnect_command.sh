NAME=${args[name]}
CONFIG_FILE="$AWS_VPN_DIR/config/$NAME.properties"

. $CONFIG_FILE

tunnelblickctl disconnect "$NAME.aws.vpn"

if ! [ -z "$DNS" ]; then
  networksetup -setdnsservers "$DNS" empty
fi
