#!/bin/bash

##############################################################################
# Jenkins Configuration Script
# This script configures Jenkins plugins and settings via CLI
##############################################################################

set -e

echo "=========================================="
echo "Jenkins Configuration Script"
echo "=========================================="

# Variables
JENKINS_URL="http://localhost:8080"
JENKINS_HOME="/var/lib/jenkins"

echo "[1/3] Waiting for Jenkins to be fully ready..."
timeout=300
elapsed=0
while [ $elapsed -lt $timeout ]; do
    if curl -s -o /dev/null -w "%{http_code}" "$JENKINS_URL/login" | grep -q "200\|403"; then
        echo "Jenkins is ready!"
        break
    fi
    echo "Waiting for Jenkins... ($elapsed/$timeout seconds)"
    sleep 5
    elapsed=$((elapsed + 5))
done

if [ $elapsed -ge $timeout ]; then
    echo "ERROR: Jenkins did not start within $timeout seconds"
    exit 1
fi

echo "[2/3] Jenkins plugins will be installed via web UI"
echo "Required plugins:"
echo "  - Git plugin"
echo "  - Docker plugin"
echo "  - Email Extension Plugin"
echo "  - Pipeline plugin"
echo "  - GitHub plugin"

echo ""
echo "[3/3] Configuration instructions:"
echo "=========================================="
echo "MANUAL CONFIGURATION STEPS:"
echo "=========================================="
echo ""
echo "1. EMAIL NOTIFICATION SETUP:"
echo "   - Go to: Manage Jenkins > Configure System"
echo "   - Scroll to 'E-mail Notification' section"
echo "   - SMTP Server: smtp.gmail.com"
echo "   - Click 'Advanced'"
echo "   - Check 'Use SMTP Authentication'"
echo "   - User Name: wasiquemahmood786@gmail.com"
echo "   - Password: bqccjacvjdecsxne"
echo "   - Check 'Use SSL'"
echo "   - SMTP Port: 465"
echo "   - Click 'Test configuration by sending test e-mail'"
echo ""
echo "2. EXTENDED EMAIL (EmailExt) SETUP:"
echo "   - In same page, scroll to 'Extended E-mail Notification'"
echo "   - SMTP Server: smtp.gmail.com"
echo "   - SMTP Port: 465"
echo "   - Click 'Advanced'"
echo "   - Credentials: Add > Jenkins"
echo "     - Kind: Username with password"
echo "     - Username: wasiquemahmood786@gmail.com"
echo "     - Password: bqccjacvjdecsxne"
echo "     - ID: gmail-smtp"
echo "   - Check 'Use SSL'"
echo "   - Default Content Type: HTML (text/html)"
echo ""
echo "3. GITHUB WEBHOOK SETUP:"
echo "   - In GitHub repo: Settings > Webhooks > Add webhook"
echo "   - Payload URL: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):8080/github-webhook/"
echo "   - Content type: application/json"
echo "   - Events: Just the push event"
echo "   - Active: checked"
echo ""
echo "4. CREATE JENKINS PIPELINE JOB:"
echo "   - New Item > Enter name: Moodify-CI-CD"
echo "   - Select: Pipeline"
echo "   - Pipeline definition: Pipeline script from SCM"
echo "   - SCM: Git"
echo "   - Repository URL: https://github.com/iamwasiqueasjid/Moodify-Test.git"
echo "   - Branch: */main (or your branch name)"
echo "   - Script Path: Jenkinsfile"
echo "   - Scan Multibranch Pipeline Triggers: checked"
echo "   - Build Triggers: GitHub hook trigger for GITScm polling"
echo ""
echo "=========================================="
echo "Configuration guide complete!"
echo "=========================================="
