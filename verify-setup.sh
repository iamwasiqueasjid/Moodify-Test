#!/bin/bash

##############################################################################
# Quick Test Script - Verify Jenkins and Docker Setup
# Run this to quickly verify everything is working
##############################################################################

echo "=========================================="
echo "Jenkins & Docker Health Check"
echo "=========================================="
echo ""

# Color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test 1: Jenkins Service
echo -n "1. Jenkins Service: "
if sudo systemctl is-active --quiet jenkins; then
    echo -e "${GREEN}✓ Running${NC}"
else
    echo -e "${RED}✗ Not Running${NC}"
fi

# Test 2: Docker Service
echo -n "2. Docker Service: "
if sudo systemctl is-active --quiet docker; then
    echo -e "${GREEN}✓ Running${NC}"
else
    echo -e "${RED}✗ Not Running${NC}"
fi

# Test 3: Jenkins Listening on Port 8080
echo -n "3. Jenkins Port 8080: "
if sudo netstat -tuln | grep -q ':8080'; then
    echo -e "${GREEN}✓ Listening${NC}"
else
    echo -e "${RED}✗ Not Listening${NC}"
fi

# Test 4: Docker Permissions for Jenkins
echo -n "4. Jenkins in Docker Group: "
if groups jenkins | grep -q docker; then
    echo -e "${GREEN}✓ Configured${NC}"
else
    echo -e "${RED}✗ Not Configured${NC}"
    echo -e "   ${YELLOW}Fix: sudo usermod -aG docker jenkins; sudo systemctl restart jenkins${NC}"
fi

# Test 5: Job Exists
echo -n "5. Jenkins Job Exists: "
if [ -d "/var/lib/jenkins/jobs/Moodify-CI-CD" ]; then
    echo -e "${GREEN}✓ Found${NC}"
else
    echo -e "${RED}✗ Not Found${NC}"
fi

# Test 6: Git Installed
echo -n "6. Git Installed: "
if command -v git &> /dev/null; then
    echo -e "${GREEN}✓ $(git --version)${NC}"
else
    echo -e "${RED}✗ Not Installed${NC}"
fi

# Test 7: Docker Can Build
echo -n "7. Docker Build Test: "
echo 'FROM alpine:latest' | sudo docker build -q -t test-image - > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Working${NC}"
    sudo docker rmi test-image > /dev/null 2>&1
else
    echo -e "${RED}✗ Failed${NC}"
fi

# Test 8: Jenkins URL Configuration
echo -n "8. Jenkins URL Configured: "
JENKINS_URL=$(sudo cat /var/lib/jenkins/jenkins.model.JenkinsLocationConfiguration.xml 2>/dev/null | grep jenkinsUrl | sed 's/.*<jenkinsUrl>\(.*\)<\/jenkinsUrl>.*/\1/')
if [ ! -z "$JENKINS_URL" ]; then
    echo -e "${GREEN}✓ $JENKINS_URL${NC}"
else
    echo -e "${RED}✗ Not Configured${NC}"
fi

# Get Public IP
echo ""
echo "=========================================="
PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
echo "Jenkins URL: http://$PUBLIC_IP:8080"
echo "=========================================="

# Summary
echo ""
echo "Next Steps:"
echo "1. Access Jenkins at the URL above"
echo "2. Configure email notifications (see FINAL_SETUP_CHECKLIST.md)"
echo "3. Add GitHub webhook"
echo "4. Test the pipeline"
echo ""
