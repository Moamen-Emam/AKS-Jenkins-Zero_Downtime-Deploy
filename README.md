Below is a description of the entire Jenkins Pipeline along with a description of each stage:

### Description of Jenkinsfile for Blue Green Deployment

This Jenkins Pipeline automates the deployment process of a Tomcat application to an Azure Kubernetes Service (AKS) cluster using Docker containers. It follows a blue-green deployment strategy, ensuring zero downtime during the deployment process. The pipeline integrates with Azure services, such as AKS and Azure Container Registry (ACR), and verifies the deployment at each stage.

### Stage Descriptions:

1. **Pre-clean: Clean Workspace**:
   - Description: This stage cleans the Jenkins workspace before starting the build process. It ensures that any artifacts or files from previous builds are removed to start with a clean slate.
   
2. **SCM Checkout**:
   - Description: This stage checks out the source code from the Git repository. It fetches the codebase from the main branch of the repository for further processing.
   
3. **Build Docker Image**:
   - Description: This stage builds a Docker image for the Tomcat application. It uses the Dockerfile present in the source code to build the image and pushes it to the Azure Container Registry (ACR).
   
4. **Check Env**:
   - Description: This stage checks the current environment and determines the environment to deploy to (either blue or green). It logs into Azure using service principal credentials, retrieves the current environment from AKS, sets the build display name, and cleans up the inactive environment.
   
5. **Deploy**:
   - Description: This stage deploys the application to the Kubernetes cluster. It applies the Kubernetes deployment configuration stored in `K8s_Resources/deployment.yml` to the AKS cluster. It substitutes environment variables and pulls the Docker image from ACR.
   
6. **Verify Staged**:
   - Description: This stage verifies the deployment in the staging environment (either blue or green) by checking if the Tomcat application is running and accessible through its test endpoint.
   
7. **Confirm**:
   - Description: This stage sends an email notification to a specified recipient to confirm readiness for the deployment. It waits for manual input to proceed with the deployment.
   
8. **Switch**:
   - Description: This stage switches the production service endpoint to route traffic to the new environment (blue or green). It updates the Kubernetes service configuration stored in `K8s_Resources/service.yml`.
   
9. **Verify Prod**:
   - Description: This stage verifies the production environment's functionality by checking if the Tomcat application is running and accessible through its service endpoint.
   
10. **Post-clean**:
    - Description: This stage cleans up any residual files, such as the kubeconfig file used for Kubernetes cluster authentication, to maintain a clean workspace after the pipeline execution.

These stages collectively automate the deployment process while ensuring proper verification at each step to maintain application reliability and availability.


### Description of Jenkinsfile for Rolling Update Deployment

This Jenkinsfile orchestrates a rolling update deployment process for a Tomcat application on an AKS (Azure Kubernetes Service) cluster. It automates the steps from cleaning the workspace to verifying the deployment's success.

### Stages:

1. **Pre-clean: Clean Workspace**
   - Description: This stage ensures a clean workspace before starting the build process.
   - Purpose: Removes any residual files from previous builds to ensure a fresh environment.

2. **SCM Checkout**
   - Description: This stage checks out the source code from the specified Git repository.
   - Purpose: Retrieves the latest version of the application source code for building and deployment.

3. **Build Docker Image**
   - Description: Builds a Docker image for the Tomcat application and pushes it to the Azure Container Registry (ACR).
   - Purpose: Generates the latest Docker image containing the application to be deployed.

4. **Deploy**
   - Description: Deploys the updated Docker image to the AKS cluster using Kubernetes manifests.
   - Purpose: Updates the running containers in the AKS cluster with the latest version of the application.

5. **Verify**
   - Description: Verifies the success of the rolling update deployment by checking the deployed application's availability.
   - Purpose: Ensures that the deployment process was successful and that the application is functioning as expected.

6. **Post-clean**
   - Description: Cleans up any residual files or configurations after the deployment process completes.
   - Purpose: Ensures a clean environment for subsequent builds and deployments.

