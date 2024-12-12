----- Simulate Provider --------
use role accountadmin;
create role if not exists naspcs_role;
grant role naspcs_role to role accountadmin;
grant create integration on account to role naspcs_role;
----- This requires a paid account in a region that supports containers -----
grant create compute pool on account to role naspcs_role;
grant create warehouse on account to role naspcs_role;
grant create database on account to role naspcs_role;
grant create application package on account to role naspcs_role;
grant create application on account to role naspcs_role with grant option;
grant bind service endpoint on account to role naspcs_role;

use role naspcs_role;
create database if not exists spcs_app;
create schema if not exists spcs_app.napp;
create stage if not exists spcs_app.napp.app_stage;
-------- Image repo not available on trial accounts ----------
create image repository if not exists spcs_app.napp.img_repo;
create warehouse if not exists wh_nap with warehouse_size='xsmall';

--------- Simulate Consumer --------------
use role accountadmin;
create role if not exists nac;
grant role nac to role accountadmin;
create warehouse if not exists wh_nac with warehouse_size='xsmall';
grant usage on warehouse wh_nac to role nac with grant option;
grant imported privileges on database snowflake_sample_data to role nac;
grant create database on account to role nac;
grant bind service endpoint on account to role nac with grant option;
grant create compute pool on account to role nac;
grant create application on account to role nac;

use role nac;
create database if not exists nac_test;
create schema if not exists nac_test.data;
use schema nac_test.data;

-------- Optional For Our Use Case, but will reference later ------------
create view if not exists orders as select * from snowflake_sample_data.tpch_sf10.orders;