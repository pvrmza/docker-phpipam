# docker-phpipam unattended deploy
not another phpIPAM in docker 

phpIPAM is an open-source web IP address management application. Its goal is to provide light and simple IP address management application.

phpIPAM is developed and maintained by Miha Petkovsek, released under the GPL v3 license, project source is [here](https://github.com/phpipam/phpipam)

Site: [phpIPAM homepage](http://phpipam.net)

![phpIPAM logo](http://phpipam.net/wp-content/uploads/2014/12/phpipam_logo_small.png)


## Version/TAG
* lastet ( phpipam v1.4.2 build 20210219)

## Features
- [x] Unattended deploy
- [x] Security recommendations for apache and php
- [x] Check/move install directory
- [x] Timezone and Language setting from enviroment 
- [x] Proxy support and URL setting from enviroment 

### OTP Password
The initial password for Admin is ChangeIT and must be changed when logging in for the first time

User: Admin

Pass: ChangeIT


### Check/move install directory
If you define IPAM_BASE ($BASE) rename/move install directory to this dir

In certain circumstances you will want to move the install directory to another location, for security or compatibility reasons or this implementation will be behind a reverse proxy


## Deploy
### Docker Composer
- Run both database and moodle containers.
```
  $ git clone https://github.com/pvrmza/docker-phpipam.git 
  $ cd docker-phpipam
  $ cp env_phpipamdb.example .env_phpipamdb
  $ cp env_phpipam.example .env_phpipam
  $ docker-compose up -d
```
