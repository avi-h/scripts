pipeline {
    agent any

    stages {
        stage('Build01') {
            steps {
                powershell "Vagrant\\HyperV\\CentOS\\${params.Build_VM}.ps1"
            }
        }

    }

}