# alexeyhead_microservices
alexeyhead microservices repository

### HW No. 15 (Lecture No. 20)

- The practical task of the methodical manual is performed
- Gitlab deployment is automated using terraform and ansible
- Run reddit in the container: implemented through `.gitlab-ci.yml` and `Dockerfile` in reddit-folder
- GitlabRunner deployment automation using ansible-role and separate playbook - run playbooks in turn, first `docker.yml` then the `gitlab_runner.yml`, because for the `gitlab_runner.yml` playbook we need a token from GitLab
- Sending Gitlab notifications to slack chanel - https://devops-team-otus.slack.com/archives/C01H5K2T4AG
