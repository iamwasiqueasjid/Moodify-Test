pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'moodify-selenium-tests'
        RECIPIENT_EMAIL = "${env.GIT_COMMITTER_EMAIL ?: 'default@example.com'}"
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code from GitHub...'
                checkout scm
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building Docker image for Selenium tests...'
                    sh "docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} -t ${DOCKER_IMAGE}:latest ."
                }
            }
        }
        
        stage('Run Selenium Tests') {
            steps {
                script {
                    echo 'Running Selenium tests in Docker container...'
                    sh """
                        docker run --rm \
                        -v \$(pwd)/selenium-tests/screenshots:/app/screenshots \
                        -v \$(pwd)/test-results:/app/test-results \
                        ${DOCKER_IMAGE}:latest
                    """
                }
            }
        }
    }
    
    post {
        always {
            echo 'Cleaning up...'
            script {
                // Archive test results and screenshots
                archiveArtifacts artifacts: 'selenium-tests/screenshots/**/*', allowEmptyArchive: true
                archiveArtifacts artifacts: 'test-results/**/*', allowEmptyArchive: true
                
                // Clean up old Docker images
                sh "docker image prune -f"
            }
        }
        
        success {
            echo 'Tests passed successfully!'
            emailext (
                subject: "Jenkins Build #${BUILD_NUMBER} - SUCCESS",
                body: """
                    <h2>Build Success</h2>
                    <p>The Jenkins pipeline has completed successfully.</p>
                    <p><b>Project:</b> ${JOB_NAME}</p>
                    <p><b>Build Number:</b> ${BUILD_NUMBER}</p>
                    <p><b>Committed by:</b> ${GIT_COMMITTER_NAME}</p>
                    <p><b>Branch:</b> ${GIT_BRANCH}</p>
                    <p>All Selenium tests passed!</p>
                    <p><a href="${BUILD_URL}">View Build Details</a></p>
                """,
                to: "${RECIPIENT_EMAIL}",
                mimeType: 'text/html',
                attachmentsPattern: 'selenium-tests/screenshots/**/*'
            )
        }
        
        failure {
            echo 'Tests failed!'
            emailext (
                subject: "Jenkins Build #${BUILD_NUMBER} - FAILED",
                body: """
                    <h2>Build Failed</h2>
                    <p>The Jenkins pipeline has failed.</p>
                    <p><b>Project:</b> ${JOB_NAME}</p>
                    <p><b>Build Number:</b> ${BUILD_NUMBER}</p>
                    <p><b>Committed by:</b> ${GIT_COMMITTER_NAME}</p>
                    <p><b>Branch:</b> ${GIT_BRANCH}</p>
                    <p>One or more Selenium tests failed. Please check the logs and screenshots.</p>
                    <p><a href="${BUILD_URL}console">View Console Output</a></p>
                """,
                to: "${RECIPIENT_EMAIL}",
                mimeType: 'text/html',
                attachmentsPattern: 'selenium-tests/screenshots/**/*'
            )
        }
    }
}
