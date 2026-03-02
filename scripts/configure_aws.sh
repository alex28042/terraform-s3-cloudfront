#!/usr/bin/env bash

configure_aws() {
  step "🔑  2/5 — AWS credentials"

  info "I need credentials for the target AWS account"
  echo ""

  local use_existing="no"

  if [[ -n "${AWS_ACCESS_KEY_ID:-}" ]] || aws sts get-caller-identity &>/dev/null 2>&1; then
    local identity
    identity=$(aws sts get-caller-identity --output text --query 'Account' 2>/dev/null || echo "unknown")
    success "Found existing credentials ${DIM}(account: ${identity})${NC}"
    echo ""
    if confirm "Use these credentials?"; then
      use_existing="yes"
    fi
  fi

  if [[ "$use_existing" != "yes" ]]; then
    echo ""
    echo -e "  ${BOLD}How do you want to authenticate?${NC}"
    echo ""
    echo -e "    ${CYAN}1)${NC} 🔑  Access Key + Secret Key"
    echo -e "    ${CYAN}2)${NC} 📋  AWS Profile (~/.aws/credentials)"
    echo -e "    ${CYAN}3)${NC} 🔗  SSO / Assume Role ${DIM}(configured externally)${NC}"
    echo ""
    echo -en "  Pick one ${CYAN}▸${NC} "
    read -r auth_method

    case "${auth_method:-1}" in
      1)
        echo ""
        prompt AWS_ACCESS_KEY_ID "Access Key ID"
        prompt_secret AWS_SECRET_ACCESS_KEY "Secret Access Key"
        prompt AWS_SESSION_TOKEN "Session Token ${DIM}(leave empty if no MFA)${NC}" ""
        export AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY
        [[ -n "${AWS_SESSION_TOKEN:-}" ]] && export AWS_SESSION_TOKEN
        ;;
      2)
        echo ""
        prompt aws_profile "Profile name" "default"
        export AWS_PROFILE="$aws_profile"
        ;;
      3)
        echo ""
        info "Make sure your environment has valid credentials"
        ;;
      *)
        error "Invalid option 🤔"
        exit 1
        ;;
    esac

    echo ""
    info "Checking connection..."
    if aws sts get-caller-identity &>/dev/null 2>&1; then
      local account arn
      account=$(aws sts get-caller-identity --query 'Account' --output text 2>/dev/null)
      arn=$(aws sts get-caller-identity --query 'Arn' --output text 2>/dev/null)
      success "Connected to account ${BOLD}${account}${NC} 🎉"
      echo -e "  ${DIM}   ARN: ${arn}${NC}"
    else
      warn "Couldn't verify credentials ${DIM}(AWS CLI missing?)${NC}"
      if ! confirm "Continue anyway?"; then
        exit 1
      fi
    fi
  fi
}
