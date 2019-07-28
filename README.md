# K8s HA Lab
Resources to privisonate a High Avaliable K8s cluster using Vangant and Rancher RKE. this enviroment also  can be used to get a Rancher HA.
## What this will create
This will create 4 linux virtual machines
* m-1 is a nginx loadbalancer
* m-2..m-4 are Ubuntu machines with docker in the latest stable version
## How to use

* [Install RKE](https://rancher.com/docs/rke/latest/en/installation/#download-the-rke-binary) in your machine;   
* Clone this repository:
```sh
$ git clone https://github.com/apecnascimento/K8sHALab.git
$ cd K8sHALab
```
* Create all machines with the command: 
```sh
$ vagrant up
```
* Check if all machines are up and running:
```sh
$ vagrant status
Current machine states:

m-1                       running (virtualbox)
m-2                       running (virtualbox)
m-3                       running (virtualbox)
m-4                       running (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
```

* Create the k8s cluster with RKE:
```sh
$ rke up --config ./rancher-cluster.yml
```
* If nothing blow up \o/, have a good study sessions.