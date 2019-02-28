#!/bin/bash -e
#!/bin/bash -exu

if [ ! -e inventory.ini ]
then
    echo Copy either ../deploy/my-kvm.ini or ../deploy/my-pi.ini as inventory.ini
    echo
    echo '    cp ../deploy/my-kvm.ini inventory.ini'
    echo or
    echo '    cp ../deploy/my-pi.ini inventory.ini'
    echo
    echo then edit it to update the IP and credential to access your server
    exit 1
fi

PLAYBOOK=${1:-../deploy/setup.yml}

ansible-playbook -i inventory.ini $PLAYBOOK
