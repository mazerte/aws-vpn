# aws-vpn

`aws-vpn` is a command-line tool to easily create and manage vpn connection to your AWS VPC. It will create an AWS Client VPN and point, the required certificats and an OpenVPN configuration. It also use [Tunnelblick](https://tunnelblick.net/) to create the VPN connect between your Mac and the VPC.

### Dependencies

To use `aws-vpn` you must install:

* `awscli`: the command-line tool to interact with AWS Cloud ([install](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html))
* `Tunnelblick`: the VPN client used is the tool ([install](https://tunnelblick.net/) or use `brew install tunnelblick` thanks to `cask`)
* `tunnelblickctl`: the command-line tool interface for Tunnelblick ([install](https://github.com/benwebber/tunnelblickctl), thanks to [Ben Webber](https://github.com/benwebber))

### Installation

### Homebrew

Run these command on your terminal:

```
$ brew tap mazerte/software
$ brew install aws-vpn
```

#### Manual

Run these command on your terminal:

```
$ git clone https://github.com/mazerte/aws-vpn /tmp/aws-vpn
$ cp /tmp/aws-vpn/aws-vpn /usr/local/bin/aws-vpn
```

### Usage

```
$ aws-vpn --help
```
