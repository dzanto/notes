```sh
VSPHERE_USER_NAME='user'
VSPHERE_PASS='pass'
VSPHERE_URL='url'
```

# Create a rest api session using curl
https://linuxtutorials.org/vcenter-rest-api-examples-curl/

```sh
VSPHERE_TOKEN=$(curl -s -k -X POST https://$VSPHERE_URL/rest/com/vmware/cis/session -u  $VSPHERE_USER_NAME:$VSPHERE_PASS | jq --raw-output .value)
```
#Версии API
6.5 - 7 версия использует: $VSPHERE_URL/rest/com/vmware/
8 версия: $VSPHERE_URL/api/

# Ошибка в rancher. Увидеть можно в логах job local кластера

> Failed creating server [fleet-default/test-worker-41c730d2-gh4f8] of kind (VmwarevsphereMachine) for machine test-worker-64c69fb695-2sh4w in infrastructure provider: CreateError: Running pre-create checks... (test-worker-41c730d2-gh4f8) Connecting to vSphere for pre-create checks... (test-worker-41c730d2-gh4f8) Using datacenter /DataLine-2 (test-worker-41c730d2-gh4f8) Using network /DataLine-2/network/med-test (test-worker-41c730d2-gh4f8) Using ResourcePool /DataLine-2/host/vSAN-DEV/Resources/dev/test/k8s Creating machine... (test-worker-41c730d2-gh4f8) Generating SSH Keypair... (test-worker-41c730d2-gh4f8) Using datacenter /DataLine-2 (test-worker-41c730d2-gh4f8) Using network /DataLine-2/network/med-test (test-worker-41c730d2-gh4f8) Using ResourcePool /DataLine-2/host/vSAN-DEV/Resources/dev/test/k8s (test-worker-41c730d2-gh4f8) creating VM from /Linux/linux-oracle-9.3-main... Error creating machine: Error in driver during machine creation: POST https://url:443/rest/com/vmware/content/library?~action=find: 403 Forbidden The default lines below are for a sh/bash shell, you can specify the shell you're using, with the --shell flag. 

https://www.postman.com/fabxoe/workspace/vcenter-api/request/9432753-f6a0edaf-dee8-411b-b845-243d3fea56ce

```sh
# смотрим какие есть типы.
#похоже не то.
# curl -k https://$VSPHERE_URL:443/rest/com/vmware/content/type -H "vmware-api-session-id: $VSPHERE_TOKEN" | jq

# список content library
curl -s -k -X GET -H "vmware-api-session-id: $VSPHERE_TOKEN"  https://$VSPHERE_URL/rest/com/vmware/content/library | jq

# Получаем инфо о content library
curl -s -k -X GET -H "vmware-api-session-id: $VSPHERE_TOKEN"  https://$VSPHERE_URL/api/content/library/b4a579ce-3938-4fce-9db8-60166a9db107 | jq

# Запрос на который rancher получает 403 ошибку:
curl -s -k -X POST https://$VSPHERE_URL/rest/com/vmware/content/library?~action=find -H "vmware-api-session-id: $VSPHERE_TOKEN" \
--header 'Content-Type: application/json' \
--data '
{
    "spec": {
        "name": "Linux",
        "type": "LOCAL"
    }
}'

curl -s -k -X POST https://$VSPHERE_URL/rest/com/vmware/vcenter/ovf/library-item/id:8cdd35c0-6b57-476f-acc1-966c6794f6e7?~action=deploy -H "vmware-api-session-id: $VSPHERE_TOKEN" \
--header 'Content-Type: application/json' \
--data '
{
    "target": {
        "resource_pool_id": "/DataLine-2/host/vSAN-DEV/Resources/dev/test/k8s"
    },
    "deployment_spec": {
        "name": "my-test-content-library-vm",
        "annotation": "string",
        "accept_all_EULA": false,
        "storage_provisioning": "string",
        "storage_profile_id": "string",
        "locale": "string",
        "flags": [
            "string"
        ],
        "additional_parameters": [
            {}
        ],
        "default_datastore_id": "/DataLine-2/datastore/VsanDatastoreDev"
    }
}'

curl -s -k https://$VSPHERE_URL/rest/com/vmware/vcenter/ovf/library-item/id:b1e9bfef-e74f-4b0d-8811-30717beb7788

# новая версия API

curl -s -k -X POST https://$VSPHERE_URL/api/vcenter/ovf/library-item/b1e9bfef-e74f-4b0d-8811-30717beb7788?~action=deploy -H "vmware-api-session-id: $VSPHERE_TOKEN" \
--header 'Content-Type: application/json' \
--data '
{
    "target": {
        "resource_pool_id": "/DataLine-2/host/vSAN-DEV/Resources/dev/dev/rnd-k8s"
    },
    "deployment_spec": {
        "name": "my-test-content-library-vm",
        "annotation": "string",
        "accept_all_EULA": false,
        "storage_provisioning": "string",
        "storage_profile_id": "string",
        "locale": "string",
        "flags": [
            "string"
        ],
        "additional_parameters": [
            {}
        ],
        "default_datastore_id": "/DataLine-2/datastore/VsanDatastoreDev"
    }
}'

# старая версия api
curl -s -k -X POST https://$VSPHERE_URL/rest/com/vmware/vcenter/ovf/library-item/id:8cdd35c0-6b57-476f-acc1-966c6794f6e7?~action=deploy -H "vmware-api-session-id: $VSPHERE_TOKEN" \
--header 'Content-Type: application/json' \
--data '
{
    "target": {
        "resource_pool_id": "rnd-k8"
    },
    "deployment_spec": {
        "name": "my-test-content-library-vm",
        "default_datastore_id": "datastore-13"
    }
}' | jq

# инфа о linux-oracle-8.8-main шаблоне
curl -s -k https://$VSPHERE_URL/rest/com/vmware/content/library/item/id:8cdd35c0-6b57-476f-acc1-966c6794f6e7 -H "vmware-api-session-id: $VSPHERE_TOKEN" | jq


curl -s -k https://$VSPHERE_URL/api/vcenter/ovf/library-items/8cdd35c0-6b57-476f-acc1-966c6794f6e7 -H "vmware-api-session-id: $VSPHERE_TOKEN" | jq

curl -s -k -H "vmware-api-session-id: $VSPHERE_TOKEN" https://$VSPHERE_URL/api/vcenter/resource-pool | jq
curl -s -k -H "vmware-api-session-id: $VSPHERE_TOKEN" https://$VSPHERE_URL/api/vcenter/resource-pool/resgroup-48087 | jq

```

https://url/ui/app/content-libraries/cl-item/urn:vapi:com.vmware.content.library.Item:8cdd35c0-6b57-476f-acc1-966c6794f6e7:8fb811ae-c1d2-4872-bbe2-17d1b78f6e04/summary?navigator=tree

rest/com/vmware/content/type 


 Failed creating server [fleet-default/test-worker-41c730d2-cqpf5] of kind (VmwarevsphereMachine) for machine test-worker-64c69fb695-rzvb7 in infrastructure provider: CreateError: Running pre-create checks... (test-worker-41c730d2-cqpf5) Connecting to vSphere for pre-create checks... (test-worker-41c730d2-cqpf5) Using datacenter /DataLine-2 (test-worker-41c730d2-cqpf5) Using network /DataLine-2/network/med-test (test-worker-41c730d2-cqpf5) Using ResourcePool /DataLine-2/host/vSAN-DEV/Resources/dev/test/k8s Creating machine... (test-worker-41c730d2-cqpf5) Generating SSH Keypair... (test-worker-41c730d2-cqpf5) Using datacenter /DataLine-2 (test-worker-41c730d2-cqpf5) Using network /DataLine-2/network/med-test (test-worker-41c730d2-cqpf5) Using ResourcePool /DataLine-2/host/vSAN-DEV/Resources/dev/test/k8s (test-worker-41c730d2-cqpf5) creating VM from /Linux/linux-oracle-9.3-main... (test-worker-41c730d2-cqpf5) Finding datastore VsanDatastoreDev Error creating machine: Error in driver during machine creation: POST https://url:443/rest/com/vmware/vcenter/ovf/library-item/id:b1e9bfef-e74f-4b0d-8811-30717beb7788?~action=deploy: 403 Forbidden The default lines below are for a sh/bash shell, you can specify the shell you're using, with the --shell flag. 

  Failed creating server [fleet-default/test-master-a44dbeb7-4t52g] of kind (VmwarevsphereMachine) for machine test-master-698fbc5b6c-8mz2d in infrastructure provider: CreateError: Running pre-create checks... (test-master-a44dbeb7-4t52g) Connecting to vSphere for pre-create checks... (test-master-a44dbeb7-4t52g) Using datacenter /DataLine-2 (test-master-a44dbeb7-4t52g) Using network /DataLine-2/network/med-test (test-master-a44dbeb7-4t52g) Using ResourcePool /DataLine-2/host/vSAN-DEV/Resources/dev/test/k8s Creating machine... (test-master-a44dbeb7-4t52g) Generating SSH Keypair... (test-master-a44dbeb7-4t52g) Using datacenter /DataLine-2 (test-master-a44dbeb7-4t52g) Using network /DataLine-2/network/med-test (test-master-a44dbeb7-4t52g) Using ResourcePool /DataLine-2/host/vSAN-DEV/Resources/dev/test/k8s (test-master-a44dbeb7-4t52g) creating VM from /Linux/linux-oracle-9.3-main... (test-master-a44dbeb7-4t52g) Finding datastore /DataLine-2/datastore/datastore-esxi-main-02 Error creating machine: Error in driver during machine creation: POST https://url:443/rest/com/vmware/vcenter/ovf/library-item/id:b1e9bfef-e74f-4b0d-8811-30717beb7788?~action=deploy: 403 Forbidden The default lines below are for a sh/bash shell, you can specify the shell you're using, with the --shell flag. 


cloud_credential_secret_name


https://url/ui/app/content-libraries/cl-item/urn:vapi:com.vmware.content.library.Item:8cdd35c0-6b57-476f-acc1-966c6794f6e7:8fb811ae-c1d2-4872-bbe2-17d1b78f6e04/summary?navigator=tree

https://url/ui/app/content-libraries/cl-item/urn:vapi:com.vmware.content.library.Item:b1e9bfef-e74f-4b0d-8811-30717beb7788:8fb811ae-c1d2-4872-bbe2-17d1b78f6e04/summary?navigator=tree


Error creating machine: Error in driver during machine creation: POST rest/com/vmware/vcenter/ovf/library-item 403 Forbidden


https://developer.broadcom.com/xapis/vsphere-automation-api/v7.0u3/vcenter/api/vcenter/ovf/library-item/ovf_library_item_id__action=deploy/post/
https://developer.broadcom.com/xapis/vsphere-automation-api/v6.5-v7.0u2/content/rest/com/vmware/content/library/item/id__~action=publish/post/


 Failed creating server [fleet-default/test-content-library-pool1-ef702dc5-8bwmb] of kind (VmwarevsphereMachine) for machine test-content-library-pool1-95bfb459b-6kphw in infrastructure provider: CreateError: Running pre-create checks... (test-content-library-pool1-ef702dc5-8bwmb) Connecting to vSphere for pre-create checks... (test-content-library-pool1-ef702dc5-8bwmb) Using datacenter /DataLine-2 (test-content-library-pool1-ef702dc5-8bwmb) Using ResourcePool /DataLine-2/host/vSAN-DEV/Resources/dev/dev/rnd-k8s Creating machine... (test-content-library-pool1-ef702dc5-8bwmb) Generating SSH Keypair... (test-content-library-pool1-ef702dc5-8bwmb) Using datacenter /DataLine-2 (test-content-library-pool1-ef702dc5-8bwmb) Using network /DataLine-2/network/VM Network (test-content-library-pool1-ef702dc5-8bwmb) Using ResourcePool /DataLine-2/host/vSAN-DEV/Resources/dev/dev/rnd-k8s (test-content-library-pool1-ef702dc5-8bwmb) creating VM from /Linux/linux-oracle-8.8-main... (test-content-library-pool1-ef702dc5-8bwmb) Finding datastore /DataLine-2/datastore/VsanDatastoreDev Error creating machine: Error in driver during machine creation: POST https://url:443/rest/com/vmware/vcenter/ovf/library-item/id:8cdd35c0-6b57-476f-acc1-966c6794f6e7?~action=deploy: 403 Forbidden The default lines below are for a sh/bash shell, you can specify the shell you're using, with the --shell flag. 


  Failed creating server [fleet-default/test-content-library-pool1-8700ba9f-fqzdl] of kind (VmwarevsphereMachine) for machine test-content-library-pool1-6f49f47fd5-dv7vw in infrastructure provider: CreateError: Running pre-create checks... (test-content-library-pool1-8700ba9f-fqzdl) Connecting to vSphere for pre-create checks... (test-content-library-pool1-8700ba9f-fqzdl) Using datacenter /DataLine-2 (test-content-library-pool1-8700ba9f-fqzdl) Using ResourcePool /DataLine-2/host/vSAN-DEV/Resources/dev/dev/rnd-k8s Creating machine... (test-content-library-pool1-8700ba9f-fqzdl) Generating SSH Keypair... (test-content-library-pool1-8700ba9f-fqzdl) Using datacenter /DataLine-2 (test-content-library-pool1-8700ba9f-fqzdl) Using network /DataLine-2/network/VM Network (test-content-library-pool1-8700ba9f-fqzdl) Using ResourcePool /DataLine-2/host/vSAN-DEV/Resources/dev/dev/rnd-k8s (test-content-library-pool1-8700ba9f-fqzdl) creating VM from /Linux/CL-OracleLinux-R8-U8... (test-content-library-pool1-8700ba9f-fqzdl) Finding datastore /DataLine-2/datastore/VsanDatastoreDev Error creating machine: Error in driver during machine creation: POST https://url:443/rest/com/vmware/vcenter/ovf/library-item/id:135dcc89-55b5-4640-9940-4c525c723995?~action=deploy: 403 Forbidden The default lines below are for a sh/bash shell, you can specify the shell you're using, with the --shell flag. 

# id linux template oracle-8
8cdd35c0-6b57-476f-acc1-966c6794f6e7

{
    "client_token": "",
    "deployment_spec": {
        "accept_all_EULA": false,
        "additional_parameters": [ { } ],
        "annotation": "",
        "default_datastore_id": "VsanDatastoreDev",
        "flags": [ "" ],
        "locale": "",
        "name": "cl-test-vm",
        "network_mappings": [
                "4000": {
                    "start_connected": true,
                    "pci_slot_number": 192,
                    "upt_v2_compatibility_enabled": false,
                    "backing": {
                            "connection_cookie": 1713887798,
                            "distributed_port": "5592582e-087f-45a9-b812-0b04f783210c",
                            "distributed_switch_uuid": "50 27 28 99 39 55 5f c4-c1 90 ca fa d9 f2 be 4b",
                            "type": "DISTRIBUTED_PORTGROUP",
                            "network": "dvportgroup-86025"
                        },
                    "mac_type": "ASSIGNED",
                    "allow_guest_control": true,
                    "wake_on_lan_enabled": true,
                    "label": "Network adapter 1",
                    "state": "CONNECTED",
                    "type": "VMXNET3",
                    "upt_compatibility_enabled": true
                }
        ],
        "storage_mappings": [ { } ],
        "storage_profile_id": "",
        "storage_provisioning": "thin",
        "vm_config_spec": {
            "provider": "XML",
            "xml": ""
        }
    },
    "target": {
        "folder_id": "test",
        "host_id": "",
        "resource_pool_id": "rnd-k8s"
    }
}

ovf/library_item


docker run --rm -it --env-file env-file lamw/deploy-vm-from-content-library



# govc

https://github.com/vmware/govmomi/releases

качаем и устанавливаем rpm
VSPHERE_USER_NAME='user'
VSPHERE_PASS='pass'

export GOVC_URL='"rancher-exp:pass"@url'
export GOVC_INSECURE=1
export GOVC_FOLDER="/"
export GOVC_RESOURCE_POOL=rnd-k8s

export GOVC_DATACENTER=DataLine-2
export GOVC_NETWORK=med-dev
export GOVC_DATASTORE=VsanDatastoreDev
export GOVC_FOLDER="/DataLine-2/vm/test"
export GOVC_RESOURCE_POOL=rnd-k8s

govc library.deploy /Linux/linux-oracle-8.8-main vm_name2


# в результате 403 ошибка возникала из-за спец символов в пароле