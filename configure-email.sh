#!/bin/bash

##############################################################################
# Email Configuration Script for Jenkins
# This script configures email settings for Extended Email Plugin
##############################################################################

set -e

echo "=========================================="
echo "Jenkins Email Configuration"
echo "=========================================="
echo ""

# Prompt for email credentials
read -p "Enter your Gmail address: " GMAIL_USER
read -sp "Enter your Gmail App Password (16 chars): " GMAIL_PASS
echo ""
read -p "Enter SMTP server (default: smtp.gmail.com): " SMTP_SERVER
SMTP_SERVER=${SMTP_SERVER:-smtp.gmail.com}
read -p "Enter SMTP port (default: 587): " SMTP_PORT
SMTP_PORT=${SMTP_PORT:-587}

echo ""
echo "Configuring Extended Email Plugin..."

# Backup existing configuration
sudo cp /var/lib/jenkins/hudson.plugins.emailext.ExtendedEmailPublisherDescriptor.xml \
        /var/lib/jenkins/hudson.plugins.emailext.ExtendedEmailPublisherDescriptor.xml.backup 2>/dev/null || true

# Create new configuration
sudo tee /var/lib/jenkins/hudson.plugins.emailext.ExtendedEmailPublisherDescriptor.xml > /dev/null << EOF
<?xml version='1.1' encoding='UTF-8'?>
<hudson.plugins.emailext.ExtendedEmailPublisherDescriptor plugin="email-ext@1933.v45cec755423f">
  <mailAccount>
    <smtpHost>$SMTP_SERVER</smtpHost>
    <smtpPort>$SMTP_PORT</smtpPort>
    <smtpUsername>$GMAIL_USER</smtpUsername>
    <smtpPassword>$GMAIL_PASS</smtpPassword>
    <useSsl>false</useSsl>
    <useTls>true</useTls>
    <advProperties></advProperties>
    <defaultAccount>true</defaultAccount>
    <useOAuth2>false</useOAuth2>
  </mailAccount>
  <addAccounts/>
  <charset>UTF-8</charset>
  <defaultContentType>text/html</defaultContentType>
  <defaultSubject>\$PROJECT_NAME - Build # \$BUILD_NUMBER - \$BUILD_STATUS!</defaultSubject>
  <defaultBody>\$PROJECT_NAME - Build # \$BUILD_NUMBER - \$BUILD_STATUS:

Check console output at \$BUILD_URL to view the results.</defaultBody>
  <defaultClasspath/>
  <defaultTriggerIds>
    <string>hudson.plugins.emailext.plugins.trigger.FailureTrigger</string>
    <string>hudson.plugins.emailext.plugins.trigger.SuccessTrigger</string>
  </defaultTriggerIds>
  <emergencyReroute></emergencyReroute>
  <maxAttachmentSize>-1</maxAttachmentSize>
  <recipientList>$GMAIL_USER</recipientList>
  <defaultReplyTo>$GMAIL_USER</defaultReplyTo>
  <allowedDomains></allowedDomains>
  <excludedCommitters></excludedCommitters>
  <listId></listId>
  <precedenceBulk>false</precedenceBulk>
  <debugMode>false</debugMode>
  <requireAdminForTemplateTesting>false</requireAdminForTemplateTesting>
  <enableWatching>false</enableWatching>
  <enableAllowUnregistered>false</enableAllowUnregistered>
  <throttlingEnabled>false</throttlingEnabled>
</hudson.plugins.emailext.ExtendedEmailPublisherDescriptor>
EOF

echo "Configuring standard Email Plugin..."

# Backup existing configuration
sudo cp /var/lib/jenkins/hudson.tasks.Mailer.xml \
        /var/lib/jenkins/hudson.tasks.Mailer.xml.backup 2>/dev/null || true

# Create standard mailer configuration
sudo tee /var/lib/jenkins/hudson.tasks.Mailer.xml > /dev/null << EOF
<?xml version='1.1' encoding='UTF-8'?>
<hudson.tasks.Mailer_-DescriptorImpl plugin="mailer@521.vf3500273133e">
  <defaultSuffix>@gmail.com</defaultSuffix>
  <smtpHost>$SMTP_SERVER</smtpHost>
  <useSsl>false</useSsl>
  <useTls>true</useTls>
  <smtpPort>$SMTP_PORT</smtpPort>
  <charset>UTF-8</charset>
  <smtpAuth>
    <username>$GMAIL_USER</username>
    <password>$GMAIL_PASS</password>
  </smtpAuth>
  <replyToAddress>$GMAIL_USER</replyToAddress>
</hudson.tasks.Mailer_-DescriptorImpl>
EOF

# Set proper permissions
sudo chown jenkins:jenkins /var/lib/jenkins/hudson.plugins.emailext.ExtendedEmailPublisherDescriptor.xml
sudo chown jenkins:jenkins /var/lib/jenkins/hudson.tasks.Mailer.xml

echo ""
echo "Restarting Jenkins to apply changes..."
sudo systemctl restart jenkins

echo ""
echo "=========================================="
echo "Email configuration completed!"
echo "=========================================="
echo ""
echo "Configuration applied:"
echo "  SMTP Server: $SMTP_SERVER"
echo "  SMTP Port: $SMTP_PORT"
echo "  Username: $GMAIL_USER"
echo "  Reply-To: $GMAIL_USER"
echo ""
echo "Please wait 30 seconds for Jenkins to restart, then:"
echo "1. Login to Jenkins"
echo "2. Go to Manage Jenkins → Configure System"
echo "3. Test the email configuration"
echo "=========================================="
