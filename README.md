<div align="center">
<h3 >☸️🐋 K3d as Cluster Manger</h3>
<h6>To run lightweight k3s Kubernetes clusters for orchestrating containerized applications.</h6>

<img src="https://i.giphy.com/3o8dFCeY6O5NyLVDYQ.webp" alt="img" />
  
<br/>
<br/>
<div align="start">
<h3>key aspects</h3>
 <h4>◦ K3s and Vagrant:</h4>
<p>Use of Vagrant in combination with k3s to create a Kubernetes cluster across two virtual machines. One machine is configured as the master server, while the other serves as a worker node. Both machines are provisioned automatically through a script, which streamlines the setup process and ensures consistency across environments. This setup allows for a lightweight, efficient Kubernetes cluster, ideal for development and testing purposes.</p>

  ---
<br/>
 <h4>◦ K3s and Ingress:</h4>
<p>Using k3s to host web applications, with an Ingress controller provisioned by an automated script. The setup allows for seamless routing of web traffic to the applications, enabling access via both hostname and IP address. The automated script simplifies the deployment and configuration of the entire environment, ensuring an efficient and scalable solution for hosting web apps in a Kubernetes-based infrastructure.</p>


  ---
<br/>
 <h4>◦ K3d and Argo CD:</h4>
<p>Use of k3d and ArgoCD to set up a continuous integration pipeline for a containerized application. The application is based on a container image and is linked to a GitHub repository. The setup includes two distinct namespaces: one for development (dev) and the other for ArgoCD, which handles the continuous delivery aspect. The entire infrastructure and deployment process are provisioned and automated through a script, streamlining the deployment and management of the application across environments. This setup ensures efficient CI/CD workflows and automated updates based on changes in the GitHub repository.</p>


  ---
<br/>
 <h4>◦ K3d and Gitlab:</h4>
<p>Using k3d and ArgoCD to set up a continuous integration pipeline for an application based on container images, linked with a GitLab repository. It utilizes two namespaces: one for development and the other for ArgoCD. The infrastructure is provisioned by an automated script that sets up GitLab locally and handles the deployment process. This ensures an efficient CI/CD workflow, where changes in the GitLab repository automatically trigger builds and deployments to the appropriate environment. The use of k3d enables running Kubernetes clusters in Docker for easy testing and development, while ArgoCD manages continuous delivery, providing streamlined and automated application deployment and updates.</p>
</div>
</div>
