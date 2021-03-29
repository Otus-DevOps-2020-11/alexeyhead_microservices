# alexeyhead_microservices
alexeyhead microservices repository

### HW No. 14 (Lecture No. 18)

- The practical task of the methodical manual is performed
- Changed docker-compose to work with many networks

```
networks:
  back_net:
     ipam:
       driver: default
       config:
         - subnet: 10.0.2.0/24
  front_net:
     ipam:
       driver: default
       config:
         - subnet: 10.0.1.0/24
```
- Parameterization of port, versions of services, subnets with  environments variables in `docker-compose.yml`
- Use `.env` file with vars for `docker-compose up` - just do command, the file will be picked up automatically
- Project's name. From official documentation:
```
-p, --project-name NAME     Specify an alternate project name
                              (default: directory name)
```
Also we can use var `COMPOSE_PROJECT_NAME`

##### Task with *
- We can use another docker-compose file for override some sections
- src/docker-compose.override.yml

```
version: '3.3'
services:
  ui:
    command: ["puma", "--debug", "-w", "2"]
  comment:
    command: ["puma", "--debug", "-w", "2"]
```
- And check:

```
$ docker-compose -f docker-compose.yml -f docker-compose.override.yml up -d
$ docker-compose ps
    Name                  Command             State           Ports
----------------------------------------------------------------------------
src_comment_1   puma --debug -w 2             Up
src_post_1      python3 post_app.py           Up
src_post_db_1   docker-entrypoint.sh mongod   Up      27017/tcp
src_ui_1        puma --debug -w 2             Up      0.0.0.0:9292->9292/tcp
```
