# AWS CLI

Import stuff from OpenStack.

## Pre-requisites

This package relies on the `openstack` [CLI tool available in pip](https://docs.openstack.org/newton/user-guide/common/cli-install-openstack-command-line-clients.html).

## Using it

1. Source your environment file. Eg `. ~/demo-openrc`
2. Import the hosts into DevOpsDream. Ie `d --osGetAll`

## Adding your customisations

If you want to apply company/environment-specific manipulations to the data, you can do so by registering with the `OpenStack,importedFromOpenStack` event. Eg if your script is companySpecific.achel then you would have something like this at the beginning of it:

```
#onDefine registerForEvent OpenStack,importedFromOpenStack,companySpecific
```

Although if you use the `Hosts,imported` event, it will be more portable if you move to other platforms:

```
#onDefine registerForEvent Hosts,imported,companySpecific
```

which could look like this:

```
# Apply company speific manipulations. ~ company,hostManipulations
#onDefine registerForEvent Hosts,imported,companySpecific

manipulateItem hostName,.*live,resultSet environment,live
manipulateItem hostName,.*stag,resultSet environment,staging
manipulateItem hostName,.*dev,resultSet environment,development
manipulateItem hostName,.*test,resultSet environment,testing
```

Each one of these lines looks at the `hostName` field of each host, and if it matches the regex, will set the environment accordingly.
