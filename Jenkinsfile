pipeline {
    agent any
    
    environment {
        DEPLOY_PATH = '.'
        ADMIN_EMAIL = 'wasiquemahmood786@gmail.com'
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code from GitHub...'
                checkout scm
            }
        }

        stage('Create Env File') {
             steps {
                 script {
                     // Writing env vars to .env file for docker compose to use
                     writeFile file: '.env', text: """
NEXT_PUBLIC_API_KEY=${env.NEXT_PUBLIC_API_KEY}
NEXT_PUBLIC_AUTH_DOMAIN=${env.NEXT_PUBLIC_AUTH_DOMAIN}
NEXT_PUBLIC_PROJECT_ID=${env.NEXT_PUBLIC_PROJECT_ID}
NEXT_PUBLIC_STORAGE_BUCKET=${env.NEXT_PUBLIC_STORAGE_BUCKET}
NEXT_PUBLIC_MESSAGING_SENDER_ID=${env.NEXT_PUBLIC_MESSAGING_SENDER_ID}
NEXT_PUBLIC_APP_ID=${env.NEXT_PUBLIC_APP_ID}
"""
                 }
             }
        }
        
        stage('Get Committer Email') {
            steps {
                script {
                    env.GIT_COMMITTER_EMAIL = sh(
                        script: 'git log -1 --pretty=format:"%ae"',
                        returnStdout: true
                    ).trim()
                    env.GIT_COMMITTER_NAME = sh(
                        script: 'git log -1 --pretty=format:"%an"',
                        returnStdout: true
                    ).trim()
                    echo "Commit by: ${env.GIT_COMMITTER_NAME} (${env.GIT_COMMITTER_EMAIL})"
                }
            }
        }
        
        stage('Clean Workspace') {
            steps {
                echo 'Cleaning old test artifacts...'
                // Cleaning up using Docker to avoid permission issues
                sh '''
                    docker run --rm -v "${PWD}/SeleniumTests:/app" -w /app alpine rm -rf target || true
                '''
            }
        }
        
        stage('Deploy Locally') {
            steps {
                script {
                    echo 'Deploying on Jenkins EC2 instance (localhost)...'
                    
                    sh '''
                        docker compose down || true
                        docker compose build --no-cache
                        docker compose up -d
                        echo "Deployment completed successfully!"
                        echo "Waiting for services to start..."
                        sleep 30
                    '''
                }
            }
        }
        
        stage('Verify Deployment') {
            steps {
                script {
                    echo 'Verifying deployment...'
                    
                    sh '''
                        docker compose ps
                        echo "Waiting additional time for services..."
                        sleep 15
                    '''
                }
            }
        }
        
        stage('Run Selenium Tests') {
            steps {
                script {
                    echo 'Running Selenium automated tests...'
                    
                    sh '''
                        docker run --rm \
                            --network host \
                            -v ${WORKSPACE}/SeleniumTests:/app \
                            -w /app \
                            markhobson/maven-chrome:latest \
                            mvn clean test -Dbase.url=http://localhost:3000
                    '''
                }
            }
            post {
                always {
                    junit allowEmptyResults: true, testResults: 'SeleniumTests/target/surefire-reports/*.xml'
                    archiveArtifacts allowEmptyArchive: true, artifacts: 'SeleniumTests/target/surefire-reports/**/*'
                    
                    sh '''
                        docker run --rm -v "${PWD}/SeleniumTests:/app" -w /app alpine rm -rf target || true
                    '''
                }
            }
        }
    }
    
    post {
        success {
            script {
                echo 'Pipeline executed successfully!'
                echo 'Application deployed and all tests passed!'
                
                def recipientEmail = env.GIT_COMMITTER_EMAIL ?: env.ADMIN_EMAIL
                
                mail to: recipientEmail,
                     subject: "SUCCESS: Jenkins Build ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                     body: """Build Successful!

Triggered by: ${env.GIT_COMMITTER_NAME} (${env.GIT_COMMITTER_EMAIL})

Job: ${env.JOB_NAME}
Build Number: ${env.BUILD_NUMBER}
Status: SUCCESS

Test Results: 30 Tests Executed
  - All tests PASSED

View Build: ${env.BUILD_URL}
View Test Report: ${env.BUILD_URL}testReport/"""
            }
        }
        failure {
            script {
                echo 'Pipeline failed. Check the logs for details.'
                
                def recipientEmail = env.GIT_COMMITTER_EMAIL ?: env.ADMIN_EMAIL
                
                mail to: recipientEmail,
                     subject: "FAILED: Jenkins Build ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                     body: """Build Failed!

Triggered by: ${env.GIT_COMMITTER_NAME} (${env.GIT_COMMITTER_EMAIL})

Job: ${env.JOB_NAME}
Build Number: ${env.BUILD_NUMBER}
Status: FAILURE

Some tests may have FAILED. Please check the test report for details.

View Build: ${env.BUILD_URL}
View Test Report: ${env.BUILD_URL}testReport/"""
            }
        }
        always {
            echo 'Pipeline completed.'
        }
    }
}
