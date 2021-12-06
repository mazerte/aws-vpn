NAME="${args[name]}"
VPC_ID="${args[--vpc-id]}"
SUBNET_IDS="${args[--subnet-ids]}"
DNS="${args[--dns]}"

CONFIG_FILE="$AWS_VPN_DIR/config/$NAME.properties"
echo "NAME=$NAME" > $CONFIG_FILE
echo "VPC_ID=$VPC_ID" >> $CONFIG_FILE
echo "SUBNET_IDS=$SUBNET_IDS" >> $CONFIG_FILE
echo "DNS=$DNS" >> $CONFIG_FILE

echo ""
echo "$(green_bold "Create certificat")"
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout "$AWS_VPN_DIR/certs/$NAME.key" -out "$AWS_VPN_DIR/certs/$NAME.crt" -subj "/CN=$NAME.aws.vpn/O=$NAME.aws.vpn"

echo ""
echo "$(green_bold "Import certificat in ACM")"
_AWS_ACM_CERTIFICAT_ARN=`aws acm import-certificate --certificate "fileb://$AWS_VPN_DIR/certs/$NAME.crt" --private-key "fileb://$AWS_VPN_DIR/certs/$NAME.key" | jq -r ".CertificateArn"`
echo "ACM_CERTIFICAT_ARN=$_AWS_ACM_CERTIFICAT_ARN" >> $CONFIG_FILE
echo "$_AWS_ACM_CERTIFICAT_ARN"

echo ""
echo "$(green_bold "Create CloudFormation stack")"
aws cloudformation create-stack --stack-name $NAME-aws-vpn --template-body file://$AWS_VPN_DIR/vpn.cfn.yml --parameters ParameterKey=VpcId,ParameterValue=$VPC_ID ParameterKey=SubnetIds,ParameterValue=$SUBNET_IDS ParameterKey=CertificationArn,ParameterValue=$_AWS_ACM_CERTIFICAT_ARN > /dev/null
echo "Waiting... (it will take few minutes)"
aws cloudformation wait stack-create-complete --stack-name $NAME-aws-vpn

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
