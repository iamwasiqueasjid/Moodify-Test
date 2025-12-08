# 🎯 FINAL SETUP CHECKLIST - Complete These Steps

## ✅ What's Already Done

1. ✅ EC2 instance is running
2. ✅ Jenkins is installed and running (http://13.62.230.213:8080)
3. ✅ Docker is installed and running
4. ✅ Jenkins job `Moodify-CI-CD` is created
5. ✅ GitHub webhook trigger is enabled
6. ✅ Required plugins are installed (Git, Docker, Email Extension, GitHub)
7. ✅ Jenkinsfile is ready with complete pipeline
8. ✅ Dockerfile is ready with Selenium test environment
9. ✅ 10 Selenium test cases are written and tested

---

## 🚨 CRITICAL: Steps You Must Complete

### Step 1: Update Jenkins Job to Use SCM ⚠️

**Current Issue:** The job is not pulling from GitHub repository.

**Solution:** Run this script on EC2:

```bash
# SSH into EC2
ssh -i "C:\Users\Work\Downloads\Moodify.pem" ubuntu@ec2-13-62-230-213.eu-north-1.compute.amazonaws.com

# Copy the update script
exit  # Back to local machine

# From local machine:
scp -i "C:\Users\Work\Downloads\Moodify.pem" update-jenkins-job.sh ubuntu@ec2-13-62-230-213.eu-north-1.compute.amazonaws.com:~/

# SSH back in
ssh -i "C:\Users\Work\Downloads\Moodify.pem" ubuntu@ec2-13-62-230-213.eu-north-1.compute.amazonaws.com

# Run the script
chmod +x update-jenkins-job.sh
./update-jenkins-job.sh
```

### Step 2: Configure Email Notifications 📧

1. **Open Jenkins:** http://13.62.230.213:8080
2. **Login** with your admin credentials
3. **Go to:** Manage Jenkins → Configure System

#### Section A: Extended E-mail Notification

Scroll down to **Extended E-mail Notification** and configure:

```
SMTP server: smtp.gmail.com
SMTP Port: 587

Click "Advanced..." button:
☑ Use SMTP Authentication
  User Name: your-gmail@gmail.com
  Password: [App Password - see below]
☑ Use TLS
Default Recipients: your-gmail@gmail.com
Reply-To: your-gmail@gmail.com

Default Subject: $PROJECT_NAME - Build #$BUILD_NUMBER - $BUILD_STATUS
Default Content: (leave as is)
```

#### Section B: E-mail Notification

Scroll down to **E-mail Notification** and configure:

```
SMTP server: smtp.gmail.com

Click "Advanced..." button:
☑ Use SMTP Authentication
  User Name: your-gmail@gmail.com
  Password: [Same App Password]
☑ Use TLS
SMTP Port: 587
Reply-To Address: your-gmail@gmail.com
Charset: UTF-8
```

#### How to Get Gmail App Password 🔐

1. Go to: https://myaccount.google.com/security
2. Enable **2-Step Verification** (if not already enabled)
3. Go to: https://myaccount.google.com/apppasswords
4. Create new app password:
   - App: Mail
   - Device: Other (Custom name) → "Jenkins CI/CD"
5. Copy the 16-character password (no spaces)
6. Use this password in Jenkins (NOT your regular Gmail password)

#### Test Email Configuration

After configuring both sections:
1. Scroll down to **E-mail Notification** section
2. Check "Test configuration by sending test e-mail"
3. Enter your email
4. Click "Test configuration"
5. You should receive a test email

**Save the configuration!**

### Step 3: Configure GitHub Webhook 🔗

1. Go to: https://github.com/iamwasiqueasjid/Moodify-Test
2. Click **Settings** (repo settings, not account)
3. Click **Webhooks** → **Add webhook**
4. Configure:
   ```
   Payload URL: http://13.62.230.213:8080/github-webhook/
   Content type: application/json
   Secret: (leave empty)
   
   Which events would you like to trigger this webhook?
   ○ Just the push event (selected)
   
   ☑ Active
   ```
5. Click **Add webhook**
6. Verify: You should see a green checkmark after the webhook sends a ping

### Step 4: Add Instructor as Collaborator 👥

1. Go to: https://github.com/iamwasiqueasjid/Moodify-Test
2. Click **Settings** → **Collaborators and teams**
3. Click **Add people**
4. Enter instructor's GitHub username or email
5. Select role: **Write** (or as instructed)
6. Click **Add [username] to this repository**
7. Instructor will receive an email invitation

### Step 5: Test the Pipeline 🧪

#### First Test - Manual Trigger

1. Go to Jenkins: http://13.62.230.213:8080
2. Click on **Moodify-CI-CD** job
3. Click **Build Now**
4. Watch the build progress:
   - Click on build #1
   - Click **Console Output**
   - Watch the logs

**Expected stages:**
1. ✅ Checkout (pulls code from GitHub)
2. ✅ Build Docker Image (builds Selenium test container)
3. ✅ Run Selenium Tests (executes 10 test cases)
4. ✅ Publish Test Results (archives screenshots)

**If build succeeds:**
- You should receive a SUCCESS email
- Screenshots should be available under "Build Artifacts"

**If build fails:**
- Check console output for errors
- You should receive a FAILURE email with logs
- Common issues and fixes below

#### Second Test - Automatic Trigger

1. Make a small change to your repository:
   ```powershell
   # From your local machine
   cd "d:\React JS Projects\Moodify"
   
   # Make a small change (e.g., update README)
   git add .
   git commit -m "Test Jenkins webhook automation"
   git push origin main
   ```

2. Check Jenkins - build should start automatically
3. Check your email - you should receive notification

---

## 🐛 Common Issues and Fixes

### Issue 1: "Docker permission denied"
```bash
# SSH into EC2 and run:
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

### Issue 2: "Cannot connect to Docker daemon"
```bash
# Check if Docker is running:
sudo systemctl status docker

# If not running:
sudo systemctl start docker
sudo systemctl enable docker
```

### Issue 3: Tests fail with "Connection refused"
**Problem:** Tests are trying to connect to localhost:3000 but app is not running

**Options:**
1. Deploy your Moodify app somewhere and update test configuration
2. Or modify tests to run against a deployed version
3. Or update `.env` in selenium-tests to point to deployed app

**To update test URL:**
```bash
# SSH into EC2
ssh -i "C:\Users\Work\Downloads\Moodify.pem" ubuntu@ec2-13-62-230-213.eu-north-1.compute.amazonaws.com

# Create .env file for tests
sudo tee /var/lib/jenkins/workspace/Moodify-CI-CD/selenium-tests/.env > /dev/null << 'EOF'
TEST_BASE_URL=https://your-deployed-app.vercel.app
TEST_EMAIL=testuser@example.com
TEST_PASSWORD=testpass123
NEW_USER_EMAIL=newuser@example.com
NEW_USER_PASSWORD=newpass123
EOF
```

### Issue 4: Email not sending
- Verify Gmail App Password is correct (16 characters, no spaces)
- Check that 2-Step Verification is enabled
- Try regenerating the App Password
- Verify SMTP settings exactly match Step 2

### Issue 5: Webhook not triggering
- Check webhook has green checkmark in GitHub
- Verify payload URL is: http://13.62.230.213:8080/github-webhook/ (with trailing slash)
- Check GitHub webhook delivery logs
- Ensure port 8080 is open in EC2 security group

---

## 📋 Verification Checklist

Before submitting your assignment, verify:

- [ ] Jenkins is accessible at http://13.62.230.213:8080
- [ ] Job is configured to pull from GitHub repository
- [ ] Email notifications are configured and tested
- [ ] GitHub webhook is configured with green checkmark
- [ ] Instructor is added as collaborator on GitHub
- [ ] Manual build succeeds and sends email
- [ ] Automatic build triggers on git push
- [ ] Test results and screenshots are archived
- [ ] Docker container runs successfully

---

## 🎥 Demo Preparation

Prepare to demonstrate:

1. **GitHub Repository**
   - Show test code in selenium-tests/
   - Show Jenkinsfile
   - Show Dockerfile
   - Show webhook configuration

2. **Jenkins Pipeline**
   - Show job configuration
   - Trigger a manual build
   - Show build progress
   - Show console output
   - Show build artifacts (screenshots)

3. **Automated Trigger**
   - Make a small commit
   - Push to GitHub
   - Show Jenkins automatically starting build
   - Show email notification received

4. **Test Results**
   - Show all 10 test cases
   - Show screenshots
   - Show email notification with results

---

## 📞 Quick Commands Reference

### Connect to EC2
```powershell
ssh -i "C:\Users\Work\Downloads\Moodify.pem" ubuntu@ec2-13-62-230-213.eu-north-1.compute.amazonaws.com
```

### Check Services
```bash
sudo systemctl status jenkins
sudo systemctl status docker
```

### View Jenkins Logs
```bash
sudo journalctl -u jenkins -f
```

### View Docker Logs
```bash
sudo docker ps -a
sudo docker logs <container-id>
```

### Restart Jenkins
```bash
sudo systemctl restart jenkins
```

### Check Jenkins Job Workspace
```bash
ls -la /var/lib/jenkins/workspace/Moodify-CI-CD/
```

---

## 🎓 Assignment Deliverables

You need to provide:

1. **GitHub Repository URL:** https://github.com/iamwasiqueasjid/Moodify-Test
2. **Jenkins URL:** http://13.62.230.213:8080
3. **Instructor added as collaborator** ✅
4. **Documentation:**
   - ASSIGNMENT_COMPLETION_GUIDE.md
   - JENKINS_SETUP_GUIDE.md
   - This FINAL_SETUP_CHECKLIST.md
5. **Demo showing:**
   - Automated tests running
   - Email notifications
   - Webhook automation

---

## ⏱️ Time Estimate

- Step 1 (Update Job): 5 minutes
- Step 2 (Email Config): 10-15 minutes
- Step 3 (GitHub Webhook): 5 minutes
- Step 4 (Add Collaborator): 2 minutes
- Step 5 (Testing): 10-15 minutes
- **Total: ~40-50 minutes**

---

## 🆘 Need Help?

If you encounter issues:

1. Check console output in Jenkins
2. Check this document for common issues
3. Review logs: `sudo journalctl -u jenkins -f`
4. Check Docker: `sudo docker ps -a`
5. Verify services are running
6. Check email configuration carefully

---

**🚀 Once you complete these steps, your assignment will be fully functional and ready for evaluation!**

**Good luck! 🎉**
