# AWS CLI

This is the replacement for the AWS package.

It uses the Amazon's [AWS CLI](http://aws.amazon.com/cli/) to import data into devOpsDream.

## Using it

* Get the [AWS CLI](http://aws.amazon.com/cli/) installed and setup. - Make sure you get data you expect.
* Run `d --awsGetAll` to import everything that devOpsDream currently knows how to get. (Note that IAM permissions will affect what it is able to get.)
* Do stuff with it. You can find the functionality available to you with `d --help=awsList`

If you'd like to just import some stuff, find what you can important separately using `d --help=awsImport`.

## Profiles

Profiles allow you to manage multiple AWS accounts from one set of IAM credentials. The [AWS CLI](http://aws.amazon.com/cli/) supports this, and devOpsDream detects this and automatically uses it if it's configured.
