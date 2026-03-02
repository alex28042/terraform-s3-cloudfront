#!/usr/bin/env bash

destroy_infra() {
  print_banner
  step "💣  Destroy infrastructure"

  warn "This will delete ${BOLD}ALL${NC} resources created by Terraform"
  echo ""

  if ! confirm "Are you sure? This cannot be undone"; then
    info "Phew! Nothing was deleted 😅"
    exit 0
  fi

  echo ""
  warn "Last chance! Type Y to confirm"
  if ! confirm "Confirm destruction?"; then
    info "Cancelled. Your infra is safe 🛡️"
    exit 0
  fi

  cd "$SCRIPT_DIR"
  echo ""
  terraform destroy -auto-approve
  echo ""
  success "Everything has been destroyed 🏚️"
  echo -e "  ${DIM}Run ./deploy.sh to rebuild anytime${NC}"
  echo ""
}
