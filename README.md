# alexeyhead_microservices
alexeyhead microservices repository

### HW No. 12 (Lecture No. 16)

- The practical task of the methodical manual is performed
- Created docker image `oleksiihead/otus-reddit:1.0` with app
- Created Terraform infra to create instances
- Created two ansible roles:

`docker` for install docker and all we need to start using docker

```
---
# tasks file for docker
- name: Install required dependencies.
  apt:
    name:
      - apt-transport-https
      - ca-certificates
      - software-properties-common
      - gnupg2
      - curl
      - python-pip
      - python-apt
    state: present
    update_cache: yes

- name: Add key for Docker
  apt_key:
    url: https://download.docker.com/linux/ubuntu/gpg
    state: present

- name: Add Docker repo
  apt_repository:
    repo:  deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable
    state: present

- name: Install Docker-ce
  apt:
    name:
      - docker-ce
      - docker-ce-cli
      - containerd.io
    update_cache: yes

- name: Enable Docker Service
  service:
    name: docker
    state: started
    enabled: yes

- name: Install Docker Module for Python
  pip:
    name: docker
    executable: pip

- name: Create docker group
  become: true
  group:
    name: docker
    state: present

- name: Add user to group
  become: true
  user:
    name: "{{ansible_user}}"
    groups: docker
    append: true

- meta: reset_connection

```

`app` for deploy docker container from DockerHub

```
---
# tasks file for app
- name: start App
  vars:
    ansible_python_interpreter: /usr/bin/python
  community.docker.docker_container:
    name: otus-reddit
    image: oleksiihead/otus-reddit:1.0
    state: started
    restart: yes
    ports:
      - "9292:9292"

```

- Created packer image with ansible
- Finalized terraform with `remote-exec` for start docker container, don't know how to make it more elegant, the container doesn't want to start with an image packer, despite the explicit launch in the ansible role

```
provisioner "remote-exec" {
    inline = [
      "docker container run -d -p 9292:9292 oleksiihead/otus-reddit:1.0"
    ]
  }
```
