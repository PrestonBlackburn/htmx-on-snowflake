## Build + Upload Docker Image

Find the image registry that was created in your snowflake account with
```sql
use role naspcs_role;
show image repositories in schema spcs_app.napp;
```

Login to Snowflake Image Registry With Docker.  
(This assumes you have already create the image repo)
```bash
docker login $(SNOWFLAKE_REPO)
```

Build Image (From root dir)
```bash
docker build --no-cache -t chat_with_data:latest .
```
(if on mac)
```bash
docker build --rm --no-cache --platform linux/amd64 -t chat_with_data:latest .
```

Tag Docker Image
```bash
docker tag <image_name> <image_url>/<image_name>
docker tag chat_with_data:latest <image_url from above>/chat_with_data:latest
```

Push image to sf
```bash
docker push <image_url from above>/<image_url>
docker push <image_url from above>/chat_with_data:latest
```

Confirm image is uploaded in Snowflake
```sql
SHOW IMAGES IN IMAGE REPOSITORY <registry name>
```


## Upload Native App Package To Snowflake

*Todo - have a script do this*  
For now just upload everything in this dir `deployment/app/`:  
- `setup.sql`  
- `manifest.yaml`  
- `README.md`  
- `sf_app_spec.yml`  
To something like the stage: `spcs_app.napp.app_stage`  

## Deploy SF Native App

Create the application Package in Snowflake
```sql
use role naspcs_role;
create application package spcs_app_pkg;
alter application package spcs_app_pkg add version v1 using @spcs_app.napp.app_stage;
grant install, develop on application package spcs_app_pkg to role nac;
```

## Install + Run App as a consumer

install app
```sql
use role nac;
create application spcs_app_instance from application package spcs_app_pkg using version v1;
```

create compute pool + grant privileges
```sql
use database nac_test;
use role nac;
create  compute pool pool_nac for application spcs_app_instance
    min_nodes = 1 max_nodes = 1
    instance_family = cpu_x64_s
    auto_resume = true;

grant usage on compute pool pool_nac to application spcs_app_instance;
grant usage on warehouse wh_nac to application spcs_app_instance;
grant bind service endpoint on account to application spcs_app_instance;
CALL spcs_app_instance.v1.register_single_callback(
  'ORDERS_TABLE' , 'ADD', SYSTEM$REFERENCE('VIEW', 'NAC_TEST.DATA.ORDERS', 'PERSISTENT', 'SELECT'));
```

start app service
```sql
call spcs_app_instance.app_public.start_app('POOL_NAC', 'WH_NAC');

--After running the above command you can run the following command to determine when the Service Endpoint is ready 
--Copy the endpoint, paste into a browser, and authenticate to the Snowflake account using the same credentials you've been using to log into Snowflake
call spcs_app_instance.app_public.app_url();
```

## Cleanup

```sql
--clean up consumer objects
use role nac;
drop application spcs_app_instance;
drop compute pool pool_nac;
drop database nac_test;

--clean up provider objects
use role naspcs_role;
drop application package spcs_app_pkg;
drop database spcs_app;
drop warehouse wh_nap;

--clean up prep objects
use role accountadmin;
drop warehouse wh_nac;
drop role naspcs_role;
drop role nac;
```
