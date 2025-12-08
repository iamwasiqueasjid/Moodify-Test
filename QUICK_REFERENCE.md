# 🚀 Jenkins CI/CD - Quick Reference

## 🔑 Access Information

### EC2 Instance
```bash
SSH: ssh -i "C:\Users\Work\Downloads\Moodify.pem" ubuntu@ec2-13-62-230-213.eu-north-1.compute.amazonaws.com
Public IP: 13.62.230.213
```

### Jenkins
```
URL: http://13.62.230.213:8080
Initial Admin Password: 5996af8d31a0495f8953222702dd46ba
```

### Email Configuration
```
SMTP Server: smtp.gmail.com
SMTP Port: 465 (SSL)
Username: wasiquemahmood786@gmail.com
App Password: bqccjacvjdecsxne
```

### GitHub
```
Repository: https://github.com/iamwasiqueasjid/Moodify-Test
Webhook URL: http://13.62.230.213:8080/github-webhook/
```

---

## 📝 Quick Commands

### EC2 Management
```bash
# Check Jenkins status
sudo systemctl status jenkins

# Restart Jenkins
sudo systemctl restart jenkins

# Check Jenkins logs
sudo journalctl -u jenkins -f

# Check Docker status
sudo systemctl status docker

# View Jenkins initial password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

### Docker Commands
```bash
# List Docker images
docker images

# List running containers
docker ps

# View Docker logs
docker logs <container-id>

# Clean up Docker
docker system prune -a -f

# Build test image manually
cd /var/lib/jenkins/workspace/Moodify-CI-CD
docker build -t moodify-selenium-tests .
```

### Jenkins Workspace
```bash
# Navigate to workspace
cd /var/lib/jenkins/workspace/Moodify-CI-CD

# View build artifacts
ls -la selenium-tests/screenshots/

# View test results
ls -la test-results/
```

---

## 🔧 Configuration Steps (In Order)

### 1. Access Jenkins (FIRST TIME)
1. Open: http://13.62.230.213:8080
2. Enter password: `5996af8d31a0495f8953222702dd46ba`
3. Install suggested plugins
4. Create admin user

### 2. Configure Email
**Manage Jenkins → Configure System**

**E-mail Notification:**
- SMTP server: `smtp.gmail.com`
- Click Advanced
- ☑ Use SMTP Authentication
- User: `wasiquemahmood786@gmail.com`
- Password: `bqccjacvjdecsxne`
- ☑ Use SSL
- Port: `465`

**Extended E-mail Notification:**
- Same settings as above
- Default Content Type: `HTML (text/html)`

### 3. Create Pipeline Job
1. **New Item** → Name: `Moodify-CI-CD` → **Pipeline**
2. **GitHub project**: `https://github.com/iamwasiqueasjid/Moodify-Test/`
3. **Build Triggers**: ☑ GitHub hook trigger for GITScm polling
4. **Pipeline**:
   - Definition: Pipeline script from SCM
   - SCM: Git
   - URL: `https://github.com/iamwasiqueasjid/Moodify-Test.git`
   - Branch: `*/main`
   - Script Path: `Jenkinsfile`

### 4. Configure GitHub Webhook
**GitHub Repo → Settings → Webhooks → Add webhook**
- Payload URL: `http://13.62.230.213:8080/github-webhook/`
- Content type: `application/json`
- Events: Just the push event
- Active: ☑

---

## ✅ Testing Checklist

- [ ] Access Jenkins web interface
- [ ] Complete initial setup with plugins
- [ ] Configure email notifications
- [ ] Test email configuration
- [ ] Create pipeline job
- [ ] Run manual build (Build Now)
- [ ] Configure GitHub webhook
- [ ] Test webhook (push to repo)
- [ ] Verify email received
- [ ] Check screenshots in artifacts

---

## 🐛 Common Issues

### Jenkins won't start
```bash
sudo systemctl restart jenkins
sudo journalctl -u jenkins -n 50
```

### Docker permission denied
```bash
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

### Email not sending
1. Verify SMTP settings
2. Test with "Test configuration"
3. Check logs: `sudo tail -f /var/log/jenkins/jenkins.log`

### Webhook not triggering
1. Check webhook delivery in GitHub
2. Verify URL: `http://13.62.230.213:8080/github-webhook/`
3. Check Jenkins logs

---

## 📊 Pipeline Stages

1. **Checkout** - Pull code from GitHub
2. **Build Docker Image** - Create test container
3. **Run Selenium Tests** - Execute tests in container
4. **Publish Test Results** - Archive screenshots
5. **Email Notification** - Send results to pusher

---

## 📧 Email Template

**Success Email:**
- ✅ Build status
- 👤 Pusher name and email
- 🌳 Branch information
- ⏱️ Build duration
- 📊 Test results
- 📷 Screenshots (attached)
- 🔗 Links to Jenkins

**Failure Email:**
- Same as success + error details
- Console output attached

---

## 🔐 Security Notes

> Make sure port 8080 is open in AWS Security Group!

**AWS Console → EC2 → Security Groups → Edit Inbound Rules:**
- Type: Custom TCP
- Port: 8080
- Source: 0.0.0.0/0 (or your IP)

---

## 📚 Documentation Files

- `JENKINS_SETUP_GUIDE.md` - Complete step-by-step setup
- `QUICK_REFERENCE.md` - This file (quick commands)
- `Jenkinsfile` - Pipeline definition
- `Dockerfile` - Test container configuration
- `ec2-setup.sh` - Automated EC2 setup
- `jenkins-config.sh` - Jenkins configuration guide

---

**Last Updated**: December 2024  
**For**: Cloud Computing Assignment - Jenkins CI/CD
