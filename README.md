### Draft plugin for Kedge

- Install using:
  `draft plugin install https://github.com/containscafeine/kedge-draft-plugin`

- Make sure there is a Dockerfile for Draft to use to build your container image

- Make sure you have set the following label to your Kubernetes controller in your kedge file, e.g. Deployment:
  ```yaml
  labels:
    "draft": "<app name>"
  ```

- Make sure your container image is defined as the following in your kedge file, and there is a containerPort set -
  ```yaml
  containers:
  - image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
  ports:
  - containerPort: 5000
  ```
- That's it! Now start your iterative development using the following commands:
  `draft kedge initialize <app name> <kedge file>`
  `draft up`
  `draft connect`
  Rinse and repeat!
