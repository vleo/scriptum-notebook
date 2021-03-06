alias _='sudo'
alias sudp='sudo'
alias sduo='sudo'
alias duso='sudo'
if [[ $USER != root ]]; then
  alias dmesg='sudo dmesg -H'
  alias service='sudo service'
  alias systemctl='sudo systemctl'
  alias s='sudo systemctl'
  alias j='sudo journalctl'
  alias je='sudo journalctl -e'
  alias journalctl='sudo journalctl'
  alias restart='sudo systemctl restart'
  alias start='sudo systemctl start'
  alias status='sudo systemctl status'
  alias stop='sudo systemctl stop'
  alias enable='sudo systemctl enable'
  alias disable='sudo systemctl disable'
  alias iotop="sudo iotop"
  alias mount='sudo mount'
  alias yum='sudo yum'
  alias dnf='sudo dnf'
fi
