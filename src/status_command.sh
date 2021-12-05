tunnelblickctl status \
  | grep --color=never "NAME\|aws.vpn" \
  | sed "s/\.aws\.vpn/        /g" \
  | sed "s,CONNECTED,$(tput setaf 2)CONNECTED$(tput sgr0),"
