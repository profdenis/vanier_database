create user vanierdb login;
alter user vanierdb password 'vanierdb';
create database vanierdb
    with owner vanierdb;