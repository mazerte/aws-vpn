NAME="${args[name]}"
DNS="${args[--dns]}"
CONFIG_FILE="$AWS_VPN_DIR/config/$NAME.properties"

if ! [ -z "$DNS" ]; then
  echo "Update DNS configuration"
  sed -i '' "/^DNS/d" $CONFIG_FILE
  if ! [ "$DNS" == "false" ]; then
    echo "DNS=\"$DNS\"" >> $CONFIG_FILE
  fi
fi

. $CONFIG_FILE

echo ""
echo "$(green_bold "Update CloudFormation stack")"
aws cloudformation update-stack --stack-name $NAME-aws-vpn --template-body file://$AWS_VPN_DIR/vpn.cfn.yml --parameters ParameterKey=VpcId,ParameterValue=$VPC_ID ParameterKey=SubnetIds,ParameterValue=$SUBNET_IDS ParameterKey=CertificationArn,ParameterValue=$ACM_CERTIFICAT_ARN > /dev/null 2>/dev/null | true
echo "Waiting... (it will take few minutes)"
aws cloudformation wait stack-update-complete --stack-name $NAME-aws-vpn

echo ""
echo "$(green_bold "Configure tunnelblick")"
UNIQ=`echo $RANDOM | md5sum | head -c 12; echo;`
ENDPOINT=`aws cloudformation describe-stacks --stack-name $NAME-aws-vpn | jq -r ".Stacks[0].Outputs[] | select(.OutputKey==\"VpnEndpointUrl\") | .OutputValue"`
CERTIFICAT=`cat $AWS_VPN_DIR/certs/$NAME.crt`
KEY=`cat $AWS_VPN_DIR/certs/$NAME.key`
TEMPLATE=`cat $AWS_VPN_DIR/config.tpl.ovpn`
eval "echo \"$TEMPLATE\"" > $AWS_VPN_DIR/ovpns/$NAME.aws.vpn.ovpn
echo "You will need to enter your password"
tunnelblickctl install $AWS_VPN_DIR/ovpns/$NAME.aws.vpn.ovpn > /dev/null 2>/dev/null | true
