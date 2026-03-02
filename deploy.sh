#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TFVARS_FILE="${SCRIPT_DIR}/terraform.tfvars"

source "${SCRIPT_DIR}/scripts/utils.sh"
source "${SCRIPT_DIR}/scripts/check_dependencies.sh"
source "${SCRIPT_DIR}/scripts/configure_aws.sh"
source "${SCRIPT_DIR}/scripts/configure_project.sh"
source "${SCRIPT_DIR}/scripts/show_summary.sh"
source "${SCRIPT_DIR}/scripts/run_terraform.sh"
source "${SCRIPT_DIR}/scripts/destroy.sh"

main() {
  print_banner

  case "${1:-}" in
    --destroy|-d)
      destroy_infra
      exit 0
      ;;
    --help|-h)
      echo -e "  ${BOLD}Usage:${NC}"
      echo -e "    ./deploy.sh            Deploy infrastructure"
      echo -e "    ./deploy.sh --destroy  Destroy infrastructure"
      echo -e "    ./deploy.sh --help     Show this help"
      echo ""
      exit 0
      ;;
  esac

  check_dependencies
  configure_aws
  configure_project
  show_summary

  if confirm "Deploy now?"; then
    run_terraform
  else
    echo ""
    success "Configuration saved. Run when ready:"
    echo -e "    ${CYAN}cd ${SCRIPT_DIR} && terraform init && terraform apply${NC}"
    echo ""
  fi
}

main "$@"
