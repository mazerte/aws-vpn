## Code here runs inside the initialize() function
## Use it for anything that you need to run before any other function, like
## setting environment vairables:
## CONFIG_FILE=settings.ini
##
## Feel free to empty (but not delete) this file.
AWS_VPN_DIR=$HOME/.aws-vpn

function _init_folders() {
  mkdir -pv "$AWS_VPN_DIR"
  mkdir -pv "$AWS_VPN_DIR/certs"
  mkdir -pv "$AWS_VPN_DIR/ovpns"
  mkdir -pv "$AWS_VPN_DIR/config"

  if [ $AWS_VPN_DEV == 1 ]; then
    echo "INFO: development mode activated"
    cp vpn.cfn.yml $AWS_VPN_DIR/vpn.cfn.yml
    cp config.tpl.ovpn $AWS_VPN_DIR/config.tpl.ovpn
  else

  fi
}

# Init dot folders
if ! [[ -d $AWS_VPN_DIR ]]; then
  _init_folders
fi

# Check tunnelblickctl dependency
if ! command -v tunnelblickctl &> /dev/null; then
  echo ""
  echo "$(red_bold "You must install first \"tunnelblickctl\"!")"
  echo "$(red "You can run these commands:")"
  echo "$(red " $ brew tap benwebber/tunnelblickctl")"
  echo "$(red " $ brew install tunnelblickctl")"
  echo ""
  echo "$(red "More information at https://github.com/benwebber/tunnelblickctl")"
  exit 1
fi

# Check aws dependency
if ! command -v aws &> /dev/null; then
  echo ""
  echo "$(red_bold "You must install first \"awscli\"!")"
  echo "$(red "You can run this command:")"
  echo "$(red " $ brew install awscli")"
  echo ""
  echo "$(red "More information at https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html")"
  exit 1
fi

# Check if tunnelblick is running
if ! tunnelblickctl list > /dev/null 2>/dev/null; then
  echo "Start tunnelblick ..."
  tunnelblickctl launch
  echo ""
fi
