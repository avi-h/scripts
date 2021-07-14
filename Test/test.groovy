Node('agents'){

    stage('first stage'){

        a= 'Test11'
        def func01(){

            echo 'blaBla'

        }
        
        
        if(a == 'Test11') {
            func01()
            powershell 'get-date -format G'
        } else {
            
            echo 'GoodBye Stage 1'
        }
    
    }

    stage('2nd stage'){
        b = 'kukuriku'
        
        def func02(){
            bat 'ipconfig'
        }

        if (b == 'kukuriku'){
            func02
        }else{

            echo 'GoodBye stage 2'
        }

    }

}