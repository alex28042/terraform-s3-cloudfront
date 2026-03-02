#!/usr/bin/env bash

select_region() {
  echo -e "  ${BOLD}🌍  AWS Region${NC}"
  echo ""
  echo -e "    ${BOLD}Europe:${NC}"
  echo -e "      ${GREEN}▸${NC}  ${CYAN}1)${NC}  eu-west-1      🇮🇪  Ireland"
  echo -e "         ${CYAN}2)${NC}  eu-west-2      🇬🇧  London"
  echo -e "         ${CYAN}3)${NC}  eu-west-3      🇫🇷  Paris"
  echo -e "         ${CYAN}4)${NC}  eu-central-1   🇩🇪  Frankfurt"
  echo -e "         ${CYAN}5)${NC}  eu-central-2   🇨🇭  Zurich"
  echo -e "         ${CYAN}6)${NC}  eu-south-1     🇮🇹  Milan"
  echo -e "         ${CYAN}7)${NC}  eu-south-2     🇪🇸  Spain"
  echo -e "         ${CYAN}8)${NC}  eu-north-1     🇸🇪  Stockholm"
  echo ""
  echo -e "    ${BOLD}Americas:${NC}"
  echo -e "         ${CYAN}9)${NC}  us-east-1      🇺🇸  N. Virginia"
  echo -e "        ${CYAN}10)${NC}  us-west-2      🇺🇸  Oregon"
  echo -e "        ${CYAN}11)${NC}  sa-east-1      🇧🇷  Sao Paulo"
  echo ""
  echo -e "    ${BOLD}Asia Pacific:${NC}"
  echo -e "        ${CYAN}12)${NC}  ap-southeast-1 🇸🇬  Singapore"
  echo -e "        ${CYAN}13)${NC}  ap-northeast-1 🇯🇵  Tokyo"
  echo ""
  echo -e "        ${CYAN}14)${NC}  ✏️   Custom region"
  echo ""
  echo -en "  Select ${CYAN}▸${NC} "
  read -r region_choice

  case "${region_choice:-1}" in
    1)  AWS_REGION="eu-west-1" ;;
    2)  AWS_REGION="eu-west-2" ;;
    3)  AWS_REGION="eu-west-3" ;;
    4)  AWS_REGION="eu-central-1" ;;
    5)  AWS_REGION="eu-central-2" ;;
    6)  AWS_REGION="eu-south-1" ;;
    7)  AWS_REGION="eu-south-2" ;;
    8)  AWS_REGION="eu-north-1" ;;
    9)  AWS_REGION="us-east-1" ;;
    10) AWS_REGION="us-west-2" ;;
    11) AWS_REGION="sa-east-1" ;;
    12) AWS_REGION="ap-southeast-1" ;;
    13) AWS_REGION="ap-northeast-1" ;;
    14) prompt AWS_REGION "Enter region code (e.g. me-south-1)" "" ;;
    *)  AWS_REGION="eu-west-1" ;;
  esac

  success "Region: ${BOLD}${AWS_REGION}${NC}"
}

select_environment() {
  echo -e "  ${BOLD}🏷️   Environment${NC}"
  echo ""
  echo -e "    ${GREEN}▸${NC} ${CYAN}1)${NC} 🟢  prod     ${DIM}production${NC}"
  echo -e "      ${CYAN}2)${NC} 🟡  staging  ${DIM}pre-production${NC}"
  echo -e "      ${CYAN}3)${NC} 🔵  dev      ${DIM}development${NC}"
  echo ""
  echo -en "  Select ${CYAN}▸${NC} "
  read -r env_choice

  case "${env_choice:-1}" in
    1) ENVIRONMENT="prod" ;;
    2) ENVIRONMENT="staging" ;;
    3) ENVIRONMENT="dev" ;;
    *) ENVIRONMENT="prod" ;;
  esac

  success "Environment: ${BOLD}${ENVIRONMENT}${NC}"
}

select_price_class() {
  echo ""
  echo -e "  ${BOLD}💰  CDN Price Class${NC}"
  echo ""
  echo -e "    ${GREEN}▸${NC} ${CYAN}1)${NC} 💵  US + Europe        ${DIM}cheapest${NC}"
  echo -e "      ${CYAN}2)${NC} 💵💵  + Asia + S. America ${DIM}mid-tier${NC}"
  echo -e "      ${CYAN}3)${NC} 💵💵💵 Global              ${DIM}most expensive${NC}"
  echo ""
  echo -en "  Select ${CYAN}▸${NC} "
  read -r price_choice

  case "${price_choice:-1}" in
    1) PRICE_CLASS="PriceClass_100" ;;
    2) PRICE_CLASS="PriceClass_200" ;;
    3) PRICE_CLASS="PriceClass_All" ;;
    *) PRICE_CLASS="PriceClass_100" ;;
  esac

  success "Price class: ${BOLD}${PRICE_CLASS}${NC}"
}

select_versioning() {
  echo ""
  echo -e "  ${BOLD}📦  S3 Versioning${NC}"
  echo -e "  ${DIM}Keeps old versions of files. Protects against accidental deletes${NC}"
  echo -e "  ${DIM}but doubles storage usage. Free Tier = 5GB total.${NC}"
  if confirm "Enable versioning?"; then
    ENABLE_VERSIONING="true"
    success "Versioning: ${BOLD}ON${NC} 🛡️"
  else
    ENABLE_VERSIONING="false"
    success "Versioning: ${BOLD}OFF${NC} ${DIM}(saves storage)${NC}"
  fi
}

generate_tfvars() {
  local output_file="$1"

  cat > "$output_file" <<EOF
project_name = "${PROJECT_NAME}"
environment  = "${ENVIRONMENT}"
aws_region   = "${AWS_REGION}"
cache_ttl    = ${CACHE_TTL}
price_class  = "${PRICE_CLASS}"

enable_versioning = ${ENABLE_VERSIONING}

cors_allowed_origins = ["*"]

tags = {
  Team  = "${TAG_TEAM}"
  Owner = "${TAG_OWNER}"
}
EOF
}

configure_project() {
  step "⚙️   3/5 — Project setup"

  prompt PROJECT_NAME "Project name (e.g. marketplace-boats)"
  echo ""

  select_environment
  echo ""
  print_divider
  echo ""
  select_region
  echo ""
  print_divider
  echo ""
  select_price_class

  echo ""
  print_divider
  echo ""
  prompt CACHE_TTL "⏱️   Cache TTL in seconds ${DIM}(higher = fewer S3 requests = cheaper)${NC}" "604800"

  select_versioning

  echo ""
  print_divider
  echo ""
  prompt TAG_TEAM "🏢  Tag Team" "devops"
  prompt TAG_OWNER "👤  Tag Owner (your name)"

  generate_tfvars "$TFVARS_FILE"

  echo ""
  success "Configuration saved! 💾"
}
