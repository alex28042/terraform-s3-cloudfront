#!/usr/bin/env bash

show_summary() {
  step "📋  4/5 — Summary"

  echo -e "  ${BOLD}Project:${NC}       ${CYAN}${PROJECT_NAME}${NC}"
  echo -e "  ${BOLD}Environment:${NC}   ${CYAN}${ENVIRONMENT}${NC}"
  echo -e "  ${BOLD}Region:${NC}        ${CYAN}${AWS_REGION}${NC}"
  echo -e "  ${BOLD}CDN coverage:${NC}  ${CYAN}${PRICE_CLASS}${NC}"
  echo -e "  ${BOLD}Cache TTL:${NC}     ${CYAN}${CACHE_TTL}s${NC}"
  echo -e "  ${BOLD}Versioning:${NC}    ${CYAN}${ENABLE_VERSIONING}${NC}"
  echo -e "  ${BOLD}IAM User:${NC}      ${CYAN}${CREATE_IAM_USER}${NC}"
  echo -e "  ${BOLD}Tags:${NC}          ${CYAN}${TAG_TEAM} / ${TAG_OWNER}${NC}"

  echo ""
  echo -e "  ${BOLD}Resources:${NC}"
  echo -e "    🪣  S3 Bucket        ${CYAN}${PROJECT_NAME}-${ENVIRONMENT}-assets${NC}"
  echo -e "    🌐  CloudFront CDN"
  echo -e "    🔐  Origin Access Control (OAC)"
  echo -e "    ⚡  Cache Policy + Security Headers"
  echo -e "    🛂  IAM Policy for backend"
  if [[ "$CREATE_IAM_USER" == "true" ]]; then
    echo -e "    🔑  IAM User + Access Keys"
  fi
}
