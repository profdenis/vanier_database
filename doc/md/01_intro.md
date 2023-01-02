# Introduction

## Setting up PostgreSQL

### For Windows/Mac

1. Go to [PostgreSQL Download](https://www.enterprisedb.com/downloads/postgres-postgresql-downloads) to download the
   PostgreSQL DBMS
2. Go
   to [Intalling PostgreSQL](https://www.enterprisedb.com/docs/supported-open-source/postgresql/installer/02_installing_postgresql_with_the_graphical_installation_wizard/01_invoking_the_graphical_installer/)
   and follow the instructions to install it
3. It will install the DB server and some other tools to manage databases
    - most importantly for now, it will install the `psql` command and the *PgAdmin* application at the same time as the
      server
4. Don't forget to enter a password for the postgres user
    - if it doesn't ask for a password, it will need to be set from the command line
    - you will need to use the `psql` command to change the password of the `postgres`
      user
        - Windows:
          [psql Windows](https://sqlserverguides.com/postgresql-set-user-password/#:~:text=Open%20CMD%20on%20your%20computer,user%20and%20remember%20the%20password.&text=Now%20change%20the%20password%20of%20the%20current%20user%20postgres.)
        - Mac: the commands should be the same as for Linux (see below)

### For Linux

1. Follow this guide to install PostgreSQL on
   Ubuntu: [PostgreSQL on Ubuntu](https://www.digitalocean.com/community/tutorials/how-to-install-postgresql-on-ubuntu-20-04-quickstart)
    - The procedure is very similar for other distributions of Linux
2. Install *PgAdmin* from [here](https://www.pgadmin.org/download/)
