This is a sample of migrating Parse data from the export returned from the Parse export request:
http://blog.parse.com/learn/engineering/one-click-export/

Basics of the the scripts:
```
Commands
     start: start data migration

Options
    -a, --cloudmine-appid APPID      which environment you want server run
    -k MASTERKEY,                    CloudMine master API key
        --cloudmine-master-key
    -f, --data-file DATAFILEPATH     Parse exported _User file path to process
    -h, --help                       help
```

This tool is a quick and dirty series of scripts to leverage the CloudMine REST API to migrate dumped data from Parse. This is an iterative script so if you have an application with a lot of data the best bet is to contact CloudMine to do the migration for you directly on the Database. This way the data migrates faster and more accurately. However for playing around with CloudMine with an existing data set this is totally sufficient.

Step 1: Migrate users
User shapes are relatively the same for CloudMine and Parse. However, we are currently not migrating user passwords and in the past used this script to generate a random password and then utilize the password reset endpoints to trigger the user to reset their password. If this is not sufficient please contact CloudMine to help with a more transparent migration strategy.
```
ruby migrate_users.rb start -a "56c63717d2624c7484e4a0125f2aa90b" -k "689EBB2DDFB242628B7514D8FE8B1AD0" -f "data/_User.json"
```

Step 2: Migrate Roles
This is currently a work in progress. The use case hasn't presented itself until no.

Step 2: Migrate Data
```
ruby migrate_app_data.rb start -a "56c63717d2624c7484e4a0125f2aa90b" -k "689EBB2DDFB242628B7514D8FE8B1AD0" -f "data/Sample.json"
```