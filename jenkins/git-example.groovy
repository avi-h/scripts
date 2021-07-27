pipeline {
    agent any

    stages {
        stage('Hello') {
            steps {
                echo 'Hello World'
            }
        }
        stage('checkout') {
            steps {
                checkout scm
            }
        }
        stage('build VM') {
            steps {
                powershell 'Vagrant\\HyperV\\CentOS\\build_PS.ps1'

            }
        }
    }
}
