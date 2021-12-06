NAME=${args[name]}
CONFIG_FILE="$AWS_VPN_DIR/config/$NAME.properties"

. $CONFIG_FILE

tunnelblickctl connect "$NAME.aws.vpn"

if ! [ -z "$DNS" ]; then
  CIDR=`aws ec2 describe-vpcs --vpc-ids $VPC_ID | jq -r ".Vpcs[0].CidrBlock"`
  DNS_SERVER=`echo "$CIDR" | sed -E "s/0\/[0-9]{1,2}/2/g"`
  networksetup -setdnsservers "$DNS" $DNS_SERVER
fi
