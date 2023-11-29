# VCS Workflows
## Section 1: Setting Up the Project
- Create a new project and main.tf file in Visual Studio Code (VSC) or your preferred text editor.
- Copy over any relevant code from previous projects or modules as needed.
- Create a terraform.tfvars file to store sensitive information, such as credentials.
- Define variables in a variables.tf file without default values.

## Section 2: Initializing Git and Creating a Repository
- Initialize a new Git repository with git init.
- Create a new private repository on GitHub.
- Add and commit all project files to the local repository.
- Add the GitHub repository as a remote, then push the local repository to it.
- Add a .gitignore file to the project if needed.

## Section 3: Configuring Terraform Cloud
- Sign in to Terraform Cloud.
- Create a new workspace and select version control workflow, then choose GitHub.
- Authorize Terraform Cloud with GitHub and select the repository created earlier.
- Configure the workspace settings, including the default branch, and create the workspace.
- Manually enter the required variables in Terraform Cloud, marking sensitive variables as needed.

## Section 4: Configuring the Terraform Module
- Update the Terraform module source to point to the published module on the Terraform Registry.
- Run terraform init to initialize the Terraform configuration.
- Set up the Terraform workspace in the main.tf file.
- Test the configuration with terraform plan.

## Section 5: Running the Terraform Code
- Monitor the Terraform Cloud workspace for runs, logs, and progress.
- Review the Terraform plan output and make adjustments as necessary.
- Section 6: Setting Up the Repository and Initial Run
- Create a speculative plan in Terraform and run it to understand its behavior.
- Check your runs in Terraform and confirm the status.
- Make necessary changes to your code and then commit using git commit -m "make it work".
- Push the changes to the main branch using git push.

## Section 7: Correcting Mistakes and Deploying
- Correct any spelling or syntax errors in the code if present.
- Wait for the deployment to change status to pending and accept it.
- Confirm and apply the changes.
- Verify that the server is provisioned and running on AWS.

## Section 8: Working with Branches and Pull Requests
- Create a new branch using git checkout -b and make necessary changes, such as adding tags or an S3 bucket.
- Plan the changes using terraform plan and fix any errors or issues.
- Commit and push the changes to the branch.
- Create a pull request on GitHub for the new branch.
- Review and merge the pull request, ensuring that the speculative plan is generated.
- If needed, adjust the settings in Terraform for pull requests and retrigger the speculative plan.

## Section 9: Cleaning Up and Destroying Resources
- Wait for the merge to complete and the resources to be deployed in Terraform.
- If needed, adjust the settings in Terraform to allow destroy plans.
- Queue a destroy plan in Terraform by typing in the workspace name.
- Wait for the destroy plan to auto-apply or confirm it if needed.
- Verify that the resources have been destroyed, but leave the workspace in place for future use.