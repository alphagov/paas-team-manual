This guide contains instructions for common support tasks.

## Changing a user's password

1. Set your AWS environment variables to the production environment (assuming this is a production user)
2. Set your `DEPLOY_ENV` environment variable to `prod`
3. Ensure you have the [uaac client](https://github.com/cloudfoundry/cf-uaac) installed
4. Run `./paas-cf/scripts/rotate-user-password.sh -e prod -u user@example.com`

The script will generate a new password for the user, change it, and then email them the password.
