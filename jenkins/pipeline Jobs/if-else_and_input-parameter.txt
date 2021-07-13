#string parameter defined as NAME in job settings


node('agents'){ 
    

    stage('first stage'){
        
        a= 'Test11'
        if(a == 'Test11') {
            powershell 'get-date -format G'
        } else {
            
            echo 'GoodBye Stage 1'
        }
    
    }
    
    stage('second stage'){
        
        if(params.NAME == 'avi') {
           bat 'nslookup walla.co.il'
        } else {
            
            echo 'BoomShakalaka Stage 2'
        }
    
    }    
    
}