#!/bin/bash

##############################################################################
# Jenkins Job Configuration Script
# This script updates the existing Jenkins job to use SCM (GitHub)
##############################################################################

set -e

echo "=========================================="
echo "Updating Jenkins Job Configuration"
echo "=========================================="

# Variables
JENKINS_HOME="/var/lib/jenkins"
JOB_NAME="Moodify-CI-CD"
JOB_DIR="$JENKINS_HOME/jobs/$JOB_NAME"

echo "[1/3] Backing up current job configuration..."
sudo cp "$JOB_DIR/config.xml" "$JOB_DIR/config.xml.backup"

echo "[2/3] Creating new job configuration..."

# Create the updated config.xml
sudo tee "$JOB_DIR/config.xml" > /dev/null << 'EOF'
<?xml version='1.1' encoding='UTF-8'?>
<flow-definition plugin="workflow-job@1559.va_a_533730b_ea_d">
  <description>Moodify Selenium Test Automation Pipeline</description>
  <keepDependencies>false</keepDependencies>
  <properties>
    <com.coravy.hudson.plugins.github.GithubProjectProperty plugin="github@1.45.0">
      <projectUrl>https://github.com/iamwasiqueasjid/Moodify-Test/</projectUrl>
      <displayName></displayName>
    </com.coravy.hudson.plugins.github.GithubProjectProperty>
    <org.jenkinsci.plugins.workflow.job.properties.PipelineTriggersJobProperty>
      <triggers>
        <com.cloudbees.jenkins.GitHubPushTrigger plugin="github@1.45.0">
          <spec></spec>
        </com.cloudbees.jenkins.GitHubPushTrigger>
      </triggers>
    </org.jenkinsci.plugins.workflow.job.properties.PipelineTriggersJobProperty>
  </properties>
  <definition class="org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition" plugin="workflow-cps@4238.va_6fb_65c1f699">
    <scm class="hudson.plugins.git.GitSCM" plugin="git@5.7.4">
      <configVersion>2</configVersion>
      <userRemoteConfigs>
        <hudson.plugins.git.UserRemoteConfig>
          <url>https://github.com/iamwasiqueasjid/Moodify-Test.git</url>
        </hudson.plugins.git.UserRemoteConfig>
      </userRemoteConfigs>
      <branches>
        <hudson.plugins.git.BranchSpec>
          <name>*/main</name>
        </hudson.plugins.git.BranchSpec>
      </branches>
      <doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
      <submoduleCfg class="empty-list"/>
      <extensions/>
    </scm>
    <scriptPath>Jenkinsfile</scriptPath>
    <lightweight>true</lightweight>
  </definition>
  <triggers/>
  <disabled>false</disabled>
</flow-definition>
EOF

echo "[3/3] Reloading Jenkins configuration..."
sudo systemctl reload jenkins || sudo systemctl restart jenkins

echo ""
echo "=========================================="
echo "Job configuration updated successfully!"
echo "=========================================="
echo ""
echo "The job is now configured to:"
echo "  - Pull code from GitHub (main branch)"
echo "  - Use Jenkinsfile from repository"
echo "  - Trigger on GitHub push events"
echo ""
echo "Next steps:"
echo "1. Configure email notifications in Jenkins UI"
echo "2. Add GitHub webhook"
echo "3. Test the pipeline"
echo "=========================================="
