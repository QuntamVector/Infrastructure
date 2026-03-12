pipeline {

    parameters {
        choice(
            name: 'terraformAction',
            choices: ['apply', 'destroy'],
            description: 'Choose your terraform action'
        )
    }

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION    = 'us-west-2'
    }

    agent any

    stages {

        stage('Checkout') {
            steps {
                script {
                    dir('terraform') {
                        git url: 'https://github.com/ITkannadigaru/Infrastructure.git', branch: 'main'
                    }
                }
            }
        }

        // ─── 0-bootstrap must apply FIRST ─────────────────────────────────────
        // S3 bucket + DynamoDB lock table must exist before 1-network and 2-eks
        // can init their backends or acquire state locks

        stage('Bootstrap: Plan') {
            steps {
                sh 'cd terraform/0-bootstrap && terraform init -input=false && terraform plan -out tfplan && terraform show -no-color tfplan > tfplan.txt'
            }
        }

        stage('Bootstrap: Approval') {
            steps {
                script {
                    def plan = readFile 'terraform/0-bootstrap/tfplan.txt'
                    input message: '[0-bootstrap] Review plan and approve to create S3 + DynamoDB',
                          parameters: [text(name: 'Plan', description: 'Terraform Plan Output', defaultValue: plan)]
                }
            }
        }

        stage('Bootstrap: Execute') {
            steps {
                script {
                    if (params.terraformAction == 'apply') {
                        sh 'cd terraform/0-bootstrap && terraform apply -input=false tfplan'
                    } else {
                        sh 'cd terraform/0-bootstrap && terraform destroy -auto-approve'
                    }
                }
            }
        }

        // ─── 1-network + 2-eks plan together after bootstrap is ready ──────────

        stage('Plan: 1-network + 2-eks') {
            when {
                expression { params.terraformAction == 'apply' }
            }
            steps {
                sh 'cd terraform/1-network && terraform init -input=false && terraform plan -out tfplan && terraform show -no-color tfplan > tfplan.txt'
                sh 'cd terraform/2-eks && terraform init -input=false && terraform plan -out tfplan && terraform show -no-color tfplan > tfplan.txt'
            }
        }

        stage('Approval: 1-network + 2-eks') {
            when {
                expression { params.terraformAction == 'apply' }
            }
            steps {
                script {
                    def network = readFile 'terraform/1-network/tfplan.txt'
                    def eks     = readFile 'terraform/2-eks/tfplan.txt'
                    def allPlans = "=== 1-network ===\n${network}\n=== 2-eks ===\n${eks}"
                    input message: 'Review 1-network + 2-eks plans and approve to proceed',
                          parameters: [text(name: 'Plan', description: 'Terraform Plan Output', defaultValue: allPlans)]
                }
            }
        }

        stage('Execute: 1-network') {
            when {
                expression { params.terraformAction == 'apply' }
            }
            steps {
                sh 'cd terraform/1-network && terraform apply -input=false tfplan'
            }
        }

        stage('Execute: 2-eks') {
            when {
                expression { params.terraformAction == 'apply' }
            }
            steps {
                sh 'cd terraform/2-eks && terraform apply -input=false tfplan'
            }
        }

        // ─── Destroy runs in reverse order ────────────────────────────────────

        stage('Destroy: 2-eks') {
            when {
                expression { params.terraformAction == 'destroy' }
            }
            steps {
                sh 'cd terraform/2-eks && terraform init -input=false && terraform destroy -auto-approve'
            }
        }

        stage('Destroy: 1-network') {
            when {
                expression { params.terraformAction == 'destroy' }
            }
            steps {
                sh 'cd terraform/1-network && terraform init -input=false && terraform destroy -auto-approve'
            }
        }

    }

    post {
        success {
            echo "All layers completed: terraform ${params.terraformAction} succeeded."
        }
        failure {
            echo "Pipeline failed. Check the stage logs above."
        }
        always {
            cleanWs()
        }
    }
}
