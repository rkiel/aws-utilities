### Managing Repositories with `codecommit`

I created the CodeCommit tool (`codecommit`) as a command-line tool to manage AWS CodeCommit repositories. It is written in Ruby 2.x without any gem dependencies. If your computer already has Ruby installed, as do many Unix variants, you should be able to use it out the box. Otherwise, install Ruby.

### Step 1 -- Creating a Repository

AWS provides a service, called CodeCommit, which "is a fully-managed source control service that hosts secure Git-based repositories." In order to create a repository in CodeCommit, we need to answer two questions.

* What do I want to call my repository?
* Where do I want to locate my repository?

The first question is simple enough but CodeCommit does have some guidelines for names:

> Any combination of letters, numbers, periods, underscores, and dashes between 1 and 100 characters in length. Repository names cannot end in .git and cannot contain any of the following characters: ! ? @ # $ % ^ & \* ( ) + = { } [ ] | \ / > < ~ ` ‘ “ ; :

In addition, CodeCommit says that a repository name "must be unique in the region for your AWS account". This means that CodeCommit is not an AWS global service but an AWS regional service, and thus repositories are located within a specific region. That brings us to the second question: location. For purposes of this article, we'll just arbitrarily choose to locate it in the `us-east-1` region.

If you have the wrapper CLI installed, we can use the `codecommit create` tool to create the repository.

```bash
codecommit create
```

The tool will prompt you to enter the answers to the two questions discussed previously. You can enter any values you want but we can also just hit the enter key for each and go with the default answers listed inside the brackets.

```text
CodeCommit Repository Name [my-first-repository]:
Repository in AWS Region [us-east-1]:
```

The tool will then use your answers to run the AWS CLI `aws codecommit create-repository` command.

```bash
aws codecommit create-repository --repository-name my-first-repository --region us-east-1
```

Very easy. You can login to the AWS Console and verify that the repository was created in the `us-east-1` region. The JSON output of the `create-repository` command will look something like the following:

```json
{
  "repositoryMetadata": {
    "accountId": "blahblahblah",
    "repositoryId": "blah-blah-blah-blah-blah",
    "repositoryName": "my-first-repository",
    "lastModifiedDate": 1542662149.887,
    "creationDate": 1542662149.887,
    "cloneUrlHttp": "https://git-codecommit.us-east-1.amazonaws.com/v1/repos/my-first-repository",
    "cloneUrlSsh": "ssh://git-codecommit.us-east-1.amazonaws.com/v1/repos/my-first-repository",
    "Arn": "arn:aws:codecommit:us-east-1:blahblahblah:my-first-repository"
  }
}
```

Lots of information there but the two most useful are the `cloneUrlHttp` and `cloneUrlSsh` listed on lines 8 and 9. These URLs are the ones we can use with commands like `git clone`. CodeCommit is just like GitHub in that we can access it using either HTTPS or SSH. But unlike GitHub, CodeCommit repositories are private. GitHub grants the world read-only access to all your public repositories without any action on your part. CodeCommit repositories, on the other hand, require you to take steps to grant access. In the next two steps, we'll cover how to grant access via SSH.

### Step 2 -- Generating and Uploading Cryptologic Keys

Setting up access to CodeCommit repositories via SSH first involves generating a pair of cryptologic keys and associating them with your AWS user account. To do that, we have some more questions to answer.

* What is my AWS user account name?
* What file name to use for the cryptologic keys?
* Do I want to use the cryptologic keys for all my CodeCommit repositories or just the ones in this region?
* What is the type and strength of my cryptologic keys?
* What passphrase to use to protect the cryptologic keys?

Let's answer these questions.

* Since we are already using the AWS CLI, we have an AWS user account and should therefore know its name.
* The cryptologic keys (public & private) will be stored in files under `~/.ssh/`. The file names can be any valid Unix file name. However, we should never use `id_rsa` as that is the name of the default cryptologic keys.
* In Step 3, we will have the option to configure SSH to use the cryptologic keys for either all CodeCommit repositories across all the regions or just the ones in a specific region. In this article, we'll choose to limit the key usage to just one region. To capture that choice, we'll include the region name in the file name for the keys.
* The type and strength of the keys, according to AWS, must be `rsa` and a minimum of 2048 bits.
* And finally, it is a best practice to protect your private key with a passphrase. However, if for some reason you don't want to, you can set it to an empty string.

We can use the `codecommit generate` tool to generate the cryptologic keys and upload the public key to our AWS user account.

```bash
codecommit generate
```

The tool will prompt you to enter the answers to all the questions. If we just hit the enter key, we can go with the default answers listed inside the brackets. However, by default, the tool uses your Unix user name as the AWS user name. For this article, we'll assume we have an AWS user name of `dev-ops`. The tool has a default SSH file name of `aws-codecommit` and since we chose the `us-east-1` region, it is appends that to the name. And obviously in the real world you would enter your own passphrase but we'll go with the default just to keep things simple.

```text
AWS User Name [Bob]: dev-ops
SSH File Name [aws-codecommit-us-east-1]:
SSH Key Type [rsa]:
SSH Key Bit Strength [2048]:
SSH Passphrase [DontUseThisAsYourRealPassphrase]:
```

With the questions answered, the tool first uses the SSH CLI tool [ssh-keygen](https://www.ssh.com/ssh/keygen/) to generate the cryptologic keys.

```bash
ssh-keygen -b 2048 -t rsa -f ~/.ssh/aws-codecommit-us-east-1 -C aws-codecommit-us-east-1 -P 'DontUseThisAsYourRealPassphrase'
```

The output will look something like the following (abbreviated for space).

```text
Generating public/private rsa key pair.
Your identification has been saved in ~/.ssh/aws-codecommit-us-east-1.
Your public key has been saved in ~/.ssh/aws-codecommit-us-east-1.pub.
```

With our cryptologic keys created, the tool will then use the AWS CLI `aws iam upload-ssh-public-key` command to upload the cryptologic public key to our AWS account and associate it with our AWS user.

```bash
aws iam upload-ssh-public-key --user-name dev-ops --ssh-public-key-body "$(cat ~/.ssh/aws-codecommit-us-east-1.pub)"
```

The JSON output of the `upload-ssh-public-key` command will look something like the following:

```json
{
  "SSHPublicKey": {
    "UserName": "dev-ops",
    "SSHPublicKeyId": "YYZ2112YYZ",
    "Fingerprint": "aa:bb:cc:dd:ee:ff:00:11:22:33:44:55:66:77:88:99",
    "SSHPublicKeyBody": "ssh-rsa blahblahblah aws-codecommit-us-east-1",
    "Status": "Active",
    "UploadDate": "2018-11-20T02:31:22Z"
  }
}
```

Lots of information there but the most important is the `SSHPublicKeyId` on line 4. This is an id created by AWS and associated with the public key we just uploaded. We can verify this using the AWS Console. Go to the IAM service and select the User account for `dev-ops`. The "Security credentials" tab has a section for "SSH keys for AWS CodeCommit". We should see the id under "SSH key ID". In the next step, we will use this id to configure SSH on our local computer.

### Step 3 -- Configure SSH Private Key for CodeCommit Access

With cryptologic keys created and associated with our AWS user account, we need to configure SSH to use those keys.

SSH supports individual configuration and customization by means of a [config](https://www.ssh.com/ssh/config/) file stored in your `~/.ssh` directory. The config file supports a wide variety of options but we are only concerned with just one. We want the option to change SSH to use our newly created cryptologic keys rather than the default ones (i.e. `id_rsa`). But not for all SSH activity, just when we are accessing CodeCommit repositories.

To do this, we can use the `codecommit config` tool to create or append to the SSH config file.

```bash
codecommit config
```

The tool will prompt you to enter the answers to several questions many of which we have seen before. One new question is whether or not to overwrite the SSH config file. You may have previously created an SSH config file and the tool needs to know that. If you answer no, it will append to it rather than overwrite. If we just hit the enter key, we can go with the default answers listed inside the brackets.

```text
AWS User Name [dev-ops]:
Repository in AWS Region [us-east-1]:
SSH File Name [aws-codecommit-us-east-1]:
Remove SSH config [yes]:
```

The tool uses the AWS CLI `aws iam list-ssh-public-keys` command to lookup the `SSHPublicKeyId` generated in Step 2.

```bash
aws iam list-ssh-public-keys --user-name dev-ops
```

Next, the tool will create/append a config option to the SSH config file. But what option? Well remember in Step 1, we were given two URLs, one of which was to access our repository via SSH? We can use the domain name of that URL as a pattern and configure SSH to use our newly created cryptologic keys whenever SSH tries to access any URL that matches that pattern.

```text
Updating ~/.ssh/config

Host git-codecommit.us-east-1.amazonaws.com
  User YYZ2112YYZ
  IdentityFile ~/.ssh/aws-codecommit-us-east-1
```

On line 3, we see the SSH config option `Host` which defines a pattern to match against domain names. The pattern we specify is the domain name found in `cloneUrlSsh` from Step 1. (NOTE: If we wanted to use our cryptologic keys for all CodeCommit repositories, regardless of region, we could replace the `us-east-1` with an asterisk `*`.)

On the lines below the `Host` option, we can indent two spaces and add options that only apply when the host pattern is matched. On line 4, the SSH config option `User` specifies the user id to connect with. The CodeCommit documentation says to use the `SSHPublicKeyId` that was generated in Step 2. And on line 5, the SSH config option `IdentityFile` specifies the path to the private key.

You can verify that the tool created/appended the SSH config file.

```bash
cat ~/.ssh/config
```

With this SSH config option in place, whenever SSH attempts to connect to any URL that matches the AWS CodeCommit domain name, our cryptologic private key will be used rather than the default one. And since our cryptologic public key has been uploaded and associated with our AWS user name, AWS will grant access to the CodeCommit repository.

The good news is that Steps 2 and 3 are one-time setup steps and you won't have to bother with them again. Does that mean we're done? No, there is still one more step. Now depending on whether you are starting from scratch with an empty repository or have an existing repository on your local computer, you will continue with either Step 4a or 4b.

### Step 4a -- Cloning an Empty Repository

If you are starting from scratch with no existing repository on your local computer, you'll want to clone the empty repository we created in CodeCommit in Step 1 to your local computer. That is what the `codecommit clone` tool will do for us.

```bash
codecommit clone
```

The tool will prompt you to enter the answers to several questions many of which we have seen before. One new question is the project directory. This the directory on your local computer into which you want to clone the repository. If we just hit the enter key, we can go with the default answers listed inside the brackets.

```bash
Project directory [~/projects]:
CodeCommit Repository Name [my-first-repository]:
Repository in AWS Region [us-east-1]:
SSH File Name [aws-codecommit-us-east-1]:
```

At this point, you would think we were all set and ready to clone the repository using SSH. But alas, there is one remaining road block. Remember back in Step 2, we created our cryptologic keys to use a passphrase? That means each time SSH uses the private key, it will need the passphrase to decrypt it. And in Step 3, we configured SSH to use our private key when accessing a CodeCommit URL. So, whenever we use certain `git` commands, such as `clone`, `pull`, or `push`, they will cause SSH to prompt us for the passphrase. This will get annoying real fast. We can get around this by using the [SSH Agent](https://www.ssh.com/ssh/agent) to keep track of our private keys and passphrases.

The `codecommit clone` tool uses the SSH CLI tool [ssh-add](https://www.ssh.com/ssh/add) to interact with the SSH Agent. First, it uses the `-l` option to get a list of all the private keys the SSH Agent is tracking passphrases. And second, if our newly created private key is not included in that list, it will prompt us to enter the passphrase.

```bash
ssh-add -l

ssh-add ~/.ssh/aws-codecommit-us-east-1

Enter passphrase for ~/.ssh/aws-codecommit-us-east-1: DontUseThisAsYourRealPassphrase
Identity added: ~/.ssh/aws-codecommit-us-east-1 (~/.ssh/aws-codecommit-us-east-1)
```

Finally, the tool can clone the repository.

```bash
git clone ssh://git-codecommit.us-east-1.amazonaws.com/v1/repos/my-first-repository

Cloning into 'my-first-repository'...
warning: You appear to have cloned an empty repository.
```

Congratulations! You are now up and running with your first CodeCommit repository.

### Step 4b -- Adding an Empty Repository as a Remote

If you are starting with an existing repository on your local computer, you'll want to add the empty repository we created in CodeCommit in Step 1 as the remote `origin` and push out all your local code. That is what the `codecommit add` tool will do for us.

```bash
codecommit add
```

The tool will prompt you to enter the answers to several questions many of which we have seen before. One new question is the project directory. This the directory on your local computer where your local repository exists. If we just hit the enter key, we can go with the default answers listed inside the brackets.

```bash
Project directory [~/projects]:
CodeCommit Repository Name [my-first-repository]:
Repository in AWS Region [us-east-1]:
SSH File Name [aws-codecommit-us-east-1]:
```

At this point, you would think we were all set and ready to add the CodeCommit repository interact with it using SSH. But alas, there is one remaining road block. Remember back in Step 2, we created our cryptologic keys to use a passphrase? That means each time SSH uses the private key, it will need the passphrase to decrypt it. And in Step 3, we configured SSH to use our private key when accessing a CodeCommit URL. So, whenever we use certain `git` commands, such as `clone`, `pull`, or `push`, they will cause SSH to prompt us for the passphrase. This will get annoying real fast. We can get around this by using the [SSH Agent](https://www.ssh.com/ssh/agent) to keep track of our private keys and passphrases.

The `codecommit add` tool uses the SSH CLI tool [ssh-add](https://www.ssh.com/ssh/add) to interact with the SSH Agent. First, it uses the `-l` option to get a list of all the private keys the SSH Agent is tracking passphrases. And second, if our newly created private key is not included in that list, it will prompt us to enter the passphrase.

```bash
ssh-add -l

ssh-add ~/.ssh/aws-codecommit-us-east-1

Enter passphrase for ~/.ssh/aws-codecommit-us-east-1: DontUseThisAsYourRealPassphrase
Identity added: ~/.ssh/aws-codecommit-us-east-1 (~/.ssh/aws-codecommit-us-east-1)
```

Finally, the tool can add the CodeCommit repository as the remote `origin` and push out the local code.

```bash
git remote add origin ssh://git-codecommit.us-east-1.amazonaws.com/v1/repos/my-first-repository
git checkout master
git push -u origin master

Counting objects: 3, done.
Writing objects: 100% (3/3), 212 bytes | 212.00 KiB/s, done.
Total 3 (delta 0), reused 0 (delta 0)
To ssh://git-codecommit.us-east-1.amazonaws.com/v1/repos/my-first-repository
 * [new branch]      master -> master
Branch 'master' set up to track remote branch 'master' from 'origin'.
```

Congratulations! You are now up and running with your first CodeCommit repository.
