This guide contains instructions for common support tasks.

The [PaaS Support Manual](https://docs.google.com/document/d/1Ui0MQtZbZnRCIj4RUdqCPU6PdWvfqY9FNf7Ou3OE99w) lives elsewehere, but should be moved into the team manual sometime soon.

## Changing a user's password

1. Set your AWS environment variables to the production environment (assuming this is a production user)
2. Set your `DEPLOY_ENV` environment variable to `prod`
3. Ensure you have the [uaac client](https://github.com/cloudfoundry/cf-uaac) installed
4. Run `./paas-cf/scripts/rotate-user-password.sh -e prod -u user@example.com`

The script will generate a new password for the user, change it, and then email them the password.

## Subscribe and check the AWS notifications

AWS [sends notifications to our maillists](../team/responding_to_aws_alert/). You should subscribe to these groups to get any notification.
