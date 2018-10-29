### Managing Profiles with `awssu`

I created AWS Switch User (`awssu`) as a command-line tool to manage CLI profiles. It is written in Ruby 2.x without any gem dependencies. If your computer already has Ruby installed, as do many Unix variants, you should be able to use it out the box. Otherwise, install Ruby.

#### Installation

The installation is simple. Just clone the repository.

```
mkdir -p ~/GitHub/rkiel && cd $_
git clone https://github.com/rkiel/aws-utilities.git
```

If you want to run `awssu` from any terminal, you'll want to add `~/GitHub/rkiel/aws-utilities/bin` to your PATH. There is an installer script that can do that for you. It will also add a `bash` function to support tab completion.

```bash
cd ~/GitHub/rkiel/aws-utilities
./install/bin/setup
```

#### Safety first

Before we begin, let's take a moment to backup your original AWS CLI configuration that you may have previously created. That way, if you follow along with this post, you won't lose anything. If you've never configured the AWS CLI, then you can skip this step.

```bash
cp ~/.aws/credentials ~/.aws/credentials.original
cp ~/.aws/config ~/.aws/config.original
```

#### Generate AWS Access Keys

So to begin, you need to generate and download a set of AWS Access keys from your user account. Login to the AWS console and proceed to IAM. Under Users, navigate to your user account. There, you can access the Security Credentials tab. Under the Access keys section, generate a new pair of Access keys. Click the download button and store them on your local computer. For example, we'll assume they are downloaded to the `~/Downloads` directory.

You should now have a CSV file called something like `~/Downloads/credentials.csv`. We need to extract the contents of `credentials.csv` and create a new profile of credentials and configuration settings. We'll do that in the next section.

#### Adding a New Profile

The `awssu add` command can read in a CSV file and create a profile. The command takes a few parameters. The first two are the account name and user name for this profile. This can be whatever you want and should be easy to remember and type. Next, we have the path to the CSV file. And finally, the region and output format.

```bash
awssu add myCompany devOps ~/Downloads/credentials.csv us-east-1 json
```

The output looks like this.

```bash
Adding ~/.aws/awssu/myCompany/devOps/credentials
Adding ~/.aws/awssu/myCompany/devOps/config
```

Notice a few things here. You were not prompted to enter any information. You did not have to copy and paste from `credentials.csv`. The information was _not_ added to `~/.aws/credentials` and `~/.aws/config`. Instead, those files were created in another directory under `~/.asw/awssu` based on the account name and user name. Hopefully, you can see that we are going to manage multiple profiles by storing each profile in its own directory rather than in its own section within `~/.aws/credentials` and `~/.aws/config`.

You can add as many `credentials.csv` files as you would like. Each one must use a unique combination of account name and user name.

```bash
awssu add personal Joseph ~/Downloads/credentials2.csv us-east-1 json
```

The `awssu add` command has some safety built in. It will not let you overwrite an existing profile. You must use the `awssu remove` command first.

```bash
awssu remove myCompany devOps
awssu add myCompany devOps ~/Downloads/credentials3.csv us-east-1 json
```

Just adding a new profile does _not_ make it available for use. We'll cover that in the next section.

#### Using a Profile

Once you have at least one profile, you must intentionally enable it for use by making it the `default` profile. To do this, the `awssu use` command will replace `~/.aws/credentials` and `~/.aws/config` by copying the files from the directory for the account and user name.

```bash
awssu use myCompany devOps
```

The output looks like this.

```bash
Replacing ~/.aws/credentials
Replacing ~/.aws/config
```

You can now use the AWS CLI as the "devOps" user from your "myCompany" AWS account. It is set as the `default` profile. You don't have to use `--profile` with any AWS command. And if you need to switch to another profile, you can use `awssu use` again.

```bash
awssu use personal Joseph

Replacing ~/.aws/credentials
Replacing ~/.aws/config
```

You can now use the AWS CLI as the "Joseph" user from your "personal" AWS account. It is now set as the `default` profile. The other profile for "devOps" is still safe and you can switch back to it whenever you need.

With just these few commands, we now have something that is as easy to use as the `AWS_PROFILE` environment variable method. We do, however, lose the ability to work with different profiles in different terminal windows at the same time. But, what we gain, is that all existing and all new terminal windows will use the profile without having to do anything. Not a bad trade off. In the next few sections, we discuss additional gains.

#### Knowing what's what

With multiple profiles, it can be hard to know what's what. The `awssu show` and `awssu list` commands can give us some awareness.

To see the specific profile that is currently installed as the `default`, use `awssu show`.

```bash
awssu show
```

You should see the contents of `~/.aws/credentials`:

```bash
;
; personal Joseph
;
[default]
aws_access_key_id = YYZ2112YYZ
aws_secret_access_key =  blahblahblahblahblahblah
```

And you should see the contents of `~/.aws/config`:

```bash
;
; personal Joseph
;
[default]
region = us-east-1
output = json
```

To see a complete list of all the profiles added, use the `awssu list` command.

```bash
awssu list
```

You should see something like following:

```bash
myCompany devOps
personal Joseph
```

#### Removing a Profile

When a profile is no longer needed or, as we saw previously, when you want to replace a profile, you must use the `awssu remove` command. While this does remove the profile from the list of installed profiles, it does _not_ change the `default`. You must switch to a different profile with `awssu use`.

```bash
awssu remove myCompany devOps
```

```bash
Removing ~/.aws/awssu/myCompany/devOps/credentials
Removing ~/.aws/awssu/myCompany/devOps/config
```

#### Changing a Profile

Chances are that once you pick your region and output format, you'll never need to change it. But you know what happens whenever you say never. So the `awssu config` command is here to help.

```bash
awssu config personal Joseph us-west-1 text

Updating ~/.aws/awssu/personal/Joseph/config
```

Again, just like `awssu remove`, this does not effect the current `default`. You must use `awssu use` to apply the changes to the `default` profile.

```bash
awssu use personal Joseph
```

#### Safe Mode

When you are done working for the day, you might want to remove the `default` profile and thus effectively deactivating all your profiles. You could think of this as a safety precaution. The next time you come back to work, you cannot just assume what the `default` profile is. You must be intentional by setting it with `awssu use`. The `awssu safe` command will put you in safe mode.

```bash
awssu safe

Removing ~/.aws/credentials
Removing ~/.aws/config
```

#### Preexisting AWS CLI profile

If you saved off your original AWS CLI profile files as instructed in the beginning of this post, you can now restore them.

```bash
cp ~/.aws/credentials.original ~/.aws/credentials
cp ~/.aws/config.original ~/.aws/config
```

We covered how to configure the AWS CLI from scratch. But what can you do if you already have configured the AWS CLI with one or more profiles? The `awssu export` command will read both `~/.aws/credentials` and `~/.aws/config`, and for each profile contained within, prompt you for an account name and a user name.

```bash
awssu export
```

For example, what if you had previously configured two profiles? The output might look something like the following:

```text
Enter Account & User for [default]: myCompany devOps

Created ~/.aws/awssu/myCompany/devOps
Adding ~/.aws/awssu/myCompany/devOps/credentials
Adding ~/.aws/awssu/myCompany/devOps/config

Enter Account & User for [joseph]: personal Joseph

Created ~/.aws/awssu/personal/Joseph
Adding ~/.aws/awssu/personal/Joseph/credentials
Adding ~/.aws/awssu/personal/Joseph/config
```
