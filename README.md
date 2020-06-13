# ansible_trunk

## Install Ansible and dependencies

`make install`

This will first install Ansible on your machine by runnning
`ansible_install.sh`. It works for Debian and Ubuntu.

After that, the Ansible playbook `dependencies_install.yml` will be executed.
It installs VirtualBox and Vagrant.

## Create a local staging server

`make staging_init`

This will download and start a virtual machine that is defined in `Vagrantfile`.
The playbook `initial_server_setup.yml` is executed when provisioning the VM. It
makes the following changes:

- Installs `python3`, needed by Ansible
- Update `apt` cache and upgrade installed packages
- Creates a swapfile
- Creates a `wheel` group with passwordless sudo configuration
- Creates a `ansible` user in the `wheel` group, add local `~/.ssh/id_rsa.pub` SSH key for authorization
- Enables UFW and opens SSH port
- Disable SSH root and password login
- If on Ubuntu, disable telemetry, block domains, disable MOTD news, disable MOTD sections

It will also remove previous entries of `127.0.0.1:22522` from
`~/.ssh/known_hosts` to avoid conflicts.

## SSH into staging server

`make staging_ssh`

## Conventions

### Strings

```yaml
# Incorrect

setting: {{ var }}
setting: '{{ var }}'
setting: "pure string"
setting: string with a {{ var }}
setting: /a/path/to/somewhere

# Correct

setting: "{{ var }}"
setting: pure string
setting: "string with a {{ var }}"
setting: "/a/path/to/somewhere"
```

### Booleans

```yaml
# Incorrect

Yes yes No no True TRUE False FALSE

# Correct

true false
```

### Conditionals

```yaml
# Incorrect

when: thing
when: thing is true
when: thing is false
when: some_long_role_variable == true and some_other_very_long_variable == false or exceeds_80_characters == true

# Correct

when: thing == true # explicitly check for `true`
when: thing == false
when: >
  some_long_role_variable == true and
  some_other_very_long_variable == false or
  exceeds_80_characters == false
```

### Task naming

```yaml
# Incorrect

name: It's like a sentence describing what it does
name: references to the role name, like 'start Nginx'

- name: set fact
  set_fact:
    thing: true

- name: get stat
  register: output
  stat:
    path: "/to/some/path"

# Correct

name: lowercase and kept short
name: start service

- set_fact:
    thing: true

- register: output
  stat:
    path: "/to/some/path"

```

### Task arguments order

```yaml
# Incorrect

- name: install package
  apt:
    name: thing
    state: present
  register: output
  when: something == true

# Correct

- name: install package
  when: something == true
  register: output
  apt:
    name: thing
    state: present
```

### Long strings, commands

```yaml
# Incorrect

command: executable --with --some "very long arguments" --exceeding {{ var }} --characters

# Correct

command: >
  executable \
  --with \
  --some "very long arguments" \
  --exceeding {{ var }} \
  --characters
```

### Recurring conditionals

```yaml
# Incorrect

- name: install some package
  when: thing == true
  apt:
    name: some
    state: present

- name: install other package
  when: thing == true
  apt:
    name: other
    state: present

# Correct

- name: install packages
  when: thing == true
  include_tasks: install_packages.yml

# install_packages.yml
- name: install some package
  apt:
    name: some
    state: present

- name: install other package
  apt:
    name: other
    state: present
```

### Role variable names

```yaml
# Incorrect

some_variable

# Correct

role_name_some_variable # prefixed role name
```

### Sub-function for roles

```yaml
# Incorrect

sub_function_is_triggered: true

# Correct

sub_function_is_triggered: false # must be explicitely set by the playbook
```
