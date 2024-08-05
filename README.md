# DevOps Project: Automated CI/CD Pipeline Setup with Jenkins, Docker, Terraform, and Kubernetes on AWS EC2
# STEP 1A: Setting up AWS EC2 Instance and IAM Role
1. **Sign in to the AWS Management Console: **Access the AWS Management Console using your credentials
2. **Navigate to the EC2 Dashboard:** Click on the “Services” menu at the top of the page and select “EC2” under the “Compute” section. This will take you to the EC2 Dashboard.
3. **Launch Instance:** Click on the “Instances” link on the left sidebar and then click the “Launch Instance” button.
4. **Choose an Amazon Machine Image (AMI):** In the “Step 1: Choose an Amazon Machine Image (AMI)” section:
Select “AWS Marketplace” from the left-hand sidebar.
Search for “Ubuntu” in the search bar and choose the desired Ubuntu AMI (e.g., Ubuntu Server 22.04 LTS).
Click on “Select” to proceed.
5. **Choose an Instance Type:** In the “Step 2: Choose an Instance Type” section:
Scroll through the instance types and select “t2.large” from the list.
Click on “Next: Configure Instance Details” at the bottom.
6. **Configure Instance Details: **In the “Step 3: Configure Instance Details” section, you can leave most settings as default for now. However, you can configure settings like the network, subnet, IAM role, etc., according to your requirements.
Once done, click on “Next: Add Storage.”
7. **Add Storage:** In the “Step 4: Add Storage” section:
You can set the size of the root volume (usually /dev/sda1) to 30 GB by specifying the desired size in the “Size (GiB)” field.
Customize other storage settings if needed.
Click on “Next: Add Tags” when finished.
8. **Add Tags (Optional):** In the “Step 5: Add Tags” section, you can add tags to your instance for better identification and management. This step is optional but recommended for organizational purposes.
Click on “Next: Configure Security Group” when done.
9. **Configure Security Group:** In the “Step 6: Configure Security Group” section:
Create a new security group or select an existing one.
Ensure that at least SSH (port 22) is open for inbound traffic to allow remote access.
You might also want to open other ports as needed for your application’s requirements.
Click on “Review and Launch” when finished.
10. **Review and Launch:** Review the configuration details of your instance. If everything looks good:
Click on “Launch” to proceed.
A pop-up will prompt you to select or create a key pair. Choose an existing key pair or create a new one.
Finally, click on “Launch Instances.”
11. **Accessing the Instance:** Once the instance is launched, you can connect to it using SSH. Use the private key associated with the selected key pair to connect to the instance’s public IP or DNS address.

# STEP 2: INSTALL REQUIRED PACKAGES ON INSTANCE

**Jenkins Install**

```bash
sudo apt-get update
sudo apt install openjdk-17-jdk
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins -y
```
- Once Jenkins is installed, you will need to go to your AWS EC2 Security Group and open Inbound Port 8080, since Jenkins works on Port 8080.

- Now, grab your Public IP Address

```bash
<EC2 Public IP Address:8080>
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```
- Unlock Jenkins using an administrative password and install the suggested plugins.
- Jenkins will now get installed and install all the libraries.
- Create a user click on save and continue.

**Docker Install**

```bash
sudo apt install docker.io -y
sudo usermod -a -G docker jenkins
sudo service jenkins restart
sudo systemctl daemon-reload
sudo service docker stop
sudo service docker start`
```

**Terraform Install**
```bash
sudo apt install wget -y
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```


**kubectl Install **
```bash
sudo apt update
sudo apt install curl -y
curl -LO https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client
```

**AWS CLI Install **
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt-get install unzip -y
unzip awscliv2.zip
sudo ./aws/install
```
**Node.js 16 and npm Install **
```bash
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo gpg --dearmor -o /usr/share/keyrings/nodesource-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/nodesource-archive-keyring.gpg] https://deb.nodesource.com/node_16.x focal main" | sudo tee /etc/apt/sources.list.d/nodesource.list
sudo apt update
sudo apt install -y nodejs
```

## Install Plugins like JDK, Terraform, Docker, NodeJs, Kubernetes, OWASP Dependency Check
**Install Plugin**
Goto Manage Jenkins →Plugins → Available Plugins →

Install below plugins

1 → NodeJs Plugin (Install Without restart)

2 → Docker

3 → Docker commons

4 → Docker pipeline

5 → Docker API

6 → Docker Build step

7 → Owasp Dependency Check

8 → Terraform

9 → Kubernetes

10 → Kubernetes CLI

11 → Kubernetes Client API

12 → Kubernetes Pipeline DevOps steps

#### Configure Java and Nodejs in Global Tool Configuration
** Configure Java and Node.js in Global Tool Configuration
  To configure Java (JDK) and Node.js in Jenkins, follow these steps:**
- Go to Manage Jenkins:
- Navigate to Manage Jenkins from the Jenkins dashboard.
- Navigate to Global Tool Configuration:
- Select Tools from the side menu.
- Then, click on Global Tool Configuration.
- Install JDK 17:
- Scroll down to the JDK section.
- Click on Add JDK.
- Name it jdk17.
- Check the box for Install automatically.
- Choose Install from adoptopenjdk.net.
- Select the version as jdk-17.0.8+1-1.
- Install Node.js 16:
- Scroll down to the NodeJS section.
- Click on Add NodeJS.
- Name it node16.
- Check the box for Install automatically.
- Choose Install from nodejs.org.
- Select the version as NodeJS 16.2.0.
- Apply and Save:
- Click on Apply and then Save to save the configuration.

After configuring the required plugins, we need to configure specific tools in Jenkins. Follow the steps below to set up **Dependency-Check** , **Terraform**, **NodeJs(16)** and **Docker** tools.


##### Step 1: Configure Dependency-Check

1. Go to **Dashboard** → **Manage Jenkins** → **Tools**.
2. Under **Dependency-Check**, fill out the following details:
    - **Name**: `DP-Check`
    - Ensure the option **Install automatically** is checked.
    - Choose the version to install from `github.com`:
      - Version: `dependency-check 6.5.1`
3. Click on **Apply** and **Save** to confirm the configuration.

##### Step 2: Configure Docker

1. Return to **Dashboard** → **Manage Jenkins** → **Tools**.
2. Under **Docker**, fill out the following details:
    - **Name**: `docker`
    - Ensure the option **Install automatically** is checked.
    - Download the Docker version from `docker.com`:
      - Docker version: `latest`
3. Click on **Apply** and **Save** to confirm the configuration.

##### Step 3:  Configure Terraform 

To configure Terraform in Jenkins, follow the steps below:

1. Go to **Dashboard** → **Manage Jenkins** → **Tools**.
2. Under **Terraform**, fill out the following details:
    - **Name**: `terraform`
    - **Install directory**: `/usr/bin/` (This is where Terraform is installed on your system)
    - Ensure the option **Install automatically** is **unchecked** if you already have Terraform installed in the specified directory.
3. Click on **Apply** and **Save** to confirm the configuration.

##### Step 4: Adding DockerHub Credentials in Jenkins

To add your DockerHub username and password to Jenkins under Global Credentials, follow these steps:

1. Navigate to **Dashboard** → **Manage Jenkins** → **Credentials** → **System** → **Global credentials (unrestricted)**.

2. Click on **Add Credentials**.

3. In the **Kind** dropdown, select **Username with password**.

4. Set the **Scope** to **Global** (Jenkins, nodes, items, all child items, etc.).

5. Enter your DockerHub **Username** and **Password** in the respective fields.
   
6. Optionally, you can provide an **ID** (e.g., `docker`) and a **Description** (e.g., `DockerHub Credentials`).

7. Click **Create** to save the credentials.

---

Once you've completed these steps, your DockerHub credentials will be securely stored in Jenkins and can be used for accessing DockerHub from your Jenkins pipelines.



#### Create EKS Cluster from Jenkins

- CHANGE YOUR S3 BUCKET NAME IN THE BACKEND.TF

- Now create a new pipeline for the Eks provision

- I want to do this with build parameters to apply and destroy while building only.

- Let’s add a pipeline

```groovy
pipeline{
    agent any
    stages {
        stage('Checkout from Git'){
            steps{
                git branch: 'main', url: 'https://github.com/rajujaat25/MyntraApp.git'
            }
        }
        stage('Terraform version'){
             steps{
                 sh 'terraform --version'
             }
        }
        stage('Terraform init'){
             steps{
                 dir('EKS-TF') {
                      sh 'terraform init -reconfigure'
                   }
             }
        }
        stage('Terraform validate'){
             steps{
                 dir('EKS-TF') {
                      sh 'terraform validate'
                   }
             }
        }
        stage('Terraform plan'){
             steps{
                 dir('EKS-TF') {
                      sh 'terraform plan'
                   }
             }
        }
        stage('Terraform apply/destroy'){
             steps{
                 dir('EKS-TF') {
                      sh 'terraform ${action} --auto-approve'
                   }
             }
        }
    }
}
```

- Let’s apply and save and Build with parameters and select action as apply
- Stage view it will take max 10mins to provision
- Check in Your Aws console whether it created EKS or not.
- Ec2 instance is created for the Node group

#### Now In the Jenkins Instance

- Give this command
```bash
aws eks update-kubeconfig --name <clustername> --region <region>
```
- It will Generate an Kubernetes configuration file

- Here is the path for config file
```bash
cd .kube
cat config
```
- copy the file that generates

- Save it in your local file explorer, at your desired location with any name as text file.

- Go to manage Jenkins –> manage credentials –> Click on Jenkins global –> add credentials

- Select Kind as Secret file and choose the file that you saved in your local for kubernetes configuration.

#### Create pipeline for myntra

- Add this stage to Pipeline Script

```groovy
pipeline{
    agent any
    
    stages {
        stage('Checkout from Git'){
            steps{
                git branch: 'main', url: 'https://github.com/rajujaat25/MyntraApp.git'
            }
        }
        
       stage('OWASP FS SCAN') {
            steps {
                dependencyCheck additionalArguments: '--scan ./ --disableYarnAudit --disableNodeAudit', odcInstallation: 'DP-Check'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }
        stage("Docker Build & Push"){
            steps{
                script{
                   withDockerRegistry(credentialsId: 'docker', toolName: 'docker'){
                       sh "docker build -t myntra ."
                       sh "docker tag myntra rajujaat25/myntra:latest "
                       sh "docker push rajujaat25/myntra:latest "
                    }
                }
            }
        }
        stage('Deploy to kubernets'){
            steps{
                script{
                    withKubeConfig(caCertificate: '', clusterName: '', contextName: '', credentialsId: 'k8s', namespace: '', restrictKubeConfigAccess: false, serverUrl: '') {
                       sh 'kubectl apply -f deployment-service.yml'
                  }
                }
            }
        }
    }
}

```
- Apply and Save and click on Build
