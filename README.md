# ansible-stash

This is a collection of [Ansible](https://www.ansible.com/) configurations,
[Makefile](https://www.gnu.org/software/make/manual/make.html) and
[Bash](https://www.gnu.org/software/bash/) scripts to make it ridiculously easy
to set up your web-presence in a reproducable and extendable manner.

It includes setting up a secure base for a server, a website with deploy and
rollback functionality, a secure chat and email forwarding.

All can be tested before going live with a local staging server running
[Ubuntu](https://ubuntu.com/), provided by
[VirtualBox](https://www.virtualbox.org/) and
[Vagrant](https://www.vagrantup.com/).

## Installation

```bash
make install
```

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
