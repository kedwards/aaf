# AAF - Ansible, AWS & Friends

## Requirements

the requirements can be installed via the initialize.sh file or see the sections below for manual installation.

```bash
./initialize.sh -e
```

### System

- ansible
- git
- golang
- make
- python3

### Python Libs

- botocore
- boto3
- boto
- configparser
- jsonschema
- cfn-lint
- git-remote-codecommit

### Go Libs

- rain (formerly cfn-format)


#### System

```bash
sudo apt install -y git golang-go python3-pip python3-venv
```

#### Python Libs

##### using venv

```bash
# create and activate virtual environment
python -m venv ~/.aaf && source ~/.aaf/bin/activate
```

##### using pyenv

```bash
# create a virtual environment
pyenv virtualenv aaf && pyenv activate aaf
```

```bash
# install requirements
pip install -r requirements.txt
```

#### Go Libs

```bash
go install github.com/aws-cloudformation/rain/cmd/rain@latest
```

## Usage

this project uses make to facilitate commands

Ansible roles are used to configure and deploy application modules

### Linting & Formatting

There are two available linters, one for the ansible code and the other for cloudformation templates.

The below command will run all linters

```bash
make lint
```

#### Ansible

- Ansible Liint [ansible-lint](https://ansible.readthedocs.io/projects/lint/)

```bash
make lint-ansible
```
 
#### Cloudformation

- Cloudformation Lint [cfn-lint](https://github.com/aws-cloudformation/cfn-lint)
- Cloudformation Format [rain](https://github.com/aws-cloudformation/rain)

```bash
make lint-cfn
```

### Plays

The available plays

- setup
- infra
- network
- compute
- lambda


```bash
make deploy PLAY=<play> ENV=<env> REGION=<region> [ EXVARS=<extra_vars> ]
```

#### Running Plays

**setup**

```bash
make deploy PLAY=setup PREFIX=qp-wizzard ENV=wtf REGION=us-west-2
```
