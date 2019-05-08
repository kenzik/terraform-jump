## terraform configs for basic linux/jump/whatever server

SSH has been hardened with cloud-init. Modify to your liking for your distro. Uncomment the docker installation if you want to containerize the things.

See linux/variables.tf + base.tf for options.

Set options in Makefile, then:

- ```terraform init```
- ```make plan```
- ```make apply```
- ```terraform output --module=linux```
- ```make destroy``` when done

