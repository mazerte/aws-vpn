tunnelblickctl list \
  | grep --color=never "aws.vpn" \
  | sed s/\.aws\.vpn//g

