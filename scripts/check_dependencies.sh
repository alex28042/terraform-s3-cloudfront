#!/usr/bin/env bash

MIN_TF_VERSION="1.10.0"

version_gte() {
  printf '%s\n%s' "$1" "$2" | sort -V | head -n1 | grep -qx "$2"
}

check_dependencies() {
  step "🔍  1/5 — Checking dependencies"

  local missing=0

  if command -v terraform &>/dev/null; then
    local tf_version
    tf_version=$(terraform version -json 2>/dev/null | grep -o '"[0-9][^"]*"' | head -1 | tr -d '"' || terraform version | head -1 | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+')

    if version_gte "$tf_version" "$MIN_TF_VERSION"; then
      success "Terraform v${tf_version}"
    else
      error "Terraform v${tf_version} found, but >= ${MIN_TF_VERSION} is required"
      info "Upgrade: ${CYAN}brew upgrade terraform${NC}"
      missing=1
    fi
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
    success "AWS CLI $(aws --version 2>&1 | awk '{print $1}')"
  else
    warn "AWS CLI not installed ${DIM}(optional, used for credential validation)${NC}"
  fi

  if [[ $missing -eq 1 ]]; then
    echo ""
    error "Install/upgrade the missing tools and come back! 👋"
    exit 1
  fi

  echo ""
  echo -e "  ${GREEN}All good, let's go! 🚀${NC}"
}
