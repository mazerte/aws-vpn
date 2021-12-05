NAME="${args[name]}"
CONFIG_FILE="$AWS_VPN_DIR/config/$NAME.properties"

. $CONFIG_FILE

tunnelblickctl disconnect "$NAME.aws.vpn"

echo ""
echo "$(green_bold "Delete CloudFormation stack")"
aws cloudformation delete-stack --stack-name $NAME-aws-vpn
echo "Waiting... (it will take few minutes)"
aws cloudformation wait stack-delete-complete --stack-name $NAME-aws-vpn

echo ""
echo "$(green_bold "Delete certificat in ACM")"
aws acm delete-certificate --certificate-arn $ACM_CERTIFICAT_ARN

echo ""
echo "$(green_bold "Delete configuration")"
rm $AWS_VPN_DIR/certs/$NAME.crt
rm $AWS_VPN_DIR/certs/$NAME.key
rm $AWS_VPN_DIR/config/$NAME.properties
rm $AWS_VPN_DIR/ovpns/$NAME.aws.vpn.ovpn

echo ""
echo "$(green_bold "Delete Tunnelblick configuration")"
rm -rf $HOME/Library/Application\ Support/Tunnelblick/Configurations/$NAME.aws.vpn.tblk
tunnelblickctl quit
sleep 5
tunnelblickctl launch
