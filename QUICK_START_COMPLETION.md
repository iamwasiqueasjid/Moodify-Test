# 🚀 AUTOMATED COMPLETION GUIDE - Step by Step

This guide will help you complete the Jenkins CI/CD assignment in **15-20 minutes**.

---

## 📍 Current Status

✅ **Completed:**
- EC2 instance running with Jenkins
- Docker installed and configured
- Jenkins job created and configured to use GitHub SCM
- 10 Selenium test cases ready
- Jenkinsfile with complete pipeline
- Dockerfile with test environment

⚠️ **Remaining Tasks:**
1. Configure email notifications
2. Set up GitHub webhook
3. Test the pipeline
4. Add instructor as collaborator

---

## 🎯 STEP 1: Configure Email Notifications (5-10 minutes)

### Option A: Automated Script (Recommended)

```bash
# 1. SSH into EC2
ssh -i "C:\Users\Work\Downloads\Moodify.pem" ubuntu@ec2-13-62-230-213.eu-north-1.compute.amazonaws.com

# 2. Upload and run the email configuration script
# (From your local machine first)
exit

# From local PowerShell:
scp -i "C:\Users\Work\Downloads\Moodify.pem" "d:\React JS Projects\Moodify\configure-email.sh" ubuntu@ec2-13-62-230-213.eu-north-1.compute.amazonaws.com:~/

# SSH back in
ssh -i "C:\Users\Work\Downloads\Moodify.pem" ubuntu@ec2-13-62-230-213.eu-north-1.compute.amazonaws.com

# Run the script
chmod +x configure-email.sh
./configure-email.sh
```

**When prompted:**
- Gmail address: `your-email@gmail.com`
- Gmail App Password: `your-16-char-password`
- SMTP server: Press Enter (uses default: smtp.gmail.com)
- SMTP port: Press Enter (uses default: 587)

### How to Get Gmail App Password:

1. Go to: https://myaccount.google.com/security
2. Enable **2-Step Verification** (if not enabled)
3. Go to: https://myaccount.google.com/apppasswords
4. Create new:
   - Select app: **Mail**
   - Select device: **Other** → type "Jenkins"
5. Copy the 16-character password (no spaces)

### Option B: Manual Configuration via Jenkins UI

1. Open: http://13.62.230.213:8080
2. Login with your credentials
3. Go to: **Manage Jenkins** → **Configure System**
4. Find **Extended E-mail Notification** section:
   - SMTP server: `smtp.gmail.com`
   - SMTP Port: `587`
   - Click **Advanced**:
     - ☑ Use SMTP Authentication
     - User Name: `your-email@gmail.com`
     - Password: `[Your App Password]`
     - ☑ Use TLS
     - Reply-To Address: `your-email@gmail.com`
5. Scroll to **E-mail Notification** section:
   - SMTP server: `smtp.gmail.com`
   - Click **Advanced**:
     - ☑ Use SMTP Authentication
     - User Name: `your-email@gmail.com`
     - Password: `[Same App Password]`
     - ☑ Use TLS
     - SMTP Port: `587`
6. Click **Save**

---

## 🎯 STEP 2: Configure GitHub Webhook (2-3 minutes)

### Instructions:

1. **Open GitHub Repository:**
   ```
   https://github.com/iamwasiqueasjid/Moodify-Test
   ```

2. **Navigate to Settings:**
   - Click **Settings** tab (repository settings)
   - Click **Webhooks** in left sidebar
   - Click **Add webhook** button

3. **Configure Webhook:**
   ```
   Payload URL: http://13.62.230.213:8080/github-webhook/
   Content type: application/json
   Secret: (leave empty)
   
   Which events would you like to trigger this webhook?
   ○ Just the push event (select this)
   
   ☑ Active (check this)
   ```

4. **Save:**
   - Click **Add webhook**
   - Wait for GitHub to send a ping
   - You should see a **green checkmark** ✓

**Verification:**
- Click on the webhook you just created
- Go to **Recent Deliveries** tab
- You should see a successful ping delivery (green checkmark)

---

## 🎯 STEP 3: Add Instructor as Collaborator (1 minute)

1. **Open GitHub Repository:**
   ```
   https://github.com/iamwasiqueasjid/Moodify-Test
   ```

2. **Navigate to Settings:**
   - Click **Settings** tab
   - Click **Collaborators and teams**
   - Click **Add people** button

3. **Add Collaborator:**
   - Enter instructor's GitHub username or email
   - Select permission level: **Write**
   - Click **Add [username] to this repository**

4. **Verification:**
   - Instructor will receive an email invitation
   - They can accept and then push to trigger pipeline

---

## 🎯 STEP 4: Test the Pipeline (5-10 minutes)

### Test 1: Manual Build

1. **Open Jenkins:**
   ```
   http://13.62.230.213:8080
   ```

2. **Login** and click on **Moodify-CI-CD** job

3. **Click "Build Now"**

4. **Monitor Build:**
   - Click on build #1 (or latest build number)
   - Click **Console Output**
   - Watch the progress

**Expected Output:**
```
✓ Stage: Checkout (pulls from GitHub)
✓ Stage: Build Docker Image (builds test container)
✓ Stage: Run Selenium Tests (runs 10 tests)
✓ Stage: Publish Test Results (archives screenshots)
```

**Build Time:** ~5-10 minutes for first build (downloads dependencies)

5. **Check Email:**
   - You should receive an email with build results
   - Email will include links to screenshots and artifacts

6. **View Artifacts:**
   - In Jenkins build page, click **Build Artifacts**
   - Navigate to `selenium-tests/screenshots/`
   - View test screenshots

### Test 2: Automated Build (Webhook Trigger)

1. **Make a Small Change:**

```powershell
# From your local machine
cd "d:\React JS Projects\Moodify"

# Edit README or any file
git add .
git commit -m "Test Jenkins webhook - automated build"
git push origin main
```

2. **Check Jenkins:**
   - Jenkins should automatically start a new build
   - Build should appear within 10-30 seconds

3. **Check Email:**
   - You should receive another email notification

---

## 🐛 Troubleshooting Common Issues

### Issue 1: Build Fails - "Cannot connect to Docker daemon"

**Solution:**
```bash
ssh -i "C:\Users\Work\Downloads\Moodify.pem" ubuntu@ec2-13-62-230-213.eu-north-1.compute.amazonaws.com
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
# Wait 30 seconds, then retry build
```

### Issue 2: Tests Fail - "Connection refused" or "Cannot connect to localhost:3000"

**Problem:** Tests are trying to connect to your local app, but it's not accessible from EC2.

**Quick Fix - Update Test Configuration:**

```bash
# SSH into EC2
ssh -i "C:\Users\Work\Downloads\Moodify.pem" ubuntu@ec2-13-62-230-213.eu-north-1.compute.amazonaws.com

# Create/update .env file for tests
sudo mkdir -p /var/lib/jenkins/workspace/Moodify-CI-CD/selenium-tests
sudo tee /var/lib/jenkins/workspace/Moodify-CI-CD/selenium-tests/.env > /dev/null << 'EOF'
# Use a deployed version of your app or mock tests
TEST_BASE_URL=http://localhost:3000
TEST_EMAIL=testuser@example.com
TEST_PASSWORD=testpass123
NEW_USER_EMAIL=newuser@example.com
NEW_USER_PASSWORD=newpass123
EOF
```

**Alternative:** Deploy your app to Vercel/Netlify and update TEST_BASE_URL

### Issue 3: Email Not Sending

**Check:**
1. Gmail App Password is correct (16 chars, no spaces)
2. 2-Step Verification is enabled in Gmail
3. Try regenerating the App Password
4. Check Jenkins logs: `sudo journalctl -u jenkins -n 100`

### Issue 4: Webhook Not Triggering

**Check:**
1. Webhook has green checkmark in GitHub
2. Payload URL ends with `/github-webhook/` (trailing slash is important)
3. Port 8080 is open in AWS Security Group:
   - Go to AWS Console → EC2 → Security Groups
   - Check inbound rules include: Custom TCP, Port 8080, Source 0.0.0.0/0

---

## ✅ Final Verification Checklist

Before submitting, verify:

- [ ] Jenkins is accessible: http://13.62.230.213:8080
- [ ] Job configuration shows: "Pipeline script from SCM"
- [ ] Manual build succeeds
- [ ] Email notification received for manual build
- [ ] GitHub webhook shows green checkmark
- [ ] Automated build triggered by git push
- [ ] Email received for automated build
- [ ] Test artifacts and screenshots are archived
- [ ] Instructor added as GitHub collaborator
- [ ] All 10 test cases visible in console output

---

## 📊 Expected Test Results

Your pipeline should execute these **10 test cases**:

### Authentication Tests (6):
1. ✓ test_01_homepage_loads_successfully
2. ✓ test_02_login_page_navigation
3. ✓ test_03_login_with_empty_fields
4. ✓ test_04_login_with_invalid_email
5. ✓ test_05_login_with_short_password
6. ✓ test_06_login_with_valid_credentials

### Dashboard Tests (3):
7. ✓ test_07_dashboard_statistics_display
8. ✓ test_08_mood_selection_and_data_persistence
9. ✓ test_09_calendar_component_display

### Navigation Tests (1):
10. ✓ test_10_logout_functionality

---

## 📧 Email Notification Preview

**Success Email:**
```
Subject: ✅ Jenkins Build #1 - SUCCESS - Moodify-CI-CD

Build Information:
- Project: Moodify-CI-CD
- Build Number: #1
- Pushed by: Your Name <your-email@gmail.com>
- Status: All tests passed ✓
- Screenshots captured: 10

Quick Links:
📊 View Build Details
📁 View Artifacts
📷 View Screenshots
📝 View Console Output
```

**Failure Email:**
```
Subject: ❌ Jenkins Build #1 - FAILED - Moodify-CI-CD

Build Information:
- Project: Moodify-CI-CD
- Build Number: #1
- Pushed by: Your Name <your-email@gmail.com>
- Status: Tests failed ✗

Console log attached
Screenshots attached for debugging
```

---

## 🎥 Demo Preparation

For your assignment demo, prepare to show:

1. **GitHub Repository:**
   - Selenium test code
   - Jenkinsfile
   - Dockerfile
   - Webhook configuration (Settings → Webhooks)

2. **Jenkins Dashboard:**
   - Job configuration
   - Build history
   - Console output of successful build
   - Build artifacts (screenshots)

3. **Live Demo:**
   - Make a small commit
   - Push to GitHub
   - Show Jenkins automatically detecting and building
   - Show email notification

4. **Email Notifications:**
   - Show received emails with build results
   - Show HTML formatting
   - Show attached screenshots

---

## 📞 Quick Reference

### SSH Connection:
```bash
ssh -i "C:\Users\Work\Downloads\Moodify.pem" ubuntu@ec2-13-62-230-213.eu-north-1.compute.amazonaws.com
```

### Jenkins URL:
```
http://13.62.230.213:8080
```

### GitHub Repository:
```
https://github.com/iamwasiqueasjid/Moodify-Test
```

### Useful Commands:
```bash
# Check Jenkins status
sudo systemctl status jenkins

# View Jenkins logs
sudo journalctl -u jenkins -f

# Restart Jenkins
sudo systemctl restart jenkins

# Check Docker
sudo docker ps -a
sudo systemctl status docker

# View job workspace
ls -la /var/lib/jenkins/workspace/Moodify-CI-CD/
```

---

## ⏱️ Time Breakdown

- **Email Configuration:** 5-10 minutes
- **GitHub Webhook:** 2-3 minutes
- **Add Collaborator:** 1 minute
- **First Build Test:** 5-10 minutes
- **Automated Test:** 2-3 minutes
- **Troubleshooting Buffer:** 5 minutes
- **Total:** ~20-35 minutes

---

## 🎓 Assignment Requirements Met

✅ **Selenium Test Cases:** 10 comprehensive tests written in Python
✅ **Jenkins Pipeline:** Fully automated CI/CD pipeline with 4 stages
✅ **AWS EC2:** Jenkins running on EC2 instance
✅ **Docker Integration:** Tests run in containerized environment using custom Dockerfile
✅ **GitHub Repository:** Code stored and version controlled
✅ **GitHub Webhook:** Automatic pipeline triggers on push
✅ **Email Notifications:** HTML emails to collaborators with results
✅ **Test Results:** Screenshots and artifacts archived
✅ **Collaborator Access:** Instructor can trigger pipeline

---

## 🚀 Ready to Complete!

Follow the 4 steps above in order:
1. Configure Email (10 min)
2. Setup Webhook (3 min)
3. Add Collaborator (1 min)
4. Test Pipeline (10 min)

**Total time: ~25 minutes**

Good luck with your assignment! 🎉

---

## 📚 Additional Documentation

All detailed documentation is available in:
- `ASSIGNMENT_COMPLETION_GUIDE.md` - Complete overview
- `JENKINS_SETUP_GUIDE.md` - Detailed Jenkins setup
- `FINAL_SETUP_CHECKLIST.md` - Step-by-step checklist
- `selenium-tests/README.md` - Test documentation

---

**Questions or issues? Check the troubleshooting section or review the console output in Jenkins.**
