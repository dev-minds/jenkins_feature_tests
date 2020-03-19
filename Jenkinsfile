pipeline {
    agent any 

    parameters {
        string(name: 'CREATE_S3_BUCKET', defaultValue: '', description: 'Specify a bucket name' )
    }

    environment {
        AWS_DEFAULT_REGION = 'eu-west-1'
		AWS_REGION = "eu-west-1"
        TF_VAR_bucket_name = "${params.CREATE_S3_BUCKET}"
    }

    options {
		buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '10'))
		disableConcurrentBuilds()
		// timestamps()
		// timeout 240 // minutes
		//ansiColor('xterm')
		// skipDefaultCheckout()
    }

    stages {
        stage('CRUD: CREATE'){
            steps {
                checkout scm 
				withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',
					credentialsId: 'dm_aws_keys',
					accessKeyVariable: 'AWS_ACCESS_KEY_ID', 
					secretKeyVariable: 'AWS_SECRET_ACCESS_KEY'
				]]) {
					wrap([$class: 'AnsiColorBuildWrapper', 'colorMapName': 'xterm']){
						dir('./terraform/s3_buck'){
							sh "terraform init"
							sh "terraform fmt"
							sh "terraform plan"
                            sh "terraform apply -auto-approve -var '${env.TF_VAR_bucket_name}'"
						}
					} 
				}
            }
        }
    }
}