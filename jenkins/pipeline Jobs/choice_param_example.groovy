#define first the params:  Name,choices
#choices must be like the script file name
#ex: myscript01 , 02  .... 

node('agents'){
    
    stage('1st stage'){
        
        bat "python c:\\Data\\Scripts\\python\\${params.PY_SCRIPT}.py"
        
    }
    
    
}