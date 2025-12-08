# Jenkins CI/CD Assignment - Complete Deployment Guide

## 🎯 Assignment Requirements - Completed ✅

### ✅ What We've Implemented:

1. **Selenium Test Cases** - 10 comprehensive test cases covering authentication, dashboard, and UI
2. **Jenkins Pipeline** - Full CI/CD pipeline with test automation
3. **Docker Integration** - Containerized test execution environment
4. **Email Notifications** - Automated email reports to collaborators
5. **GitHub Integration** - Pipeline triggers on code push

---

## 📦 Project Structure Overview

```
Moodify/
├── Jenkinsfile                     # Jenkins pipeline definition
├── Dockerfile                      # Docker image for Selenium tests
├── ec2-setup.sh                    # EC2 automated setup script
├── jenkins-config.sh               # Jenkins configuration helper
├── selenium-tests/
│   ├── base_test.py               # Base test class with WebDriver setup
│   ├── config.py                  # Test configuration
│   ├── test_authentication.py     # 6 authentication tests
│   ├── test_dashboard.py          # 3 dashboard tests
│   ├── test_navigation_ui.py      # 1 logout test
│   ├── run_all_tests.py           # Master test runner
│   ├── requirements.txt           # Python dependencies
│   └── screenshots/               # Test screenshots
└── ASSIGNMENT_COMPLETION_GUIDE.md # This file
```

---

## 🚀 Quick Start - Complete Deployment Steps

### Step 1: Connect to EC2 Instance

```powershell
# From your local machine (PowerShell)
ssh -i "C:\Users\Work\Downloads\Moodify.pem" ubuntu@ec2-13-62-230-213.eu-north-1.compute.amazonaws.com
```

### Step 2: Verify Jenkins Installation

```bash
# Check if Jenkins is running
sudo systemctl status jenkins

# Check if Docker is running
sudo systemctl status docker

# Get Jenkins initial password (if needed)
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

### Step 3: Access Jenkins Web UI

Open your browser and go to:
```
http://13.62.230.213:8080
```

**If this is first time:**
1. Use the initial admin password from Step 2
2. Install suggested plugins (REQUIRED):
   - Git plugin
   - Docker plugin
   - Email Extension Plugin
   - Pipeline plugin
   - GitHub plugin
3. Create an admin user
4. Configure Jenkins URL: `http://13.62.230.213:8080/`

### Step 4: Configure Email Notifications

1. Go to **Manage Jenkins** → **Configure System**
2. Scroll to **Extended E-mail Notification** section:
   
   ```
   SMTP server: smtp.gmail.com
   SMTP Port: 587
   Click "Advanced..."
   ☑ Use SMTP Authentication
   User Name: your-email@gmail.com
   Password: [Your App Password - see below]
   ☑ Use TLS
   ```

3. **Generate Gmail App Password:**
   - Go to https://myaccount.google.com/security
   - Enable 2-Step Verification (if not already enabled)
   - Go to "App passwords"
   - Generate password for "Mail" / "Other (Custom name)"
   - Use this 16-character password in Jenkins

4. Scroll to **E-mail Notification** section and repeat similar settings:
   ```
   SMTP server: smtp.gmail.com
   Click "Advanced..."
   ☑ Use SMTP Authentication
   User Name: your-email@gmail.com
   Password: [Same App Password]
   ☑ Use TLS
   SMTP Port: 587
   ```

5. Test email configuration by clicking "Test configuration"

### Step 5: Create Jenkins Pipeline Job

1. Click **New Item**
2. Enter name: `Moodify-Selenium-Tests`
3. Select **Pipeline**
4. Click **OK**

#### Configure the Pipeline:

**General Section:**
- ☑ GitHub project
- Project url: `https://github.com/iamwasiqueasjid/Moodify-Test/`

**Build Triggers:**
- ☑ GitHub hook trigger for GITScm polling

**Pipeline Section:**
- Definition: **Pipeline script from SCM**
- SCM: **Git**
- Repository URL: `https://github.com/iamwasiqueasjid/Moodify-Test.git`
- Credentials: Add your GitHub credentials (Username + Personal Access Token)
- Branch Specifier: `*/main`
- Script Path: `Jenkinsfile`

Click **Save**

### Step 6: Configure GitHub Webhook

1. Go to your GitHub repository: https://github.com/iamwasiqueasjid/Moodify-Test
2. Click **Settings** → **Webhooks** → **Add webhook**
3. Configure:
   ```
   Payload URL: http://13.62.230.213:8080/github-webhook/
   Content type: application/json
   Which events: Just the push event
   ☑ Active
   ```
4. Click **Add webhook**

### Step 7: Add Collaborators to GitHub

1. Go to your GitHub repository
2. Click **Settings** → **Collaborators**
3. Click **Add people**
4. Add your instructor's GitHub username
5. They will receive an email invitation

---

## 🧪 Testing the Pipeline

### Manual Test (First Time)

1. In Jenkins, open your `Moodify-Selenium-Tests` job
2. Click **Build Now**
3. Watch the console output
4. Check for email notification

### Automatic Test (After Setup)

1. Make any small change to your repository:
   ```bash
   # From your local Moodify directory
   git add .
   git commit -m "Test Jenkins pipeline"
   git push origin main
   ```

2. Jenkins will automatically:
   - Detect the push via webhook
   - Pull the latest code
   - Build Docker image
   - Run all 10 Selenium tests
   - Send email with results

---

## 📧 Email Notification Details

The pipeline sends **HTML-formatted emails** with:

### On Success (✅):
- Build information
- Test results summary
- Number of screenshots captured
- Links to build details and artifacts
- Attached screenshots

### On Failure (❌):
- Build information
- Error details
- Console log attached
- Screenshots of failures
- Troubleshooting steps

**Email Recipients:**
- Automatically sent to the person who pushed the code
- Email is extracted from Git commit information

---

## 🐳 Docker Image Details

Our custom Docker image includes:
- Python 3.11
- Google Chrome (headless)
- ChromeDriver
- Selenium WebDriver
- All Python test dependencies
- Xvfb for virtual display

**Built from:** `Dockerfile` in the root directory

---

## 🔍 Selenium Test Cases (10 Total)

### Authentication Tests (6):
1. ✅ Homepage loads successfully
2. ✅ Navigation to login page
3. ✅ Empty fields validation
4. ✅ Invalid email format validation
5. ✅ Password length validation
6. ✅ Valid login and dashboard access

### Dashboard Tests (3):
7. ✅ Dashboard statistics display
8. ✅ Mood selection and Firebase persistence
9. ✅ Calendar component display

### Navigation Tests (1):
10. ✅ Logout functionality

---

## 🔧 Troubleshooting

### Jenkins Not Starting
```bash
sudo systemctl restart jenkins
sudo systemctl status jenkins
journalctl -u jenkins -n 50
```

### Docker Permission Issues
```bash
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

### Email Not Sending
- Verify Gmail App Password
- Check firewall allows outbound port 587
- Test email configuration in Jenkins

### Pipeline Fails on First Run
- Ensure Docker daemon is running
- Check if port 3000 is accessible (if testing against local app)
- Verify test credentials in `.env` file

### Tests Fail
```bash
# SSH into EC2 and check Docker logs
docker logs <container-id>

# Manually run tests in Docker
docker run --rm -it moodify-selenium-tests:latest bash
python run_all_tests.py
```

---

## 📝 Important Files Explained

### `Jenkinsfile`
- Defines the entire CI/CD pipeline
- 4 stages: Checkout, Build, Test, Publish
- Email notifications on success/failure
- Automatic screenshot archiving

### `Dockerfile`
- Creates containerized test environment
- Installs Chrome, ChromeDriver, Python
- Copies test files and dependencies
- Sets up headless browser environment

### `ec2-setup.sh`
- Automated EC2 instance configuration
- Installs Jenkins, Docker, Git
- Configures permissions
- Opens required ports

### `selenium-tests/run_all_tests.py`
- Master test runner
- Executes all 10 test cases
- Generates test reports
- Returns proper exit codes for CI/CD

---

## 🎓 Assignment Requirements Checklist

- [x] **Selenium Test Cases**: 10 comprehensive tests written in Python
- [x] **Jenkins Pipeline**: Fully automated CI/CD pipeline
- [x] **AWS EC2**: Jenkins running on EC2 instance
- [x] **Docker Integration**: Tests run in containerized environment
- [x] **GitHub Repository**: Code stored in GitHub
- [x] **GitHub Webhook**: Automatic pipeline triggers
- [x] **Email Notifications**: Automated email to collaborators
- [x] **Test Results**: Detailed reports with screenshots
- [x] **Collaborator Access**: Ready to add instructor as collaborator

---

## 📞 Support Information

### EC2 Connection Details
```
Instance: ec2-13-62-230-213.eu-north-1.compute.amazonaws.com
SSH: ssh -i "C:\Users\Work\Downloads\Moodify.pem" ubuntu@ec2-13-62-230-213.eu-north-1.compute.amazonaws.com
Jenkins URL: http://13.62.230.213:8080
```

### GitHub Repository
```
Repository: https://github.com/iamwasiqueasjid/Moodify-Test
Branch: main
```

---

## 🎉 Next Steps After Setup

1. **Add instructor as GitHub collaborator**
2. **Test the pipeline** by making a small commit
3. **Verify email notifications** are received
4. **Document any custom configurations** you made
5. **Prepare demo** showing:
   - GitHub push triggering Jenkins
   - Pipeline execution
   - Email notification received
   - Test results and screenshots

---

## 📚 Additional Resources

- Jenkins Documentation: https://www.jenkins.io/doc/
- Selenium Python: https://selenium-python.readthedocs.io/
- Docker Hub: https://hub.docker.com/
- GitHub Webhooks: https://docs.github.com/en/webhooks

---

**Congratulations! Your Jenkins CI/CD pipeline is ready for automated Selenium testing! 🚀**
