This is a sample of migrating Parse data from the export returned from the Parse export request:
http://blog.parse.com/learn/engineering/one-click-export/

If you need any help, contact us here: http://go.cloudmine.me/parse-consultation.

Basics of the the scripts:

Run ```bundle install``` using a Ruby newer than 1.9.*

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

This tool is a set of scripts to leverage the CloudMine REST API to migrate dumped data from Parse. This is an iterative script so if you have an application with a lot of data the best bet is to contact CloudMine to do the migration for you directly on the database. This way the data migrates faster and more accurately. However for playing around with CloudMine with an existing data set these scripts will be sufficient.

You are welcome to use some sample dump files from Parse which have been added to the ```data/``` directory. This script has been used internally but all the potential use cases of Parse are definitely not there yet. CloudMine welcomes issues filed or PRs which cover some of the other use cases which existing migrations haven't touched on yet.

1. **Migrate users.**
User structures are relatively the same for CloudMine and Parse. However, we are currently not migrating user passwords. In the past we used this script to generate a random password and then utilize the password reset endpoints to trigger the user to reset their password. If this is not sufficient please contact CloudMine to help with a more transparent migration strategy.

     ```ruby migrate_users.rb start -a "56c63717d2624c7484e4a0125f2aa90b" -k "689EBB2DDFB242628B7514D8FE8B1AD0" -f "data/_User.json"```

2. **Migrate Roles.**
This is currently a work in progress. The use case hasn't presented itself until now.

3. **Migrate Data.**

     ```ruby migrate_app_data.rb start -a "56c63717d2624c7484e4a0125f2aa90b" -k "689EBB2DDFB242628B7514D8FE8B1AD0" -f "data/Sample.json"```

**Notes:** 

1. The example `Master Key` and `App Id` above are fake. :)

2. If migrating large data sets (on the order of GBs), please notify `support@cloudmine.me`. We can assist with these types of migrations by importing the data directly on the backend, which will allow the scripts to run with greater efficiency and will save you time in the process!

3. If any of your objects contain `geopoints`, please email CloudMine support (`support@cloudmine.me`) with an `example object shape` and your `App Id`. Due to differences in how these obejcts are stored between Parse and CloudMine, we will need to perform some behind-the-scenes tuning to ensure your application's performance when executing location-based queries. 
