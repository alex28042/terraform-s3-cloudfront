#!/usr/bin/env bash

check_dependencies() {
  step "🔍  1/5 — Checking dependencies"

  local missing=0

  if command -v terraform &>/dev/null; then
    success "Terraform found $(terraform version -json 2>/dev/null | grep -o '"[0-9][^"]*"' | head -1 | tr -d '"' || echo "")"
  else
    error "Terraform is not installed"
    echo ""
    echo -e "  ${BOLD}Install it:${NC}"
    echo -e "    ${CYAN}brew install terraform${NC}        ${DIM}(macOS)${NC}"
    echo -e "    ${CYAN}sudo apt install terraform${NC}    ${DIM}(Linux)${NC}"
    echo -e "    ${CYAN}choco install terraform${NC}       ${DIM}(Windows)${NC}"
    missing=1
  fi

  if command -v aws &>/dev/null; then
    success "AWS CLI found $(aws --version 2>&1 | awk '{print $1}')"
  else
    warn "AWS CLI not installed ${DIM}(optional, used for credential validation)${NC}"
  fi

  if [[ $missing -eq 1 ]]; then
    echo ""
    error "Install the missing tools and come back! 👋"
    exit 1
  fi

  echo ""
  echo -e "  ${GREEN}All good, let's go! 🚀${NC}"
}
