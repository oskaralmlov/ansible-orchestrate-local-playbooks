# ansible-run-local-playbook

## What is this?
This is me testing an idea that I had for solving 2 problems:
1. Running playbooks locally for increased performance
2. Storing as little hostvars/secrets on the server itself during execution

## What does it do?
This script and playbooks transfers a playbook and hostvars to the target hosts and executes the playbook locally.
It also ensures that you can see the output from the playbook run in your terminal by transfering the output back to you.

## Why this instead of ansible-pull
I'm not ready to go full ansible-pull and have the infrastructure configure itself. I want to control when the
configuration changes and I don't want to store the entire inventory on the servers, potentially exposing secrets
stored in it.

## Good to know
The `run_playbook.sh` script you to not be running the playbook on a host with an external IP address.
To get around this the script connects to `${REPORT_HOST}` in order to setup a socket that is reachable from the target
host.

## How to
1. Edit the inventory to add your hosts
2. Run `playbook_provision.yml` to provision the jumphost and target hosts with the necessary packages
3. Run `run_playbook.sh` with these arguments: `jumphost hostname` `playbook_to_transfer` `target_hosts`

## Example:
```
user@dev:~/ansible-orchestrate-local-playbooks$ ./run_playbook.sh jumphost.example playbook_local.yml example_servers
PLAY [Run a local playbook] *****************************************************************************************

TASK [Create /tmp/hostvars] *****************************************************************************************
ok: [example_server]

TASK [Create /tmp/playbook.yml] *************************************************************************************
ok: [example_server]

TASK [Create /tmp/inventory] ****************************************************************************************
ok: [example_server]

TASK [Run /tmp/playbook.yml on example_server] **********************************************************************

PLAY [example_servers] *********************************************************

TASK [Gathering Facts] *********************************************************
ok: [example_server]

TASK [Prove this works] ********************************************************
ok: [example_server] => {
    "msg": "It works!!"
}

TASK [Print IPv4 address] ******************************************************
ok: [example_server] => {
    "ansible_default_ipv4.address": "85.203.53.7"
}

TASK [Print local hostname] ****************************************************
ok: [example_server] => {
    "ansible_hostname": "proxmox-oskar-1"
}

TASK [Print server groups] *****************************************************
ok: [example_server] => {
    "group_names": [
        "example_servers"
    ]
}

TASK [Print all groups] ********************************************************
ok: [example_server] => {
    "groups": {
        "all": [
            "example_server",
            "example_jumphost"
        ],
        "example_servers": [
            "example_server"
        ],
        "jumphosts": [
            "example_jumphost"
        ],
        "ungrouped": []
    }
}

PLAY RECAP *********************************************************************
example_server             : ok=6    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

ok: [example_server]

PLAY RECAP **********************************************************************************************************
example_server             : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```
