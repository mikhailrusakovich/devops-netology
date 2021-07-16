# Local .terraform directories
# проигнорировать все файлы и папки, вложенные в папку .terraform
**/.terraform/*

# .tfstate files
# проигнорировать все файлы с расширением и содержащие .tfstate
*.tfstate
*.tfstate.*

# Crash log files
# проигнорировать нижеперечисленный файл
crash.log

# Exclude all .tfvars files, which are likely to contain sentitive data, such as
# password, private keys, and other secrets. These should not be part of version 
# control as they are data points which are potentially sensitive and subject 
# to change depending on the environment.
# проигнорировать все файлы с расширением .tfvars
*.tfvars

# Ignore override files as they are usually used to override resources locally and so
# are not checked in
# проигнорировать нижеперечисленные файлы
override.tf
override.tf.json
*_override.tf
*_override.tf.json

# Include override files you do wish to add to version control using negated pattern
#
# !example_override.tf

# Include tfplan files to ignore the plan output of command: terraform plan -out=tfplan
# example: *tfplan*

#проигнорировать файл .terraformrc и файл terraform.tcMy Ignore CLI configuration files
.terraformrc
terraform.rcMy
new line
