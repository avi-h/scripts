node('agents'){
    
    stage('Build01'){
        
        powershell "Vagrant\\HyperV\\CentOS\\${params.Build_VM}.ps1"
        
    }
    
    
}