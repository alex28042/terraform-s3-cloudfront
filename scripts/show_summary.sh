#!/usr/bin/env bash

show_summary() {
  step "📋  4/5 — Summary"

  echo -e "  ┌─────────────────────────────────────────────┐"
  echo -e "  │                                             │"
  echo -e "  │  ${BOLD}Project${NC}       ${CYAN}${PROJECT_NAME}$(printf '%*s' $((22 - ${#PROJECT_NAME})) '')${NC}│"
  echo -e "  │  ${BOLD}Environment${NC}   ${CYAN}${ENVIRONMENT}$(printf '%*s' $((22 - ${#ENVIRONMENT})) '')${NC}│"
  echo -e "  │  ${BOLD}Region${NC}        ${CYAN}${AWS_REGION}$(printf '%*s' $((22 - ${#AWS_REGION})) '')${NC}│"
  echo -e "  │  ${BOLD}CDN coverage${NC}  ${CYAN}${PRICE_CLASS}$(printf '%*s' $((22 - ${#PRICE_CLASS})) '')${NC}│"
  echo -e "  │  ${BOLD}Cache TTL${NC}     ${CYAN}${CACHE_TTL}s$(printf '%*s' $((21 - ${#CACHE_TTL})) '')${NC}│"
  echo -e "  │  ${BOLD}Versioning${NC}    ${CYAN}${ENABLE_VERSIONING}$(printf '%*s' $((22 - ${#ENABLE_VERSIONING})) '')${NC}│"
  echo -e "  │  ${BOLD}Tags${NC}          ${CYAN}${TAG_TEAM} / ${TAG_OWNER}$(printf '%*s' $((19 - ${#TAG_TEAM} - ${#TAG_OWNER})) '')${NC}│"
  echo -e "  │                                             │"
  echo -e "  └─────────────────────────────────────────────┘"
  echo ""
  echo -e "  ${BOLD}Resources:${NC}"
  echo -e "    🪣  S3 Bucket        ${CYAN}${PROJECT_NAME}-${ENVIRONMENT}-assets${NC}"
  echo -e "    🌐  CloudFront CDN"
  echo -e "    🔐  Origin Access Control (OAC)"
  echo -e "    ⚡  Cache Policy + Security Headers"
  echo -e "    🛂  IAM Policy for backend"
}
