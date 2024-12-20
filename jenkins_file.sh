pipeline {
    agent {
        node{
            label "dev"  
            
        }
    }
    stages{
        stage("Clone Code"){
            steps{
                git url:"https://github.com/Web-Dev-Hero/twotier-todo-flask-app.git" , branch:"master"
                echo "code copy to successfully in jenkins"
            }
        }
        stage("Build"){
            steps{
                sh "docker build -t flask-app-real:latest ."
                echo "docker kay troe images build ho gayi images"
            }
        }

        
        stage('push to dockerhub'){
            steps{
                withCredentials(
                    [usernamePassword(
                        credentialsId:"dockerHub",
                        passwordVariable:"dockerPass",
                        usernameVariable:"dockerUser"
                        )
                    ]
                ){
                 sh "docker image tag flask-app-real:latest ${env.dockerUser}/flask-app-real:latest"  
                 sh "docker login -u ${env.dockerUser} -p ${env.dockerPass}"
                 sh "docker push  ${env.dockerUser}/flask-app-real:latest"
                 echo "image push to dockerhub successfully"
                    
                }
                
                    
               
            }
        }
        
        stage("Deploy"){
            steps{
                sh "docker compose up -d"
                echo "docker compose running in sucessfully you can see your app port number-5001"
            }
        }
    }
}


