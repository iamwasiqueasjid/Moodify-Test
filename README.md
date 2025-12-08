# Moodify - Mood Tracking Application

A Next.js-based mood tracking application with Firebase authentication and CI/CD pipeline using Jenkins.

## 🚀 Features

- User authentication (Login/Signup)
- Daily mood tracking
- Mood calendar visualization
- Firebase Firestore integration
- Responsive design
- Automated testing with Selenium
- CI/CD pipeline with Jenkins

## 🛠 Tech Stack

- **Frontend**: Next.js, React, TailwindCSS
- **Backend**: Firebase (Authentication + Firestore)
- **Testing**: Selenium, Python, Pytest
- **CI/CD**: Jenkins on AWS EC2
- **Containerization**: Docker

## 📋 Getting Started

### Prerequisites
- Node.js 18+
- npm or yarn
- Firebase account
- (Optional) Docker for testing

### Installation

1. Clone the repository:
```bash
git clone https://github.com/iamwasiqueasjid/Moodify-Test.git
cd Moodify-Test
```

2. Install dependencies:
```bash
npm install
```

3. Configure Firebase:
   - Create a Firebase project
   - Add your Firebase config to `firebase.js`
   - Set up Firestore database
   - Enable Authentication (Email/Password)

4. Run the development server:
```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser.

## 🧪 Testing

### Run Selenium Tests Locally
```bash
cd selenium-tests
pip install -r requirements.txt
python run_all_tests.py
```

### Run Tests in Docker
```bash
docker build -t moodify-selenium-tests .
docker run --rm -v $(pwd)/selenium-tests/screenshots:/app/screenshots moodify-selenium-tests
```

See `selenium-tests/README.md` for detailed testing information.

## 🔄 CI/CD Pipeline

This project uses Jenkins for automated testing:

- **Trigger**: Automatic on GitHub push via webhook
- **Build**: Docker container with test environment
- **Test**: Selenium test suite execution
- **Notify**: Email with test results and screenshots
- **Artifacts**: Screenshots archived in Jenkins

### Jenkins Setup
See `JENKINS_SETUP_GUIDE.md` for complete Jenkins setup guide.  
See `QUICK_REFERENCE.md` for quick commands and credentials.

**Jenkins URL**: http://ec2-13-62-230-213.eu-north-1.compute.amazonaws.com:8080

### Pipeline Features
- ✅ Automated builds on GitHub push via webhook
- ✅ Dockerized test execution
- ✅ Email notifications to collaborator who pushed
- ✅ Screenshot artifacts
- ✅ HTML test reports

### Quick Deploy
```powershell
# Connect tEC2
ssh -i "C:\Users\Work\Downloads\Moodify.pem" ubuntu@ec2-13-62-230-213.eu-north-1.compute.amazonaws.com

# View Jenkins password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

## 📁 Project Structure

```
Moodify/
├── app/                    # Next.js app directory
├── components/             # React components
├── context/               # React context (Auth)
├── utils/                 # Utility functions
├── selenium-tests/        # Automated test suite
├── Dockerfile            # Docker configuration for tests
├── Jenkinsfile           # Jenkins pipeline definition
├── firebase.js           # Firebase configuration
└── README.md             # This file
```

## 📚 Documentation

- `SETUP_INSTRUCTIONS.md` - Complete Jenkins CI/CD setup guide
- `QUICK_REFERENCE.md` - Quick command reference
- `JENKINS_SETUP.md` - Jenkins pipeline documentation
- `selenium-tests/README.md` - Testing documentation

## 🤝 Contributing

This is an academic project. For collaboration:
1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

## 📧 Contact

For questions or issues:
- GitHub: [@iamwasiqueasjid](https://github.com/iamwasiqueasjid)
- Repository: [Moodify-Test](https://github.com/iamwasiqueasjid/Moodify-Test)

## 📄 License

This project is part of an academic assignment.

---

## Next.js Resources

- [Next.js Documentation](https://nextjs.org/docs)
- [Learn Next.js](https://nextjs.org/learn)
- [Next.js GitHub](https://github.com/vercel/next.js/)

## Deploy on Vercel

The easiest way to deploy your Next.js app is to use the [Vercel Platform](https://vercel.com/new?utm_medium=default-template&filter=next.js&utm_source=create-next-app&utm_campaign=create-next-app-readme) from the creators of Next.js.

Check out our [Next.js deployment documentation](https://nextjs.org/docs/deployment) for more details.
