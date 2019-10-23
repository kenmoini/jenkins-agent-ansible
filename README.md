# jenkins-agent-ansible
WHY HAVE ONE AUTOMATION PLATFORM WHEN YOU CAN HAVE TWO?! -said as the evil rich dude in the movie "Contact"

A simple Jenkins Agent that is prepared to use Ansible.  Yeah, cause why not.

Yeah, I don't know how else to break it to ya.  This is a Jenkins Build Agent that is based on the NodeJS Agent except that I also stuffed the latest Ansible and Python packages.

This way you can quickly pull in your playbooks, run your tests, and deploy in a Jenkins pipeline.

## How to use

- Have Kubernetes Cluster, or Docker Swarm I guess if you're into that sorta thing
- Deploy Jenkins onto cluster/swarm of big fat daemons
- Configure your Kubernetes Service Account Credentials in your Jenkins server (important step most forget after that helm chart...)
- Create pipeline targeting this container
- Run pipeline, give it a few minutes to pull in the container maybe

**Don't have have a pipeline?**

No problem, here's an example, with the agent and pod definition and everything:

```
pipeline {
  agent {
    kubernetes {
      defaultContainer 'jnlp'
      yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    some-label: some-label-value
spec:
  containers:
  - name: ansible
    image: kenmoini/jenkins-agent-ansible:latest
    command:
    - cat
    tty: true
  - name: busybox
    image: busybox
    command:
    - cat
    tty: true
"""
    }
  }
  stages {
    stage('Run Ansible') {
      steps {
        container('ansible') {
          sh 'ansible --version'
        }
        container('busybox') {
          sh '/bin/busybox'
        }
      }
    }
  }
}
```

Otherwise you can use the agent container in any other fashion by pulling from Docker Hub with a quick ``docker pull kenmoini/jenkins-agent-ansible``

Oh yeah, I guess you can ``docker build`` this Dockerfile too if you're into that sorta thing.  It'd be cooler if you hung out with my ``buildah bud``...
