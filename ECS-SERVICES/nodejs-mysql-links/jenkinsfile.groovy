pipeline {

  // agent {
  //     docker {
  //       image 'docker:latest'
  //       args '-u root --privileged'
  //     }
  //   }

  agent any;
  parameters {
    //Choose application branch
    gitParameter name: 'TAG',
                 type: 'PT_BRANCH_TAG',
                 defaultValue: 'master',
                 useRepository: "https://github.com/FaztTech/nodejs-mysql-links"
  }

  environment {
    project = "901576725721.dkr.ecr.eu-central-1.amazonaws.com/ecr-ecs-cluster-best"
    version = "${TAG}".toLowerCase().replaceAll("origin/", "")
    region  = "eu-central-1"
  }
  options {
    timestamps()
    disableConcurrentBuilds()
    buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '10'))
  }

  stages {
    stage('Build') {
      steps {
        script {
          git branch: "${version}",
            //credentialsId: '12345-1234-4696-af25-123455',
            url: 'https://github.com/FaztTech/nodejs-mysql-links'
          sh "docker build -t '${project}:${version}' ."
          sh ""
        }
      }
    }
  }

  stage('Push image to AWS ECR') {
    steps {
      script {
        sh("echo 'Pushing to ECR repo: ${project}:${version}'")
        sh("export AWS_REGION=${region} docker push ${project}:${version}")
      }
    }
  }

  post {
    always {
      cleanWs()
    }
    success {
      sh "docker rmi -f \$(docker image ls --quiet --filter 'reference=${project}:${version}') || true"
    }
    failure {
      sh "echo 'FAILED'"
    }
  }
}
