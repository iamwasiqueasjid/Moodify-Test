# Jenkins CI/CD Pipeline - Complete Setup Guide

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [EC2 Instance Setup](#ec2-instance-setup)
3. [Jenkins Installation](#jenkins-installation)
4. [Jenkins Configuration](#jenkins-configuration)
5. [GitHub Integration](#github-integration)
6. [Testing the Pipeline](#testing-the-pipeline)
7. [Troubleshooting](#troubleshooting)

---

## Prerequisites

### AWS EC2 Instance
- **Instance Type**: t2.medium or larger (recommended)
- **OS**: Ubuntu 22.04 LTS
- **Storage**: At least 20 GB
- **Security Group**: Port 8080 open for Jenkins

### Local Requirements
- SSH client
- Git installed locally
- GitHub account
- PEM key file: `C:\Users\Work\Downloads\Moodify.pem`

### Connection Details
```bash
SSH Command: ssh -i "C:\Users\Work\Downloads\Moodify.pem" ubuntu@ec2-13-62-230-213.eu-north-1.compute.amazonaws.com
EC2 Public IP: 13.62.230.213
Jenkins URL: http://13.62.230.213:8080
```

---

## EC2 Instance Setup

### Step 1: Connect to EC2

Open PowerShell and connect to your EC2 instance:

```powershell
# Set correct permissions for PEM file
icacls "C:\Users\Work\Downloads\Moodify.pem" /inheritance:r
icacls "C:\Users\Work\Downloads\Moodify.pem" /grant:r "$($env:USERNAME):(R)"

# Connect via SSH
ssh -i "C:\Users\Work\Downloads\Moodify.pem" ubuntu@ec2-13-62-230-213.eu-north-1.compute.amazonaws.com
```

### Step 2: Verify Security Group

Ensure port 8080 is open in AWS Console:
1. Go to EC2 Dashboard
2. Select your instance
3. Go to Security tab → Security groups
4. Edit inbound rules
5. Add rule: Custom TCP, Port 8080, Source: 0.0.0.0/0 (or your IP)

### Step 3: Upload Setup Scripts

From your local machine (PowerShell):

```powershell
# Navigate to project directory
cd "d:\React JS Projects\Moodify"

# Copy setup scripts to EC2
scp -i "C:\Users\Work\Downloads\Moodify.pem" ec2-setup.sh ubuntu@ec2-13-62-230-213.eu-north-1.compute.amazonaws.com:~/
scp -i "C:\Users\Work\Downloads\Moodify.pem" jenkins-config.sh ubuntu@ec2-13-62-230-213.eu-north-1.compute.amazonaws.com:~/
```

### Step 4: Run Setup Script

On the EC2 instance:

```bash
# Make scripts executable
chmod +x ~/ec2-setup.sh ~/jenkins-config.sh

# Run the main setup script (this will take 5-10 minutes)
./ec2-setup.sh
```

**Important**: Save the initial admin password that appears at the end!

---

## Jenkins Installation

The `ec2-setup.sh` script installs:
- ✅ OpenJDK 17
- ✅ Jenkins
- ✅ Docker & Docker Compose
- ✅ Git
- ✅ Required utilities

### Verify Installation

```bash
# Check Jenkins status
sudo systemctl status jenkins

# Check Docker status
sudo systemctl status docker

# Verify Jenkins can use Docker
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

---

## Jenkins Configuration

### Step 1: Initial Setup

1. Access Jenkins: `http://13.62.230.213:8080`
2. Enter the initial admin password (from setup script output)
3. Click "Install suggested plugins"
4. Create admin user:
   - Username: `admin`
   - Password: (choose a secure password)
   - Full name: `Admin`
   - Email: `wasiquemahmood786@gmail.com`

### Step 2: Install Additional Plugins

1. Go to: **Manage Jenkins** → **Manage Plugins** → **Available**
2. Search and install:
   - ✅ Email Extension Plugin
   - ✅ Docker Pipeline
   - ✅ GitHub Integration Plugin
3. Restart Jenkins when prompted

### Step 3: Configure Email Notifications

#### Configure SMTP Server

1. Go to: **Manage Jenkins** → **Configure System**
2. Scroll to **E-mail Notification**:
   - SMTP server: `smtp.gmail.com`
   - Click **Advanced**
   - ☑ Use SMTP Authentication
   - User Name: `wasiquemahmood786@gmail.com`
   - Password: `bqccjacvjdecsxne`
   - ☑ Use SSL
   - SMTP Port: `465`
   - Reply-To Address: `wasiquemahmood786@gmail.com`
3. Click **Test configuration** → Enter test email
4. Save

#### Configure Extended Email

1. In same page, scroll to **Extended E-mail Notification**
2. SMTP server: `smtp.gmail.com`
3. Default user suffix: *(leave empty)*
4. Click **Advanced**:
   - ☑ Use SMTP Authentication
   - User Name: `wasiquemahmood786@gmail.com`
   - Password: `bqccjacvjdecsxne`
   - ☑ Use SSL
   - SMTP Port: `465`
   - Default Content Type: `HTML (text/html)`
   - Default Recipients: `wasiquemahmood786@gmail.com`
5. Click **Apply** then **Save**

### Step 4: Create Pipeline Job

1. Click **New Item**
2. Enter name: `Moodify-CI-CD`
3. Select: **Pipeline**
4. Click **OK**

#### Configure Pipeline

**General**:
- ☑ GitHub project
- Project url: `https://github.com/iamwasiqueasjid/Moodify-Test/`

**Build Triggers**:
- ☑ GitHub hook trigger for GITScm polling

**Pipeline**:
- Definition: **Pipeline script from SCM**
- SCM: **Git**
- Repository URL: `https://github.com/iamwasiqueasjid/Moodify-Test.git`
- Credentials: *(add if private repo)*
- Branch Specifier: `*/main` *(or your branch)*
- Script Path: `Jenkinsfile`

Click **Save**

---

## GitHub Integration

### Step 1: Push Code to GitHub

From your local machine (PowerShell):

```powershell
cd "d:\React JS Projects\Moodify"

# Initialize git (if not already)
git init
git add .
git commit -m "Add Jenkins CI/CD pipeline configuration"

# Add remote and push
git remote add origin https://github.com/iamwasiqueasjid/Moodify-Test.git
git branch -M main
git push -u origin main
```

### Step 2: Configure GitHub Webhook

1. Go to: `https://github.com/iamwasiqueasjid/Moodify-Test`
2. Click **Settings** → **Webhooks** → **Add webhook**
3. Configure:
   - Payload URL: `http://13.62.230.213:8080/github-webhook/`
   - Content type: `application/json`
   - Secret: *(leave empty)*
   - SSL verification: *(Enable if you have SSL)*
   - Which events: **Just the push event**
   - ☑ Active
4. Click **Add webhook**

### Step 3: Add Instructor as Collaborator

1. In your GitHub repo: **Settings** → **Collaborators**
2. Click **Add people**
3. Enter instructor's GitHub username or email
4. Click **Add to this repository**

---

## Testing the Pipeline

### Test 1: Manual Build

1. Go to Jenkins dashboard
2. Click on `Moodify-CI-CD` job
3. Click **Build Now**
4. Monitor **Console Output**
5. Verify:
   - ✅ Code checkout successful
   - ✅ Docker image builds
   - ✅ Tests run in container
   - ✅ Email sent with results

### Test 2: Webhook Trigger

Make a small change and push:

```powershell
cd "d:\React JS Projects\Moodify"

# Make a change
echo "Test webhook trigger" >> README.md

# Commit and push
git add .
git commit -m "Test Jenkins webhook trigger"
git push origin main
```

Verify:
1. Check Jenkins - build should start automatically
2. Check email - you should receive test results
3. Check build artifacts for screenshots

### Test 3: Collaborator Push

1. Instructor makes a push to repository
2. Pipeline triggers automatically
3. Email sent to instructor's email address
4. Verify email contains:
   - Build status
   - Pushed by information
   - Test results
   - Screenshots (attached)

---

## Verification Checklist

- [ ] EC2 instance accessible via SSH
- [ ] Port 8080 open and Jenkins accessible
- [ ] Jenkins fully configured with plugins
- [ ] Email notifications working
- [ ] Docker installed and accessible to Jenkins
- [ ] GitHub webhook configured
- [ ] Manual pipeline build successful
- [ ] Automatic build triggers on push
- [ ] Email sent to collaborator who pushed
- [ ] Screenshots archived in Jenkins
- [ ] Instructor added as collaborator

---

## Troubleshooting

### Issue: Cannot connect to EC2

**Solution**:
```powershell
# Check PEM file permissions
icacls "C:\Users\Work\Downloads\Moodify.pem"

# Reset permissions
icacls "C:\Users\Work\Downloads\Moodify.pem" /inheritance:r
icacls "C:\Users\Work\Downloads\Moodify.pem" /grant:r "$($env:USERNAME):(R)"
```

### Issue: Port 8080 not accessible

**Solution**:
1. Check AWS Security Group inbound rules
2. Add rule: Type: Custom TCP, Port: 8080, Source: 0.0.0.0/0

### Issue: Jenkins can't access Docker

**Solution**:
```bash
# Add Jenkins to docker group
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins

# Verify
sudo -u jenkins docker ps
```

### Issue: Email not sending

**Solution**:
1. Verify Gmail settings in Jenkins
2. Ensure App Password is correct: `bqccjacvjdecsxne`
3. Test SMTP connection: `telnet smtp.gmail.com 465`
4. Check Jenkins logs: `/var/log/jenkins/jenkins.log`

### Issue: GitHub webhook not triggering

**Solution**:
1. Check webhook in GitHub → Settings → Webhooks
2. View "Recent Deliveries" for errors
3. Ensure URL is: `http://13.62.230.213:8080/github-webhook/`
4. Verify Jenkins has GitHub plugin installed

### Issue: Docker build fails

**Solution**:
```bash
# Check Docker logs
sudo journalctl -u docker -n 50

# Clean up Docker resources
docker system prune -a -f

# Rebuild manually
cd /var/lib/jenkins/workspace/Moodify-CI-CD
sudo -u jenkins docker build -t moodify-selenium-tests .
```

### Issue: Tests fail in container

**Solution**:
1. Check test logs in Jenkins console output
2. View screenshots: Jenkins → Build → Artifacts
3. Run tests locally:
   ```bash
   cd selenium-tests
   python -m unittest discover -v
   ```

### View Jenkins Logs

```bash
# System logs
sudo journalctl -u jenkins -f

# Jenkins application log
sudo tail -f /var/log/jenkins/jenkins.log

# Build workspace
cd /var/lib/jenkins/workspace/Moodify-CI-CD
```

---

## Email Configuration Details

### Gmail SMTP Settings

| Setting | Value |
|---------|-------|
| SMTP Server | smtp.gmail.com |
| SMTP Port | 465 |
| Use SSL | ✓ Yes |
| Username | wasiquemahmood786@gmail.com |
| App Password | bqccjacvjdecsxne |

### Email Features

The pipeline sends HTML emails with:
- ✅ Build status (Success/Failure)
- ✅ Pusher name and email
- ✅ Branch information
- ✅ Build duration
- ✅ Test results summary
- ✅ Screenshot count
- ✅ Links to build details
- ✅ Screenshot attachments

---

## Pipeline Architecture

```
┌─────────────┐
│   GitHub    │ ──push──▶ Webhook
└─────────────┘            │
                           ▼
                    ┌──────────────┐
                    │   Jenkins    │
                    │   Pipeline   │
                    └──────────────┘
                           │
            ┌──────────────┼──────────────┐
            ▼              ▼              ▼
     ┌──────────┐   ┌──────────┐  ┌──────────┐
     │ Checkout │   │  Build   │  │   Test   │
     │   Code   │   │  Docker  │  │   Run    │
     └──────────┘   └──────────┘  └──────────┘
                           │
            ┌──────────────┼──────────────┐
            ▼              ▼              ▼
     ┌──────────┐   ┌──────────┐  ┌──────────┐
     │ Archive  │   │  Email   │  │  Cleanup │
     │ Results  │   │  Notify  │  │  Docker  │
     └──────────┘   └──────────┘  └──────────┘
```

---

## Security Notes

> [!WARNING]
> The email credentials in this guide are for educational purposes. In production:
> - Use Jenkins Credentials Store
> - Use environment variables
> - Enable 2FA where possible
> - Rotate passwords regularly

---

## Support & Resources

- **Jenkins Documentation**: https://www.jenkins.io/doc/
- **Docker Documentation**: https://docs.docker.com/
- **Selenium Python**: https://selenium-python.readthedocs.io/

---

## Assignment Completion Checklist

- [ ] Automated test cases written using Selenium ✅
- [ ] Jenkins automation pipeline created ✅
- [ ] Jenkins configured for containerized testing ✅
- [ ] Pipeline runs tests in Docker ✅
- [ ] GitHub webhook configured ✅
- [ ] Instructor added as collaborator ✅
- [ ] Email sent to collaborator who pushed ✅
- [ ] Test results included in email ✅
- [ ] Documentation completed ✅

---

**Created for**: Cloud Computing Assignment - Jenkins CI/CD Pipeline  
**Date**: December 2024  
**Author**: Moodify Team
