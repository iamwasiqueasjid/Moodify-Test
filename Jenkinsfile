pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'moodify-selenium-tests'
        RECIPIENT_EMAIL = ''
        PUSHER_NAME = ''
        PUSHER_EMAIL = ''
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code from GitHub...'
                checkout scm
                
                script {
                    // Extract pusher information from Git
                    try {
                        // Get the email of the person who pushed
                        PUSHER_EMAIL = sh(
                            script: "git --no-pager show -s --format='%ae' HEAD",
                            returnStdout: true
                        ).trim()
                        
                        // Get the name of the person who pushed
                        PUSHER_NAME = sh(
                            script: "git --no-pager show -s --format='%an' HEAD",
                            returnStdout: true
                        ).trim()
                        
                        // Set recipient email
                        env.RECIPIENT_EMAIL = PUSHER_EMAIL
                        env.PUSHER_NAME = PUSHER_NAME
                        
                        echo "Build triggered by: ${PUSHER_NAME} <${PUSHER_EMAIL}>"
                    } catch (Exception e) {
                        echo "Failed to extract Git user info: ${e.message}"
                        env.RECIPIENT_EMAIL = 'default@example.com'
                        env.PUSHER_NAME = 'Unknown'
                    }
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building Docker image for Selenium tests...'
                    sh """
                        docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} \
                        -t ${DOCKER_IMAGE}:latest \
                        --build-arg BUILDKIT_INLINE_CACHE=1 .
                    """
                }
            }
        }
        
        stage('Run Selenium Tests') {
            steps {
                script {
                    echo 'Running Selenium tests in Docker container...'
                    // Run tests and capture exit code
                    def testStatus = sh(
                        script: """
                            docker run --rm \
                            -v \$(pwd)/selenium-tests/screenshots:/app/screenshots \
                            -v \$(pwd)/test-results:/app/test-results \
                            ${DOCKER_IMAGE}:latest
                        """,
                        returnStatus: true
                    )
                    
                    if (testStatus != 0) {
                        echo "Tests failed with exit code: ${testStatus}"
                        error("Selenium tests failed")
                    }
                }
            }
        }
        
        stage('Publish Test Results') {
            steps {
                script {
                    echo 'Publishing test results...'
                    
                    // Archive screenshots
                    archiveArtifacts artifacts: 'selenium-tests/screenshots/**/*', 
                                     allowEmptyArchive: true,
                                     fingerprint: true
                    
                    // Archive test results if they exist
                    archiveArtifacts artifacts: 'test-results/**/*', 
                                     allowEmptyArchive: true,
                                     fingerprint: true
                    
                    // Count test files and screenshots
                    def screenshotCount = sh(
                        script: 'find selenium-tests/screenshots -type f 2>/dev/null | wc -l || echo 0',
                        returnStdout: true
                    ).trim()
                    
                    echo "Archived ${screenshotCount} screenshots"
                }
            }
        }
    }
    
    post {
        always {
            echo 'Cleaning up Docker resources...'
            script {
                // Clean up old Docker images to save space
                sh """
                    docker image prune -f --filter 'until=24h'
                    docker images | grep '${DOCKER_IMAGE}' | grep -v 'latest' | awk '{if (NR>3) print \$3}' | xargs -r docker rmi || true
                """
            }
        }
        
        success {
            echo 'Tests passed successfully!'
            script {
                // Count screenshots
                def screenshotCount = sh(
                    script: 'find selenium-tests/screenshots -type f 2>/dev/null | wc -l || echo 0',
                    returnStdout: true
                ).trim()
                
                emailext (
                    subject: "✅ Jenkins Build #${BUILD_NUMBER} - SUCCESS - ${JOB_NAME}",
                    body: """
                        <!DOCTYPE html>
                        <html>
                        <head>
                            <style>
                                body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
                                .header { background-color: #4CAF50; color: white; padding: 20px; text-align: center; }
                                .content { padding: 20px; }
                                .info-box { background-color: #f4f4f4; border-left: 4px solid #4CAF50; padding: 10px; margin: 10px 0; }
                                .success { color: #4CAF50; }
                                .footer { background-color: #f4f4f4; padding: 10px; text-align: center; font-size: 12px; }
                                a { color: #2196F3; text-decoration: none; }
                                a:hover { text-decoration: underline; }
                            </style>
                        </head>
                        <body>
                            <div class="header">
                                <h1>✅ Build Successful</h1>
                                <p>All Selenium tests passed!</p>
                            </div>
                            
                            <div class="content">
                                <h2>Build Information</h2>
                                <div class="info-box">
                                    <p><strong>Project:</strong> ${JOB_NAME}</p>
                                    <p><strong>Build Number:</strong> #${BUILD_NUMBER}</p>
                                    <p><strong>Pushed by:</strong> ${env.PUSHER_NAME} &lt;${env.RECIPIENT_EMAIL}&gt;</p>
                                    <p><strong>Branch:</strong> ${env.GIT_BRANCH ?: 'Unknown'}</p>
                                    <p><strong>Build Duration:</strong> ${currentBuild.durationString.replace(' and counting', '')}</p>
                                    <p><strong>Timestamp:</strong> ${new Date()}</p>
                                </div>
                                
                                <h2>Test Results</h2>
                                <div class="info-box">
                                    <p class="success"><strong>Status:</strong> All tests passed ✓</p>
                                    <p><strong>Screenshots captured:</strong> ${screenshotCount}</p>
                                    <p><strong>Test artifacts:</strong> Available in Jenkins</p>
                                </div>
                                
                                <h2>Quick Links</h2>
                                <p>
                                    📊 <a href="${BUILD_URL}">View Build Details</a><br>
                                    📁 <a href="${BUILD_URL}artifact/">View Artifacts</a><br>
                                    📷 <a href="${BUILD_URL}artifact/selenium-tests/screenshots/">View Screenshots</a><br>
                                    📝 <a href="${BUILD_URL}console">View Console Output</a>
                                </p>
                            </div>
                            
                            <div class="footer">
                                <p>This is an automated message from Jenkins CI/CD Pipeline</p>
                                <p>Moodify - Automated Testing System</p>
                            </div>
                        </body>
                        </html>
                    """,
                    to: "${env.RECIPIENT_EMAIL}",
                    mimeType: 'text/html',
                    attachmentsPattern: 'selenium-tests/screenshots/**/*.png',
                    attachLog: false
                )
            }
        }
        
        failure {
            echo 'Tests failed!'
            script {
                // Count screenshots
                def screenshotCount = sh(
                    script: 'find selenium-tests/screenshots -type f 2>/dev/null | wc -l || echo 0',
                    returnStdout: true
                ).trim()
                
                emailext (
                    subject: "❌ Jenkins Build #${BUILD_NUMBER} - FAILED - ${JOB_NAME}",
                    body: """
                        <!DOCTYPE html>
                        <html>
                        <head>
                            <style>
                                body { font-family: Arial, sans-serif; line-height: 1.6; color: #333; }
                                .header { background-color: #f44336; color: white; padding: 20px; text-align: center; }
                                .content { padding: 20px; }
                                .info-box { background-color: #f4f4f4; border-left: 4px solid #f44336; padding: 10px; margin: 10px 0; }
                                .failure { color: #f44336; }
                                .footer { background-color: #f4f4f4; padding: 10px; text-align: center; font-size: 12px; }
                                a { color: #2196F3; text-decoration: none; }
                                a:hover { text-decoration: underline; }
                            </style>
                        </head>
                        <body>
                            <div class="header">
                                <h1>❌ Build Failed</h1>
                                <p>One or more tests failed</p>
                            </div>
                            
                            <div class="content">
                                <h2>Build Information</h2>
                                <div class="info-box">
                                    <p><strong>Project:</strong> ${JOB_NAME}</p>
                                    <p><strong>Build Number:</strong> #${BUILD_NUMBER}</p>
                                    <p><strong>Pushed by:</strong> ${env.PUSHER_NAME} &lt;${env.RECIPIENT_EMAIL}&gt;</p>
                                    <p><strong>Branch:</strong> ${env.GIT_BRANCH ?: 'Unknown'}</p>
                                    <p><strong>Build Duration:</strong> ${currentBuild.durationString.replace(' and counting', '')}</p>
                                    <p><strong>Timestamp:</strong> ${new Date()}</p>
                                </div>
                                
                                <h2>Test Results</h2>
                                <div class="info-box">
                                    <p class="failure"><strong>Status:</strong> Tests failed ✗</p>
                                    <p><strong>Screenshots captured:</strong> ${screenshotCount}</p>
                                    <p>Please check the console output and screenshots for details.</p>
                                </div>
                                
                                <h2>Quick Links</h2>
                                <p>
                                    📊 <a href="${BUILD_URL}">View Build Details</a><br>
                                    📁 <a href="${BUILD_URL}artifact/">View Artifacts</a><br>
                                    📷 <a href="${BUILD_URL}artifact/selenium-tests/screenshots/">View Screenshots</a><br>
                                    📝 <a href="${BUILD_URL}console">View Console Output</a>
                                </p>
                                
                                <h2>Next Steps</h2>
                                <p>
                                    1. Review the console output to identify the failing test<br>
                                    2. Check screenshots for visual evidence of failures<br>
                                    3. Fix the issue and push again to re-trigger the build
                                </p>
                            </div>
                            
                            <div class="footer">
                                <p>This is an automated message from Jenkins CI/CD Pipeline</p>
                                <p>Moodify - Automated Testing System</p>
                            </div>
                        </body>
                        </html>
                    """,
                    to: "${env.RECIPIENT_EMAIL}",
                    mimeType: 'text/html',
                    attachmentsPattern: 'selenium-tests/screenshots/**/*.png',
                    attachLog: true
                )
            }
        }
    }
}
