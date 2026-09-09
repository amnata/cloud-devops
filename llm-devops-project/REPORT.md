# DevOps Project: Deploying an Open-Source Large Language Model (LLM)

## 1. Introduction and Objective

The objective of this project was to deploy an open-source Large Language Model application using Docker Compose and then migrate the same application to Kubernetes.

The application is composed of two main services:

* **Ollama**, which hosts and manages the Large Language Models.
* **Open WebUI**, which provides a web interface for interacting with the models.

The project allowed us to practice containerization, Kubernetes orchestration, service networking, persistent storage, resource management and application health monitoring.

The deployment was first tested locally with Docker Compose and then recreated on a Minikube Kubernetes cluster.

---

## 2. Local Deployment with Docker Compose

The first step was to deploy the provided application using Docker Compose.

The architecture consists of two containers:

```text
User
 |
 v
Open WebUI :8080
 |
 | HTTP
 v
Ollama :11434
 |
 +--> llama3.2:3b
 +--> mistral:7b
 +--> gemma3:4b
```

Open WebUI communicates with Ollama using the Docker Compose service name:

```text
http://ollama:11434
```

Named volumes are used to preserve Ollama models and Open WebUI data when containers are restarted.

After starting the stack, the containers were verified using Docker commands and Open WebUI was accessed through the browser.

The required models were downloaded with Ollama using commands such as:

```bash
docker exec -it ollama ollama pull llama3.2:3b
docker exec -it ollama ollama pull mistral:7b
docker exec -it ollama ollama pull gemma3:4b
```

The models were then tested through the Open WebUI interface.

### Figure 1 – Docker Compose deployment

**[INSERT SCREENSHOT HERE]**

The screenshot should show the Docker containers running, for example with:

```bash
docker ps
```

---

## 3. Kubernetes Deployment

After validating the application with Docker Compose, the same architecture was recreated using Kubernetes manifests.

The application was deployed in a dedicated namespace called:

```text
llm-app
```

The main Kubernetes resources are:

| Resource                | Purpose                            |
| ----------------------- | ---------------------------------- |
| Namespace               | Isolates the LLM application       |
| Deployment – Ollama     | Runs the Ollama container          |
| Deployment – Open WebUI | Runs the WebUI container           |
| Service – Ollama        | Provides internal access to Ollama |
| Service – Open WebUI    | Exposes WebUI to the user          |
| ConfigMap               | Stores application configuration   |
| PVC – Ollama            | Persists downloaded models         |
| PVC – WebUI             | Persists WebUI data                |

An Ingress was not required because Minikube provides a simple alternative through the Open WebUI NodePort service.

---

## 4. Kubernetes Deployments

### 4.1 Ollama Deployment

The Ollama Deployment uses the image:

```text
ollama/ollama:latest
```

It exposes port:

```text
11434
```

The container is connected to `ollama-pvc`, which is mounted at:

```text
/root/.ollama
```

This directory contains the downloaded LLM models.

CPU and memory requests and limits were configured:

```yaml
requests:
  cpu: "1"
  memory: "2Gi"

limits:
  cpu: "4"
  memory: "6Gi"
```

### 4.2 Open WebUI Deployment

Open WebUI uses the image:

```text
ghcr.io/open-webui/open-webui:main
```

and exposes port:

```text
8080
```

Its application data is stored in the `webui-pvc` volume mounted at:

```text
/app/backend/data
```

Resource requests and limits were also configured:

```yaml
requests:
  cpu: "500m"
  memory: "1Gi"

limits:
  cpu: "2"
  memory: "3Gi"
```

---

## 5. Kubernetes Services and Communication

Two Services were created.

### Ollama Service

Ollama uses a **ClusterIP** Service:

```text
ollama-service
```

It exposes:

```text
11434/TCP
```

The ClusterIP Service allows Open WebUI to communicate with Ollama internally inside the Kubernetes cluster.

The communication path is therefore:

```text
Open WebUI Pod
      |
      | HTTP :11434
      v
ollama-service
      |
      v
Ollama Pod
```

Open WebUI does not need direct external access to Ollama.

### Open WebUI Service

Open WebUI uses a **NodePort** Service:

```text
webui-service
```

The service maps:

```text
8080:30080
```

This allows the user to access the WebUI from outside the Pod.

The service was tested with:

```bash
minikube service webui-service -n llm-app --url
```

which returned a local URL:

```text
http://127.0.0.1:32961
```

### Figure 2 – Kubernetes Services

**[INSERT SCREENSHOT HERE]**

Capture:

```bash
kubectl get svc -n llm-app
```

The screenshot must clearly show both:

```text
ollama-service
webui-service
```

---

## 6. Persistent Volume Claims

Persistent Volume Claims are required because LLM models and application data must survive Pod restarts.

Two PVCs were created:

```text
ollama-pvc   20Gi
webui-pvc     2Gi
```

The Ollama PVC stores downloaded models, while the Open WebUI PVC stores application data.

The PVCs were successfully bound:

```text
NAME         STATUS   CAPACITY   ACCESS MODES
ollama-pvc   Bound    20Gi       RWO
webui-pvc    Bound     2Gi       RWO
```

Without persistent storage, downloaded models could be lost when the Ollama Pod is recreated.

### Figure 3 – Persistent storage

**[INSERT SCREENSHOT HERE]**

Capture:

```bash
kubectl get pvc -n llm-app
```

---

## 7. Resource Requests and Limits

Kubernetes resource requests and limits were configured for both containers.

Requests tell Kubernetes the minimum amount of CPU and memory required by a container.

Limits define the maximum resources that a container can consume.

This prevents a container from consuming unlimited resources and helps Kubernetes schedule workloads correctly.

The configured resources are:

| Container  | CPU Request | CPU Limit | Memory Request | Memory Limit |
| ---------- | ----------: | --------: | -------------: | -----------: |
| Ollama     |           1 |         4 |            2Gi |          6Gi |
| Open WebUI |        500m |         2 |            1Gi |          3Gi |

---

## 8. Health Checks

Three types of Kubernetes probes were implemented where appropriate:

### Startup Probe

The startup probe determines whether the application has finished starting.

This is particularly important for Open WebUI because its initialization can take some time.

The Open WebUI startup probe checks:

```text
http://:8080/health
```

### Readiness Probe

The readiness probe determines whether the container is ready to receive traffic.

A Pod that is running but not ready should not receive requests from Kubernetes Services.

### Liveness Probe

The liveness probe checks whether the application is still functioning.

If the application becomes unhealthy, Kubernetes can restart the container.

During validation, Open WebUI initially required additional startup time. The Pod was temporarily reported as `0/1 Running`, but after initialization it became:

```text
1/1 Running
```

The health endpoint was also tested directly:

```bash
kubectl exec -n llm-app open-webui-6b479699-4vc49 -- \
python -c "import urllib.request; print(urllib.request.urlopen('http://127.0.0.1:8080/health', timeout=5).read().decode())"
```

The result was:

```text
{"status":true}
```

This confirmed that Open WebUI was healthy.

---

## 9. Kubernetes Validation

The final Kubernetes deployment was successfully validated.

The Pods were checked with:

```bash
kubectl get pods -n llm-app
```

The final result was:

```text
NAME                        READY   STATUS
ollama-7d8bf46f77-qch6h     1/1     Running
open-webui-6b479699-4vc49   1/1     Running
```

There were no Pods in `Pending` or `CrashLoopBackOff`.

The Services were also verified:

```text
NAME             TYPE        PORT(S)
ollama-service   ClusterIP   11434/TCP
webui-service    NodePort    8080:30080/TCP
```

### Figure 4 – Running Kubernetes Pods

**[INSERT SCREENSHOT HERE]**

Capture:

```bash
kubectl get pods -n llm-app
```

This screenshot is explicitly required by the assignment.

---

## 10. Open WebUI Demonstration

Open WebUI was accessed through the NodePort service using:

```bash
minikube service webui-service -n llm-app --url
```

The generated URL was opened in a web browser.

### Figure 5 – Open WebUI Homepage

**[INSERT SCREENSHOT HERE]**

The screenshot should show the Open WebUI homepage/interface.

---

## 11. LLM Model Demonstration

The application supports multiple models managed by Ollama.

The models required for the project include:

* `llama3.2:3b`
* `mistral:7b`
* `gemma3:4b`

Each model must be tested by submitting a prompt through Open WebUI and verifying that a response is generated.

### Figure 6 – llama3.2:3b response

**[INSERT SCREENSHOT HERE]**

The screenshot should show:

```text
Model: llama3.2:3b
Prompt: [your test prompt]
Response: [generated response]
```

### Figure 7 – mistral:7b response

**[INSERT SCREENSHOT HERE]**

The screenshot should show:

```text
Model: mistral:7b
Prompt: [your test prompt]
Response: [generated response]
```

### Figure 8 – gemma3:4b response

**[INSERT SCREENSHOT HERE]**

The screenshot should show:

```text
Model: gemma3:4b
Prompt: [your test prompt]
Response: [generated response]
```

These three screenshots are important because the assignment explicitly requires a successful prompt and response from each of the three models.

---

## 12. Docker Compose vs Kubernetes

Docker Compose and Kubernetes both allow multiple containers to be managed, but they target different levels of orchestration.

Docker Compose is simpler and is particularly convenient for local development. Services, networks, volumes and environment variables can be defined in a single Compose file.

Kubernetes is designed for more advanced container orchestration. It provides features such as:

* Self-healing
* Service discovery
* Persistent storage management
* Resource requests and limits
* Health probes
* Scaling
* Declarative configuration
* Network policies

In this project, Docker Compose was useful for the initial local deployment, while Kubernetes provided a more structured and scalable orchestration platform.

---

## 13. Optional Bonus Features

In addition to the mandatory requirements, several optional Kubernetes features were implemented or prepared.

### Horizontal Pod Autoscaler

An HPA was configured for Open WebUI with:

* Minimum replicas: 1
* Maximum replicas: 2
* CPU target: 70%

### NetworkPolicy

A NetworkPolicy was implemented to restrict communication with the Ollama backend and allow the intended application traffic.

### PodDisruptionBudget

A PodDisruptionBudget was added to improve availability during voluntary disruptions.

### Kustomize

Kustomize overlays were created for development and production environments.

### Helm

A Helm chart was created to package the Kubernetes application.

### GitHub Actions

A GitHub Actions workflow was added for automated Kubernetes configuration validation.

These features are considered **bonus functionality** and are therefore separated from the mandatory project requirements.

---

## 14. Conclusion

This project demonstrated the deployment of an open-source LLM application using Docker Compose and Kubernetes.

The application consists of Ollama for hosting the language models and Open WebUI for providing the user interface.

The Kubernetes deployment implements the required resources, including Deployments, Services, ConfigMaps and PersistentVolumeClaims. CPU and memory requests and limits were configured, and startup, readiness and liveness probes were implemented to monitor application health.

The final validation confirmed that both Ollama and Open WebUI were running successfully in the `llm-app` namespace. The Open WebUI health endpoint returned:

```text
{"status":true}
```

and the services were accessible through Kubernetes networking.

The project therefore demonstrates the main concepts required by the assignment: containerized AI deployment, Kubernetes orchestration, persistent storage, service communication, resource management and application health monitoring.
