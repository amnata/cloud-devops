### **Project Title**:  
**Infrastructure as Code: Secure and Testable Kubernetes Cluster Module with Terraform**

---

### **Project Description**:

In this project, you will design and develop a reusable **Terraform module** to provision a **Kubernetes cluster** or **VM instance** on one of the major cloud platforms: **Google Cloud (GKE), Amazon Web Services (EKS), or Microsoft Azure (AKS)**. This project focuses on applying DevOps best practices, including automation, testing, documentation, and security compliance.

---

### **Objectives**:

- Develop a modular and reusable Terraform module for deploying a Kubernetes cluster / VM instance.
- Generate comprehensive documentation for the module using **terraform-docs**.
- Ensure the security of Terraform configuration with **Trivy**, a vulnerability and misconfiguration scanner.
- Write and run integration tests using **Terratest** to validate the module functionality.
- Automate pre-commit checks to integrate **terraform-docs**, **Trivy**, **Terraform format/validate**, and **Terratest** in a CI-like local workflow.

---

### **Project Requirements**:

1. **Terraform Module Development**:
   - Create a structured and reusable module for provisioning a Kubernetes cluster  on GKE, EKS, or AKS / VM instance.
   - Follow Terraform best practices: variable definitions, main and outputs,

2. **Documentation with terraform-docs**:
   - Use `terraform-docs` to automatically generate and update documentation from the module's codebase.
   - Include the output in the module’s README.md.

3. **Security Scanning with Trivy**:
   - Integrate `Trivy` to scan the Terraform configuration files for known vulnerabilities and misconfigurations.
   - Ensure scans are part of the development process using pre-commit hooks.

4. **Testing with Terratest**:
   - Write Go tests using **Terratest** to verify the module provisions infrastructure as expected.
   - Include setup and teardown logic to ensure clean test environments.

5. **Pre-commit Integration**:
   - Configure **pre-commit** to automate the following:
     - Run `terraform fmt` and `terraform validate`
     - Execute `terraform-docs` to update documentation
     - Run `Trivy` scan on Terraform files
     - refer to this documentation for implement these features https://github.com/antonbabenko/pre-commit-terraform 
---

### **Expected Deliverables**:

- Terraform module source code (well-documented and structured).
- `README.md` file generated/updated by `terraform-docs`.
- Pre-commit configuration (`.pre-commit-config.yaml`) with hooks for:
  - `terraform fmt`  
  - `terraform validate`  
  - `terraform-docs`  
  - `Trivy`  
- Test scripts written using `Terratest` in Go.
- A short presentation or demo showcasing the module, how tests and scans are performed, and the usage of pre-commit.

---

### **Evaluation Criteria**:

| Criteria                          | Weight |
|----------------------------------|--------|
| Terraform module structure       | 25%    |
| terraform-docs usage             | 10%    |
| Trivy integration and findings   | 15%    |
| Terratest implementation         | 20%    |
| Pre-commit hook setup            | 15%    |
| Code quality & documentation     | 10%    |
| Presentation/Demo                | 5%     |

