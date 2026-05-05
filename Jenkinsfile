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
        AWS_DEFAULT_REGION    = 'us-east-1'
    }

    agent any

    stages {

        stage('Checkout') {
            steps {
                script {
                    dir('terraform') {
                        git url: 'https://github.com/laxmanraju4144/Infrastructure.git', branch: 'main'
                    }
                }
            }
        }

        // ─── APPLY STAGES ─────────────────────────────────────────────────────

        stage('Plan: 0-bootstrap') {
            when { expression { params.terraformAction == 'apply' } }
            steps {
                sh 'cd terraform/0-bootstrap && terraform init -input=false'
                // Import existing resources into state if they already exist in AWS
                // '|| true' ensures pipeline does not fail if resource does not exist yet (first run)
                sh 'cd terraform/0-bootstrap && terraform import aws_s3_bucket.tf_state laxmanraju-statefile-logs || true'
            //  sh 'cd terraform/0-bootstrap && terraform import aws_dynamodb_table.tf_lock quantamvector-terraform-locks || true'
                sh 'cd terraform/0-bootstrap && terraform plan -out tfplan'
                sh 'cd terraform/0-bootstrap && terraform show -no-color tfplan > tfplan.txt'
            }
        }

        stage('Approval: 0-bootstrap') {
            when { expression { params.terraformAction == 'apply' } }
            steps {
                script {
                    def plan = readFile 'terraform/0-bootstrap/tfplan.txt'
                    input message: '[0-bootstrap] Approve to proceed',
                          parameters: [text(name: 'Plan', description: 'Terraform Plan Output', defaultValue: plan)]
                }
            }
        }

        stage('Apply: 0-bootstrap') {
            when { expression { params.terraformAction == 'apply' } }
            steps {
                sh 'cd terraform/0-bootstrap && terraform apply -input=false tfplan'
            }
        }

        stage('Plan: 1-network') {
            when { expression { params.terraformAction == 'apply' } }
            steps {
                sh 'cd terraform/1-network && terraform init -input=false'
                sh 'cd terraform/1-network && terraform plan -out tfplan'
                sh 'cd terraform/1-network && terraform show -no-color tfplan > tfplan.txt'
            }
        }

        stage('Approval: 1-network') {
            when { expression { params.terraformAction == 'apply' } }
            steps {
                script {
                    def plan = readFile 'terraform/1-network/tfplan.txt'
                    input message: '[1-network] Approve to proceed',
                          parameters: [text(name: 'Plan', description: 'Terraform Plan Output', defaultValue: plan)]
                }
            }
        }

        stage('Apply: 1-network') {
            when { expression { params.terraformAction == 'apply' } }
            steps {
                sh 'cd terraform/1-network && terraform apply -input=false tfplan'
            }
        }

        stage('Plan: 2-eks') {
            when { expression { params.terraformAction == 'apply' } }
            steps {
                sh 'cd terraform/2-eks && terraform init -input=false'
                sh 'cd terraform/2-eks && terraform plan -out tfplan'
                sh 'cd terraform/2-eks && terraform show -no-color tfplan > tfplan.txt'
            }
        }

        stage('Approval: 2-eks') {
            when { expression { params.terraformAction == 'apply' } }
            steps {
                script {
                    def plan = readFile 'terraform/2-eks/tfplan.txt'
                    input message: '[2-eks] Approve to proceed',
                          parameters: [text(name: 'Plan', description: 'Terraform Plan Output', defaultValue: plan)]
                }
            }
        }

        stage('Apply: 2-eks') {
            when { expression { params.terraformAction == 'apply' } }
            steps {
                sh 'cd terraform/2-eks && terraform apply -input=false tfplan'
            }
        }

        // ─── DESTROY STAGES (reverse order) ───────────────────────────────────

        stage('Destroy: 2-eks') {
            when { expression { params.terraformAction == 'destroy' } }
            steps {
                sh 'cd terraform/2-eks && terraform init -input=false'
                sh 'cd terraform/2-eks && terraform destroy -auto-approve'
            }
        }

        stage('Destroy: 1-network') {
            when { expression { params.terraformAction == 'destroy' } }
            steps {
                sh 'cd terraform/1-network && terraform init -input=false'
                sh 'cd terraform/1-network && terraform destroy -auto-approve'
            }
        }

        stage('Destroy: 0-bootstrap') {
            when { expression { params.terraformAction == 'destroy' } }
            steps {
                sh 'cd terraform/0-bootstrap && terraform init -input=false'
                sh 'cd terraform/0-bootstrap && terraform destroy -auto-approve'
            }
        }

    }

    post {
        success {
            echo "terraform ${params.terraformAction} completed successfully."
        }
        failure {
            echo "Pipeline failed. Check the stage logs above."
        }
    }
}




//pipeline {

//     parameters {
//         choice(
//             name: 'terraformAction',
//             choices: ['apply', 'destroy'],
//             description: 'Choose your terraform action'
//         )
//         choice(
//             name: 'initMode',
//             choices: ['migrate', 'reconfigure'],
//             description: 'Choose how to handle backend changes'
//         )
//     }

//     environment {
//         AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
//         AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
//         AWS_DEFAULT_REGION    = 'us-east-1'
//     }

//     agent any

//     stages {

//         stage('Checkout') {
//             steps {
//                 script {
//                     dir('terraform') {
//                         git url: 'https://github.com/laxmanraju4144/Infrastructure.git', branch: 'main'
//                     }
//                 }
//             }
//         }

//         // ─── APPLY STAGES ─────────────────────────────────────────────────────

//         stage('Plan: 0-bootstrap') {
//             when { expression { params.terraformAction == 'apply' } }
//             steps {
//                 script {
//                     def initFlag = params.initMode == 'migrate' ? '-migrate-state' : '-reconfigure'
//                     sh "cd terraform/0-bootstrap && terraform init ${initFlag} -input=false"
//                 }
//                 sh 'cd terraform/0-bootstrap && terraform import aws_s3_bucket.tf_state quantamvector-infra-statefile-backup || true'
//                 sh 'cd terraform/0-bootstrap && terraform import aws_dynamodb_table.tf_lock quantamvector-terraform-locks || true'
//                 sh 'cd terraform/0-bootstrap && terraform plan -out tfplan'
//                 sh 'cd terraform/0-bootstrap && terraform show -no-color tfplan > tfplan.txt'
//             }
//         }

//         stage('Approval: 0-bootstrap') {
//             when { expression { params.terraformAction == 'apply' } }
//             steps {
//                 script {
//                     def plan = readFile 'terraform/0-bootstrap/tfplan.txt'
//                     input message: '[0-bootstrap] Approve to proceed',
//                           parameters: [text(name: 'Plan', description: 'Terraform Plan Output', defaultValue: plan)]
//                 }
//             }
//         }

//         stage('Apply: 0-bootstrap') {
//             when { expression { params.terraformAction == 'apply' } }
//             steps {
//                 sh 'cd terraform/0-bootstrap && terraform apply -input=false tfplan'
//             }
//         }

//         stage('Plan: 1-network') {
//             when { expression { params.terraformAction == 'apply' } }
//             steps {
//                 script {
//                     def initFlag = params.initMode == 'migrate' ? '-migrate-state' : '-reconfigure'
//                     sh "cd terraform/1-network && terraform init ${initFlag} -input=false"
//                 }
//                 sh 'cd terraform/1-network && terraform plan -out tfplan'
//                 sh 'cd terraform/1-network && terraform show -no-color tfplan > tfplan.txt'
//             }
//         }

//         stage('Approval: 1-network') {
//             when { expression { params.terraformAction == 'apply' } }
//             steps {
//                 script {
//                     def plan = readFile 'terraform/1-network/tfplan.txt'
//                     input message: '[1-network] Approve to proceed',
//                           parameters: [text(name: 'Plan', description: 'Terraform Plan Output', defaultValue: plan)]
//                 }
//             }
//         }

//         stage('Apply: 1-network') {
//             when { expression { params.terraformAction == 'apply' } }
//             steps {
//                 sh 'cd terraform/1-network && terraform apply -input=false tfplan'
//             }
//         }

//         // Continue with 2-eks stages (same pattern)...

//         // ─── DESTROY STAGES ───────────────────────────────────────────────────

//         stage('Destroy: 2-eks') {
//             when { expression { params.terraformAction == 'destroy' } }
//             steps {
//                 script {
//                     def initFlag = params.initMode == 'migrate' ? '-migrate-state' : '-reconfigure'
//                     sh "cd terraform/2-eks && terraform init ${initFlag} -input=false"
//                 }
//                 sh 'cd terraform/2-eks && terraform destroy -auto-approve'
//             }
//         }

//         stage('Destroy: 1-network') {
//             when { expression { params.terraformAction == 'destroy' } }
//             steps {
//                 script {
//                     def initFlag = params.initMode == 'migrate' ? '-migrate-state' : '-reconfigure'
//                     sh "cd terraform/1-network && terraform init ${initFlag} -input=false"
//                 }
//                 sh 'cd terraform/1-network && terraform destroy -auto-approve'
//             }
//         }

//         stage('Destroy: 0-bootstrap') {
//             when { expression { params.terraformAction == 'destroy' } }
//             steps {
//                 script {
//                     def initFlag = params.initMode == 'migrate' ? '-migrate-state' : '-reconfigure'
//                     sh "cd terraform/0-bootstrap && terraform init ${initFlag} -input=false"
//                 }
//                 sh 'cd terraform/0-bootstrap && terraform destroy -auto-approve'
//             }
//         }
//     }

//     post {
//         success {
//             echo "terraform ${params.terraformAction} completed successfully."
//         }
//         failure {
//             echo "Pipeline failed. Check the stage logs above."
//         }
//     }
// }
