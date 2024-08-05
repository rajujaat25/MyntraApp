# STEP 1A: Setting up AWS EC2 Instance and IAM Role
1. **Sign in to the AWS Management Console:** Access the AWS Management Console using your credentials
2. **Navigate to the EC2 Dashboard:** Click on the “Services” menu at the top of the page and select “EC2” under the “Compute” section. This will take you to the EC2 Dashboard.
3. **Launch Instance:** Click on the “Instances” link on the left sidebar and then click the “Launch Instance” button.
4. **Choose an Amazon Machine Image (AMI):** In the “Step 1: Choose an Amazon Machine Image (AMI)” section:
Select “AWS Marketplace” from the left-hand sidebar.
Search for “Ubuntu” in the search bar and choose the desired Ubuntu AMI (e.g., Ubuntu Server 22.04 LTS).
Click on “Select” to proceed.
5. **Choose an Instance Type:** In the “Step 2: Choose an Instance Type” section:
Scroll through the instance types and select “t2.large” from the list.
Click on “Next: Configure Instance Details” at the bottom.
6. **Configure Instance Details:** In the “Step 3: Configure Instance Details” section, you can leave most settings as default for now. However, you can configure settings like the network, subnet, IAM role, etc., according to your requirements.
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
