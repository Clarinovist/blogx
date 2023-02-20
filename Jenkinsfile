pipeline { 
 agent any

 environment {
   GIT_COMMIT_SHORT = sh(returnStdout: true, script: '''echo $GIT_COMMIT | head -c 7''')
 }

 stages {
   stage('Prepare .env') {
     steps {
       sh 'echo GIT_COMMIT_SHORT=$(echo $GIT_COMMIT_SHORT) > .env'
     }
   }

   stage('Build blogx') {
     steps {
       dir('blogx') {
         sh 'docker build . -t blogx:$GIT_COMMIT_SHORT'
         sh 'docker tag blogx:$GIT_COMMIT_SHORT nugrohop2003/blogx:$GIT_COMMIT_SHORT'
         sh 'docker push nugrohop2003/blogx:$GIT_COMMIT_SHORT'
       }
     }
   }

   stage('Deploy to remote server') {
     steps {
       sshPublisher(publishers: [sshPublisherDesc(configName: 'Remote Server', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: 'docker compose up -d', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '/blogx', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '.env.example,docker-compose.yml')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
     }
   }
 }
}
