#!/usr/bin/env bash

run_terraform() {
  step "🚀  5/5 — Deploying to AWS"

  cd "$SCRIPT_DIR"

  echo -e "  ${CYAN}⠋${NC} Initializing Terraform..."
  echo ""
  if ! terraform init; then
    error "terraform init failed 💥"
    exit 1
  fi
  echo ""
  success "Terraform initialized"

  echo ""
  echo -e "  ${CYAN}⠋${NC} Planning infrastructure..."
  echo ""
  if ! terraform plan -out=tfplan; then
    error "terraform plan failed 💥"
    exit 1
  fi
  echo ""
  success "Plan ready"

  if ! confirm "🟢 Apply and create resources?"; then
    warn "Deployment paused. Plan saved as 'tfplan'"
    info "Resume later with: ${CYAN}terraform apply tfplan${NC}"
    exit 0
  fi

  echo ""
  echo -e "  ${CYAN}⠋${NC} Creating resources..."
  echo ""
  if ! terraform apply tfplan; then
    error "terraform apply failed 💥"
    exit 1
  fi

  rm -f tfplan
  print_results
}

print_results() {
  local cdn_url bucket_name distribution_id policy_arn
  cdn_url=$(terraform output -raw cdn_url 2>/dev/null)
  bucket_name=$(terraform output -raw s3_bucket_name 2>/dev/null)
  distribution_id=$(terraform output -raw cdn_distribution_id 2>/dev/null)
  policy_arn=$(terraform output -raw backend_policy_arn 2>/dev/null)

  echo ""
  echo -e "${GREEN}${BOLD}"
  echo "  ╔═══════════════════════════════════════════════════════╗"
  echo "  ║                                                       ║"
  echo "  ║        🎉  DEPLOYMENT COMPLETED SUCCESSFULLY  🎉      ║"
  echo "  ║                                                       ║"
  echo "  ╚═══════════════════════════════════════════════════════╝"
  echo -e "${NC}"

  echo -e "  ${BOLD}🌐 CDN URL${NC}          ${GREEN}${cdn_url}${NC}"
  echo -e "  ${BOLD}🪣 S3 Bucket${NC}        ${CYAN}${bucket_name}${NC}"
  echo -e "  ${BOLD}🆔 Distribution ID${NC}  ${distribution_id}"
  echo -e "  ${BOLD}🛂 IAM Policy ARN${NC}   ${policy_arn}"

  local access_key_id
  access_key_id=$(terraform output -raw backend_access_key_id 2>/dev/null || echo "")

  if [[ -n "$access_key_id" && "$access_key_id" != "null" ]]; then
    local secret_key
    secret_key=$(terraform output -raw backend_secret_access_key 2>/dev/null)

    echo ""
    print_divider
    echo ""
    echo -e "  ${BOLD}🔑 Backend credentials (for Railway / Vercel / Render)${NC}"
    echo ""
    echo -e "  ${BOLD}AWS_ACCESS_KEY_ID${NC}      ${GREEN}${access_key_id}${NC}"
    echo -e "  ${BOLD}AWS_SECRET_ACCESS_KEY${NC}   ${GREEN}${secret_key}${NC}"
    echo -e "  ${BOLD}AWS_REGION${NC}              ${GREEN}$(terraform output -raw s3_bucket_name 2>/dev/null | sed 's/.*//; ')${NC}"
    echo -e "  ${BOLD}S3_BUCKET_NAME${NC}          ${GREEN}${bucket_name}${NC}"
    echo -e "  ${BOLD}CDN_URL${NC}                 ${GREEN}${cdn_url}${NC}"
    echo ""
    echo -e "  ${YELLOW}⚠️  Save these now! The secret key won't be shown again.${NC}"
    echo -e "  ${DIM}Add them as environment variables in your Railway/Vercel dashboard.${NC}"
  fi

  echo ""
  print_divider
  echo ""
  echo -e "  ${BOLD}What's next? 👇${NC}"
  echo ""
  echo -e "  ${BOLD}1.${NC} 🖼️  ${BOLD}Frontend${NC} — load images via CDN:"
  echo -e "     ${CYAN}<img src=\"${cdn_url}/boats/yacht-001.webp\" />${NC}"
  echo ""
  echo -e "  ${BOLD}2.${NC} ⬆️  ${BOLD}Backend${NC} — upload files:"
  echo -e "     ${CYAN}aws s3 cp image.webp s3://${bucket_name}/boats/image.webp${NC}"
  echo ""
  echo -e "  ${BOLD}3.${NC} 🔄  ${BOLD}Invalidate cache${NC} — when you update an image:"
  echo -e "     ${CYAN}aws cloudfront create-invalidation --distribution-id ${distribution_id} --paths \"/boats/*\"${NC}"
  echo ""
  echo -e "  ${DIM}Happy shipping! 🚢${NC}"
  echo ""
}
