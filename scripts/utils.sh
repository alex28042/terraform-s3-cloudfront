#!/usr/bin/env bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
DIM='\033[2m'
NC='\033[0m'

info()    { echo -e "  ${BLUE}💡${NC} $1"; }
success() { echo -e "  ${GREEN}✅${NC} $1"; }
warn()    { echo -e "  ${YELLOW}⚠️${NC}  $1"; }
error()   { echo -e "  ${RED}❌${NC} $1"; }

step() {
  echo ""
  echo -e "  ${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "  ${BOLD}${CYAN}  $1${NC}"
  echo -e "  ${MAGENTA}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo ""
}

print_banner() {
  clear
  echo ""
  echo -e "${CYAN}${BOLD}"
  echo "     ╔═══════════════════════════════════════════════════════╗"
  echo "     ║                                                       ║"
  echo "     ║   🪣  S3  +  🌐  CloudFront CDN                      ║"
  echo "     ║                                                       ║"
  echo "     ║   ⚡ One-click deploy to AWS with Terraform          ║"
  echo "     ║                                                       ║"
  echo "     ╚═══════════════════════════════════════════════════════╝"
  echo -e "${NC}"
  echo -e "     ${DIM}Secure storage + blazing fast CDN for your assets${NC}"
  echo ""
}

spinner() {
  local pid=$1
  local msg="${2:-Working...}"
  local frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
  local i=0

  while kill -0 "$pid" 2>/dev/null; do
    echo -en "\r  ${CYAN}${frames[$i]}${NC} ${msg}"
    i=$(( (i + 1) % ${#frames[@]} ))
    sleep 0.1
  done
  echo -en "\r\033[K"
}

prompt() {
  local var_name="$1" message="$2" default="${3:-}"
  if [[ -n "$default" ]]; then
    echo -en "  ${BOLD}${message}${NC} ${DIM}(${default})${NC} ${CYAN}▸${NC} "
    read -r input
    eval "$var_name=\"${input:-$default}\""
  else
    echo -en "  ${BOLD}${message}${NC} ${CYAN}▸${NC} "
    read -r input
    while [[ -z "$input" ]]; do
      echo -en "  ${RED}Can't be empty!${NC} ${BOLD}${message}${NC} ${CYAN}▸${NC} "
      read -r input
    done
    eval "$var_name=\"$input\""
  fi
}

prompt_secret() {
  local var_name="$1" message="$2"
  echo -en "  ${BOLD}${message}${NC} ${CYAN}▸${NC} "
  read -rs input
  echo " 🔒"
  while [[ -z "$input" ]]; do
    echo -en "  ${RED}Can't be empty!${NC} ${BOLD}${message}${NC} ${CYAN}▸${NC} "
    read -rs input
    echo " 🔒"
  done
  eval "$var_name=\"$input\""
}

confirm() {
  local message="$1"
  echo -en "\n  ${BOLD}${message}${NC} ${DIM}(Y/n)${NC} ${CYAN}▸${NC} "
  read -r answer
  [[ -z "$answer" || "$answer" =~ ^[yY]$ ]]
}

print_divider() {
  echo -e "  ${DIM}┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄${NC}"
}
