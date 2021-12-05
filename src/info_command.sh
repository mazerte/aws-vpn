NAME="${args[name]}"
CONFIG_FILE="$AWS_VPN_DIR/config/$NAME.properties"

. $CONFIG_FILE

STATUS_LINE=`tunnelblickctl status | grep --color=never "$NAME.aws.vpn"`
if [[ "$STATUS_LINE" =~ ^.*\.aws\.vpn[[:space:]]*([A-Z]*) ]]; then
  STATUS="${BASH_REMATCH[1]}"
fi

echo "                     $(bold "Name:") $NAME"
echo "                   $(bold "Status:") $STATUS"
echo "                   $(bold "VPC Id:") $VPC_ID"
echo "               $(bold "Subnet Ids:") $SUBNET_IDS"
echo "   $(bold "Tunnelblick connection:") $NAME.aws.vpn"
echo "       $(bold "ACM Certificat ARN:") $ACM_CERTIFICAT_ARN"
echo "               $(bold "Certificat:") $AWS_VPN_DIR/certs/$NAME.crt"
echo "              $(bold "Private key:") $AWS_VPN_DIR/certs/$NAME.key"
echo "      $(bold "OpenVPN config file:") $AWS_VPN_DIR/ovpns/$NAME.aws.vpn.ovpn"
echo "$(bold "CloudFormation stack name:") $NAME-aws-vpn"
