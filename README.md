# Telepresence

## Table of Content

  - [Introduction](#introduction)
  - [Before you begin](#before-you-begin)
    - [K8s cluster setup using minikube](#k8s-cluster-setup-using-minikube)
    - [Source code for the examples used in the walkthrough.](#source-code-for-the-examples-used-in-the-walkthrough)
  - [Installing telepresence](#installing-telepresence)
    - [Installing telepresence traffic manager on your K8s cluster](#installing-telepresence-traffic-manager-on-your-k8s-cluster)
    - [Installing telepresence daemon on the workstation](#installing-telepresence-daemon-on-the-workstation)
      - [Linux](#linux)
      - [macOS](#macos)
      - [Windows](#windows)
  - [Workflow 1: Using telepresence to develop code on the K8s cluster from your workstation](#workflow-1-using-telepresence-to-develop-code-on-the-k8s-cluster-from-your-workstation)
    - [Steps to create the example1 one deployment on K8s cluster](#steps-to-create-the-example1-one-deployment-on-k8s-cluster)
    - [Steps to run the example1 code on your workstation](#steps-to-run-the-example1-code-on-your-workstation)
    - [Steps to use Telepresence for developing the code live on the cluster](#steps-to-use-telepresence-for-developing-the-code-live-on-the-cluster)
  - [Workflow 2: Using telepresence to set up your local development workspace](#workflow-2-using-telepresence-to-set-up-your-local-development-workspace)
    - [Steps to create the example2  deployment on K8s cluster](#steps-to-create-the-example2--deployment-on-k8s-cluster)
    - [Steps to use telepresence for setting up your local development workspace](#steps-to-use-telepresence-for-setting-up-your-local-development-workspace)
  - [Workflow 3: Using telepresence to debug your code at the K8s cluster level](#workflow-3-using-telepresence-to-debug-your-code-at-the-k8s-cluster-level)
    - [Steps to create the example3 one deployment on the K8s cluster](#steps-to-create-the-example3-one-deployment-on-the-k8s-cluster)
    - [Steps to run the example3 code on your workstation](#steps-to-run-the-example3-code-on-your-workstation)
    - [Steps to use telepresence to debug your code at the K8s cluster level](#steps-to-use-telepresence-to-debug-your-code-at-the-k8s-cluster-level)
  - [Workflow 4: Using telepresence for automated testing of cloud-native code](#workflow-4-using-telepresence-for-automated-testing-of-cloud-native-code)
    - [Steps to create the example4 deployment on K8s cluster](#steps-to-create-the-example4-deployment-on-k8s-cluster)
    - [Steps to create a script to test the K8s workloads with telepresence](#steps-to-create-a-script-to-test-the-k8s-workloads-with-telepresence)

## Introduction

Modern microservices-based applications that are deployed into Kubernetes often consist of tens or hundreds of services. The resource constraints and a number of these services mean that it is often difficult or impossible to run all of this on a local development machine, which makes fast development and debugging very challenging.

Telepresence enables you to connect your local development machine seamlessly to the K8s cluster via a two-way proxying mechanism. This enables you to code locally and run the majority of your services within a K8s cluster.

This document provides walkthroughs to utilize telepresence in local development.

## Before you begin
We need a K8s cluster to follow the workflow demonstrations. We recommend minikube for creating the K8s cluster on your workstation.

### K8s cluster setup using minikube
1. [Install minikube](https://minikube.sigs.k8s.io/docs/start/)
2. To create a minikube cluster run.
      
      `minikube start`
### Source code for the examples used in the walkthrough.
To follow along with the walkthrough with the same examples showcased in upcoming sections, please download the [source code]( https://github.mathworks.com/development/mw-example-telepresence).

You can clone/download the source code in the following ways:

    1)Go to https://github.mathworks.com/development/mw-example-telepresence -> Code -> Download zip -> extract the code from zip
 
    2) $ git clone git clone https://github.mathworks.com/development/mw-example-telepresence.git

## Installing telepresence
### Installing telepresence traffic manager on your K8s cluster
We will be using Helm to install the telepresence traffic manager on your K8s cluster. If you do not have the helm, you can install it from [here](https://helm.sh/docs/intro/install/). Next, follow the below steps
1. Add the Required helm repository.
      
        $ helm repo add mw-helm http://mw-helm-repository.mathworks.com/artifactory/mw-helm 
        "mw-helm" has been added to your repositories
2. Create ambassador namespace.

        $ kubectl create namespace ambassador 
        namespace/ambassador created
3. Run the below commands to deploy the telepresence traffic manager to your K8s cluster.

       #Obtain the values.yaml file
       #You can find the values.yaml file in the directory mw-example-telepresence/traffic-manager-helm-values/values.yaml, if you have downloaded the source code. If
       not run the below command with your access token
       $ curl https://github.mathworks.com/development/mw-example-telepresence/blob/main/traffic-manager-helm-values/values.yaml?token=<youraccess token> >values.yaml
       
       #The below command deploys the telepresence traffic manager with configurations in values.yaml
       $ helm install traffic-manager --namespace ambassador mw-helm/telepresence --version 2.10.4 -f values.yaml
       NAME: traffic-manager
       LAST DEPLOYED: Tue Apr  4 15:05:53 2023
       NAMESPACE: ambassador
       STATUS: deployed
       REVISION: 1
       NOTES:
       --------------------------------------------------------------------------------
       Congratulations!
 
 
       You have successfully installed the Traffic Manager component of Telepresence!
       Now your users will be able to `telepresence connect` to this Cluster and create intercepts for their services!

### Installing telepresence daemon on the workstation
Install Telepresence by running the respective commands below for your OS.

#### Linux

    # 1.Copy telepresence binary from //mathworks/hub/3rdparty/internal/9506312/glnxa64/Telepresence/ to any buffer directory (the binary will be moved to actual path in 3rd step)
    $ cp //mathworks/hub/3rdparty/internal/9506312/glnxa64/Telepresence/telepresence ~/Downloads
        
    # 2.Make it an executable
    $ chmod a+x ~/Downloads/telepresence
       
    # 3.Move the file to /usr/local/bin
    $ sudo mv ~/Downloads/telepresence /usr/local/bin/

#### macOS

    # Intel Macs
 
    # 1. Copy telepresence binary from //mathworks/hub/3rdparty/internal/9506312/maci64/Telepresence to any buffer directory (the binary will be moved to actual path in next step)
    $ cp //mathworks/hub/3rdparty/internal/9506312/maci64/Telepresence/telepresence ~/Downloads
 
    # 2.Move the file to /usr/local/bin
    $sudo mv ~/Downloads/telepresence /usr/local/bin
 
    # Apple silicon Macs
    # 1. Copy telepresence binary from //mathworks/hub/3rdparty/internal/9506312/maca64/Telepresence to any buffer directory (the binary will be moved to actual path in next step)
    $ cp //mathworks/hub/3rdparty/internal/9506312/maca64/Telepresence/telepresence ~/Downloads
 
    # 2.Move the file to /usr/local/bin
    $sudo mv ~/Downloads/telepresence /usr/local/bin
#### Windows

    # To install Telepresence, run the following commands in PowerShell as admin
 
    # 1. Copy telepresence zip file from 3rdparty/internal/9506312/win64/Telepresence to any buffer directory (the binary will be moved to actual path in 3rd step)
    PS C:\Users\maheshp> cp \\mathworks\BGL\hub\3rdparty\internal\9506312\win64\Telepresence\telepresence.zip .\Downloads\
 
 
    # 2.Navigate to the folder containing the downloaded file and  unzip the telepresence.zip file to the desired directory, then remove the zip file
    PS C:\Users\maheshp\Downloads> Expand-Archive -Path telepresence.zip -DestinationPath telepresenceInstaller/telepresence
    PS C:\Users\maheshp\Downloads>Remove-Item 'telepresence.zip'
    PS C:\Users\maheshp\Downloads> cd .\telepresenceInstaller\telepresence\
 
 
    # 3. Run the install-telepresence.ps1 to install telepresence's dependencies. It will install telepresence to
    # C:\telepresence by default, but you can specify a custom path by passing in -Path C:\my\custom\path
    PS C:\Users\maheshp\Downloads\telepresencInstaller\telepresence\> powershell.exe -ExecutionPolicy bypass -c " . '.\install-telepresence.ps1';"
     
    # 4. Remove the unzipped directory: 
    PS C:\Users\maheshp\Downloads\telepresencInstaller\telepresence\> cd ../..
    PS C:\Users\maheshp\Downloads>Remove-Item telepresenceInstaller -Recurse -Confirm:$false -Force
 
    # 5. Telepresence is now installed and you can use telepresence commands in PowerShell

## Workflow 1: Using telepresence to develop code on the K8s cluster from your workstation
Before we proceed let's take a look at some pre-requisites.

1. Telepresence can be used to intercept the traffic from the following types of K8s workload
      1. [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
      2. [ReplicaSet](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/)
      3. [StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)
2. The Workload should have a [K8s service](https://kubernetes.io/docs/concepts/services-networking/service/) associated with it (ClusterIP, NodePort, LoadBalancer)
3. The current context in your config file in the .kube folder should point to the K8s cluster where you want to use telepresence.
4. If you want to avoid downtime of the microservice you are trying to intercept, then make sure the code of the microservice is running on the workstation

In the following walkthrough, we will use an HTTP server written in Golang which serves an HTML static file, we will update the code in the workstation and telepresence
will enable us to see the results at the K8s cluster.

To set this up, download the source code as mentioned [here](#source-code-for-the-examples-used-in-the-walkthrough) and navigate to mw-example-telepresence/example1/

    [maheshp@vdi-dd1bgl-022:~/Desktop] ...
    $ ls
    mw-example-telepresence/
 
    $ cd mw-example-telepresence/example1/
### Steps to create the example1 one deployment on K8s cluster
| Id |Steps| Details |
|:--:|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|---------|
| 1  | First, we will create the container image, navigate to the example1-image folder and build the docker image (pointing to the localhost registry) and load it to minikube |<pre>#Current directory <br>$ pwd<br>/home/maheshp/Desktop/mw-example-telepresence/example1<br> <br>#Navigate to example1-image <br>$ cd example1-image/ <br># Building the image <br>$ docker build -t example1 .<br>#Load the image to minikube <br>$ minikube image load example1 <br> <br>#Navigate back to application directory<br>$cd .</pre> <br>|
| 2  | Create the deployment using the "my-microservice" helm chart in the directory example1/helm/                                                                             |<pre>#Navigate to helm directory<br>$ cd helm/<br><br>$ pwd<br>/home/maheshp/Desktop/mw-example-telepresence/example1/helm<br><br><br>#helm install <name of release><br>$ helm install example1 my-microservice<br><br>#Navigate back to example1 folder<br>$ cd ..<br><br><br>#Once the Deployments are ready we can launch the service in browser with minikube service <service name><br>$ minikube service example1-my-microservice<br></pre>|
| 3  | We can see that there is a hello message from the K8s cluster is being served at the K8s node port.                                                                      |   <pre>#Once the Deployments are ready we can launch the service in browser with "minikube service <service name><br>$ minikube service mahesh-my-microservice<br>\|-----------\|------------------------\|-------------\|---------------------------\|<br>\| NAMESPACE \|          NAME          \| TARGET PORT \|            URL            \|<br>\|-----------\|------------------------\|-------------\|---------------------------\|<br>\| default   \| example1-my-microservice \| http/5000   \| http://192.168.49.2:30260 \|<br>\|-----------\|------------------------\|-------------\|---------------------------\|<br>🎉  Opening service default/example1-my-microservice in default browser...<br> <br>#This will provide <the Node-IP>:<Node-Port> URL and launch the same in your default browser.<br></pre>  ![image1](images/workflow1/image1.png)    |

### Steps to run the example1 code on your workstation
| Id |Steps| Details |
|:--:|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|---------|
| 1  | Now to run the code locally make sure you have Golang installed, you can do it from [here](https://mathworks.sharepoint.com/sites/devu/go/SitePages/Setup-the-development-environment-in-Go.aspx?ga=1#install-golang) | |
| 2  | Run the example1/main.go file. |  <pre>#Current directory<br>$ pwd<br>/home/maheshp/Desktop/mw-example-telepresence/example1<br> <br>$ ls<br>example1-image/  go.mod  helm/  main.go  readme-example1  static/<br> <br># Run the golang http server<br>  go run main.go<br></pre>       |
| 3  | The index.html page in the static folder in the application directory will now be served at the workstation port 5000.                                                                      |   ![image2](images/workflow1/iamge2.png)      |

### Steps to use Telepresence for developing the code live on the cluster
| Id  | Steps  | Details  |
|---|---|---|
| 1  | Create the my-microservice deployment in your minikube cluster as mentioned [here](#steps-to-create-the-example1-one-deployment-on-k8s-cluster)  | <pre>$ kubectl get deployment<br>NAME                     READY   UP-TO-DATE   AVAILABLE   AGE<br>example1-my-microservice   1/1     1            1           5m39s<br></pre> |
| 2  | Connect to telepresence to the minikube cluster.                                 | <pre>#This will connect the telepresence daemon on your workstation with telepresence traffic manager on the K8s cluster.<br>$ telepresence connect<br>Connected to context minikube (https://192.168.49.2:8443)<br></pre> |   |
| 3  | You can then list the workloads available for intercepting| <pre>$ telepresence list<br>example1-my-microservice: ready to intercept (traffic-agent not yet installed)<br></pre>|   |
| 4  | <pre>You can intercept the workload with this command<br><br><br><br>Now all the requests to my-microservice are being routed to port 5000 on my workstation.<br></pre>                                                                                                                                                  | <pre>#telepresence intercept <name of workload> --port <port on workstation where your code is listening>  <br>$ telepresence intercept example1-my-microservice --port 5000<br>Using Deployment example1-my-microservice<br>intercepted<br>   Intercept name         : example1-my-microservice<br>   State                  : ACTIVE<br>   Workload kind          : Deployment<br>   Destination            : 127.0.0.1:5000<br>   Service Port Identifier: http<br>   Volume Mount Point     : /tmp/telfs-1428258977<br>   Intercepting           : all TCP requests<br></pre> |   |
| 5  | Run the Golang main.go file in the app directory(example1/main.go)                                                                                                                                                                                                                                                       | <pre><br>#Current directory<br>$ pwd<br>/home/maheshp/Desktop/mw-example-telepresence/example11<br> <br>$ ls<br>example1-image/  go.mod  helm/  main.go  readme-example1  static/<br> <br># Run the golang http server<br>  go run main.go<br></pre> |   |
| 6  | We can see that the request at the K8s cluster's end( 192.168.49.2:31814 which is the minikube cluster IP) is being served by the code running on the workstation.|![image3](images/workflow1/image3.png) <pre>We can see that the request at the K8s cluster's end (192.168.49.2:31814 which is the minikube cluster IP) is being served by the code running on the workstation.<br> <br>You can check your K8s cluster ip on for minkube with below command<br>$ minikube profile list<br>🎉  minikube 1.30.1 is available! Download it: https://github.com/kubernetes/minikube/releases/tag/v1.30.1<br>💡  To disable this notice, run: 'minikube config set WantUpdateNotification false'<br> <br>\|----------\|-----------\|---------\|--------------\|------\|---------\|---------\|-------\|--------\|<br>\| Profile  \| VM Driver \| Runtime \|      IP      \| Port \| Version \| Status  \| Nodes \| Active \|<br>\|----------\|-----------\|---------\|--------------\|------\|---------\|---------\|-------\|--------\|<br>\| minikube \| docker    \| docker  \| 192.168.49.2 \| 8443 \| v1.23.0 \| Running \|     1 \| *      \|<br>\|----------\|-----------\|---------\|--------------\|------\|---------\|---------\|-------\|--------\|<br> <br>#OR<br> <br>#Once the Deployments are ready we can launch the service in browser with "minikube service <service name>"<br>$ minikube service example1-my-microservice<br>\|-----------\|------------------------\|-------------\|---------------------------\|<br>\| NAMESPACE \|          NAME          \| TARGET PORT \|            URL            \|<br>\|-----------\|------------------------\|-------------\|---------------------------\|<br>\| default   \| example1-my-microservice \| http/5000   \| http://192.168.49.2:30260 \|<br>\|-----------\|------------------------\|-------------\|---------------------------\|<br>🎉  Opening service default/example1-my-microservice in default browser...<br> <br>#This will provide <the Node-IP>:<Node-Port> URL of the K8s cluster and launch the same in your default browser.<br></pre> |   | 
| 7  | Now we are good to code on the K8s cluster from the workstation. Make any changes to the code running on your workstation and see results at the K8s cluster's end.                                                                                                                                                      |![image4](images/workflow1/image4.png)<br> You can use any editor, or any tool you usually use when developing locally on your workstation to update the code, and the results will reflect at the K8s cluster's end. |   |
| 8  | **Similarly, users can do multiple changes to their code on their workstation and check the results at the K8s cluster's end without having to, build the image, upload it to the repo and deploy it to see the result at the K8s cluster's end every time. This reduces the iterations of the [inner development loop.](https://www.getambassador.io/docs/telepresence/latest/concepts/devloop#what-is-the-inner-dev-loop)** ||   |
| 9  | Once you are done intercepting you can stop the intercept and disconnect the telepresence. | <pre>#Run the below command to stop the intercept<br>$ telepresence leave example1-my-microservice<br> <br>#Run the below command to disconnect  telepresence<br>$ telepresence quit<br>Telepresence Daemons disconnecting...done<br></pre> |   |
| 10 | To clean up the K8s cluster we can use Helm to uninstall the deployment| <pre>	<br>$ helm uninstall example1<br>release "example1" uninstalled<br></pre> |   |

## Workflow 2: Using telepresence to set up your local development workspace
We will now see how users can use telepresence to extract env variables and volume mounts to mimic the K8s cluster.

The example microservice serves as a static HTML page (in volume mount of the k8s deployment) that will display the value of the env variable defined inside the K8s cluster (at the container level). 

To set this up, download the source code as mentioned [here](#source-code-for-the-examples-used-in-the-walkthrough) and navigate to mw-example-telepresence/example2/

~~~
maheshp@vdi-dd1bgl-022:~/Desktop] ...
$ ls
mw-example-telepresence/
 
$ cd mw-example-telepresence/example2/
~~~
### Steps to create the example2  deployment on K8s cluster
| Id | Steps | Details |
|----|-------|---------|
| 1  |  First, we will create the container image, and navigate to the example2/example2-image folder.<br><br>Build the docker image (pointing to the localhost registry) and load it to minikube.<br></pre>     |     <pre><br>#Current directory<br>$ pwd<br>/home/maheshp/Desktop/mw-example-telepresence/example2<br> <br>#Navigate to example2-image<br>$ cd example2-image/<br> <br># Building the image<br>$ docker build -t example2 .  <br> <br>#Load the image to minikube<br>$ minikube image load example2<br> <br>#Navigate back to application folder<br>$ cd ..<br>    |
| 2  | This static file will be provided to the deployment via a volume mount(host path), hence first we will create index.html in our K8s node      |         |
| 3  |  SSH to the K8s node    |   <pre>#We are using Minkube for creating the K8s cluster with container driver as docker.The below command will ssh to minikube #node<br>$ minikube ssh<br>docker@minikube:~$<br></pre>      |
| 4  |  Create a folder and home.html that will be used in the volume mount.      | <pre> #creating the folder in the mount path<br>`docker@minikube:~$ sudo mkdir /mnt/data`<br> <br>#move to the data folder<br>`docker@minikube:~$cd /mnt/data`<br>`docker@minikube:/mnt/data$ sudo vi home.html`<br> <br>#Add the below html code and save<br>`<!DOCTYPE html>`<br>`<html>`<br>    `<head>`<br>        `<meta charset="UTF-8">`<br> `       <title>Environment variable values declared at container level</title>`<br>`    </head>`<br>`    <body>`<br> `       <h1>Environment Variable Values:</h1>`<br> `       <ul>`<br>  `          <li><strong>{{ .EnvVariableName }} = </strong> {{ .EnvVariableValue }}</li><!-- Display the value of the environment variable here -->`<br> `       </ul>`<br>`    </body>`<br>`</html>`<br> <br>#Exit the node<br>`docker@minikube:~$ exit`<br></pre> **Note if using Windows**: If you are using Windows and have trouble creating the home.html in the minikube node, exit the node and create home.html #in your local and then run minikube cp ./home.html minikube:/mnt/data/home.html                                   |
| 5  |   Create the deployment using the "my-microservice" helm chart in example2/helm directory    |  <pre>#Navigate to helm directory<br>$ cd helm/<br> <br>$ pwd<br>/home/maheshp/Desktop/mw-example-telepresence/example2/helm<br> <br>#helm install <name of release><br>$ helm install example2 my-microservice<br> <br>#Once the Deployments are ready we can launch the service in browser with minikube service <service name><br>$ minikube service example2-my-microservice<br></pre>       |
| 6  |   We can see that the home.html in the volume mount is now being served with environment variables at the K8s cluster level like KUBERNETETETES_SERVICE_HOST AND KUBERNETETETES_SERVICE_PORT,  at the K8s Cluster node port.   | <pre>#Once the Deployments are ready we can launch the service in browser with "minikube service <service name>"<br>$ minikube service example2-my-microservice<br>\|-----------\|------------------------\|-------------\|---------------------------\|<br>\| NAMESPACE \|          NAME          \| TARGET PORT \|            URL            \|<br>\|-----------\|------------------------\|-------------\|---------------------------\|<br>\| default   \| example2-my-microservice \| http/5000   \| http://192.168.49.2:30260 \|<br>\|-----------\|------------------------\|-------------\|---------------------------\|<br>🎉  Opening service default/example2-my-microservice in default browser...<br> <br>#This will provide <the Node-IP>:<Node-Port> URL of the K8s cluster and launch the same in your default browser.<br></pre><br>![image1](images/workflow2/image1.png)|

### Steps to use telepresence for setting up your local development workspace
| Id | Steps | Details|
| -- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1  | Make sure you have the latest deployment of the microservice that you want to work on. In our example case, we have created a deployment called example2-my-microservice as explained [previously](#steps-to-create-the-example2--deployment-on-k8s-cluster).| <pre>$ kubectl get deployment<br>NAME                     READY   UP-TO-DATE   AVAILABLE   AGE<br>example2-my-microservice   1/1     1            1           5m39s<br></pre>|
| 2  | Connect telepresence to your K8s cluster, telepresence will use the config file in the ./kube folder to identify the cluster to which it will connect. | <pre>#This will connect telepresence daemon on your workstation with telepresence traffic manager on the K8s cluster<br>$ telepresence connect<br>Connected to context minikube (https://192.168.49.2:8443)<br> <br>#This will list all the workloads we can intercept<br>$ telepresence list<br>example2-my-microservice: ready to intercept (traffic-agent not yet installed)<br> <br>#Currently we are in application directory<br>$ pwd<br>/home/..../Telepresence-examples-main/example2/<br> <br>#We will create a folder to store all the different volume mounts from the k8s deployment<br>$ mkdir local_volume_mount<br> <br>#Run below command to intercept the miroservice<br>#--port is the port on your workstation where all the traffic from  the K8s cluster will be #routed to.<br>#--env-file will create a .env file in the specified path and name with all the envoirment #variables in #at the container level.<br>#--mount will copy all the volume mounts of worklaod to the path specified.<br> <br>$ telepresence intercept example2-my-microservice --port 5000 --env-file ./local.env --mount ./local_volume_mount/<br>Using Deployment example2-my-microservice<br>intercepted<br>   Intercept name         : example2-my-microservice<br>   State                  : ACTIVE<br>   Workload kind          : Deployment<br>   Destination            : 127.0.0.1:5000<br>   Service Port Identifier: http<br>   Volume Mount Point     : /home/..../Telepresence-examples-main/example2/local_volume_mount<br>   Intercepting           : all TCP requests <br> <br>#NOTE:Windows can only perform remote mounts using drives,and not folders hence we need to provide a Letter for #drive(unused) followed by a colon i.e --mount=X:, Therefore for windows user the command will look like this<br>PS C:\\Users\\maheshp\\Desktop\\example2> telepresence intercept example2-my-microservice --port 5000 --env-file=.\\local.env --mount X:<br>Using Deployment example2-my-microservice<br>intercepted<br>   Intercept name         : example2-my-microservice<br>   State                  : ACTIVE<br>   Workload kind          : Deployment<br>   Destination            : 127.0.0.1:5001<br>   Service Port Identifier: http<br>   Volume Mount Point     : X:<br>   Intercepting           : all TCP requests<br></pre> |
| 3  | We can see that all the directories in volume mount(/app/static in the container) have been replicated to the local_volume_mount directory and all the environment variables(at container level) have been copied to local.env<br>|![image2](images/workflow2/image2.png)
| 4  | Now we can incorporate the static file in local_volume_mount and the env variables from local .env in the code running on our workstation to mimic the k8s cluster.<br>Here in our code running locally (mw-example-telepresence/example2/main.go ) we can see that we load and use the env variables from local.env(which has env values from the K8s cluster). Also, we serve the HTML page in the local_volume_mount (which is the replicated volume). | <pre>#We can see in line 21 and 26 of the code that we are loading and using the environment variables in the K8s cluster,that is from #local.env<br> <br>#line 21<br>$ sed -n 21p main.go<br>        err := godotenv.Load("local.env")<br>#line 26<br>$ sed -n 26p main.go<br>        envValue := os.Getenv("KUBERNETES_SERVICE_HOST") + ":" + os.Getenv("KUBERNETES_SERVICE_PORT") err :=<br> <br>#Serving the static file downaloaded at local_volume_mount which we replicated from the K8s cluster<br>#The below line is for linux/mac machines<br>tmpl, err := template.ParseFiles("./local_volume_mount/app/static/home.html")<br></pre><br>**Note for Windows**: Since the Directory specified for storing the replicated volume mount is different for Windows, please make the following edit:<br>Uncomment the below line and comment out the one for Linux in your example2/main.go file<br><pre>tmpl, err :=template.ParseFiles("X:/app/static/home.html")</pre>                                                                                                         |
| 5  | Run the go application on your workstation (example2/main.go)| <pre><br>#Current directory<br>$ pwd<br>/home/maheshp/Desktop/mw-example-telepresence/example2<br> <br>$ ls<br>example2-image/  go.mod  go.sum  helm/  main.go<br> <br># Run the golang http server<br>  go run main.go<br></pre>|
| 6  | We can see from the image that the code running on our workstation is using the home.html, a file mounted in the K8s Container, and environment variables defined at the  K8s cluster, to serve the request mimicking the results at the K8s cluster's end.|![image3](images/workflow2/image3.png)
| 7  | **Similarly, users can obtain and use the same environment variable values and files in the volume mounts in their workstation as it is present in the K8s cluster.**||
| 8  | Once you are done intercepting you can stop the intercept and disconnect the telepresence.| <pre>#Run the below command to stop the intercept<br>$ telepresence leave example2-my-microservice<br> <br>#Run the below command to disconnect  telepresence<br>$ telepresence quit<br>Telepresence Daemons disconnecting...done<br></pre>||
| 9  |To clean up the K8s cluster we can use Helm to uninstall the deployment|<pre>$ helm uninstall example2<br>release "example2" uninstalled<br></pre>||


## Workflow 3: Using telepresence to debug your code at the K8s cluster level
Suppose there was a code change after which the microservice is not working as expected. This might be due to several reasons such as wrong logic, issues with the efficiency or reliability of code, or issue w.r.t connectivity with other k8s resources. These issues can be solved faster if we can use the same debugging tools and procedures we do while developing the microservice locally, at the K8s cluster level(which is isolated ).

Our example is a simple word count application that takes text as input and gives you an analysis of words, like the count of each word, and the total number of words. 

To set this up, download the source code as mentioned [here](#source-code-for-the-examples-used-in-the-walkthrough) and navigate to mw-example-telepresence/example3/
```

[maheshp@vdi-dd1bgl-022:~/Desktop] ...
$ ls
mw-example-telepresence/
 
$ cd mw-example-telepresence/example3/
```

### Steps to create the example3 one deployment on the K8s cluster
| Id | Steps| Details|
| -- | --------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 1  | First, we will create the container image, for this navigate to the example3/example3-image folder.<br><br>Build the docker image and load it to minikube | <pre>#Current directory<br>$ pwd<br>/home/maheshp/Desktop/mw-example-telepresence/example3<br> <br>#Navigate to example3-image<br>$ cd example3-image/<br> <br># Building the image<br>$ docker build -t example3 .  <br> <br>#Load the image to minikube<br>$ minikube image load example3<br> <br>#Navigate back to application directory<br>$ cd ..<br></pre> |
| 2  | Create the deployment using the "my-microservice" helm chart in the example3/helm folder<br>| <pre>   <br>#Navigate inside helm directory<br>$ cd helm/<br> <br>$ pwd<br>/home/maheshp/Desktop/mw-example-telepresence/example3/helm<br> <br>#helm install <name of release><br>$ helm install example3 my-microservice<br> <br> <br>#Navigate back to application directory<br>$ cd ..<br></pre>|
| 3  | We can see that the word counter project is now being served by the K8s cluster at the NodePort                                                           | <pre>   <br>#Once the Deployments are ready we can launch the service in browser with "minikube service <service name>"<br>$ minikube service example3-my-microservice<br>\|-----------\|------------------------\|-------------\|---------------------------\|<br>\| NAMESPACE \|          NAME          \| TARGET PORT \|            URL            \|<br>\|-----------\|------------------------\|-------------\|---------------------------\|<br>\| default   \| example3-my-microservice \| http/5000   \| http://192.168.49.2:30260 \|<br>\|-----------\|------------------------\|-------------\|---------------------------\|<br>🎉  Opening service default/example3-my-microservice in default browser...<br> <br>#This will provide <the Node-IP>:<Node-Port> URL and launch the same in your default browser.<br></pre><br>![image1](images/workflow3/image1.png)<br>![image2](images/workflow3/image2.png) |

### Steps to run the example3 code on your workstation
| Id | Steps | Details|
| -- | ------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1  | Now to run the code locally make sure you have golang installed, you can do it from [here](https://mathworks.sharepoint.com/sites/devu/go/SitePages/Setup-the-development-environment-in-Go.aspx?ga=1#install-golang) | |
| 2  | Navigate to example3/main.go file and run the main.go file.| <pre>#Current directory<br>$ pwd<br>/home/maheshp/Desktop/mw-example-telepresence/example3<br> <br>$ ls<br>example3-image/  go.mod  helm/  main.go  readme-example3<br> <br> <br># Run the golang http server<br>  go run main.go<br></pre> |
| 3  | The index.html page in the static folder in the application directory will now be served at the workstation port 5000 (i.e http://localhost:5000) | ![image3](images/workflow3/image3.png)|


### Steps to use telepresence to debug your code at the K8s cluster level
| Id | Steps| Details|
| -- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 1  | Deploy the wordcount microservice on the K8s cluster and verify.| <pre>   <br>$ minikube service example3-my-microservice<br>\|-----------\|------------------------\|-------------\|---------------------------\|<br>\| NAMESPACE \|          NAME          \| TARGET PORT \|            URL            \|<br>\|-----------\|------------------------\|-------------\|---------------------------\|<br>\| default   \| example3-my-microservice \| http/5000   \| http://192.168.49.2:30260 \|<br>\|-----------\|------------------------\|-------------\|---------------------------\|<br>🎉  Opening service default/example3-my-microservice in default browser...<br> <br>#This will provide <the Node-IP>:<Node-Port> URL and launch the same in your default browser.<br></pre> |
| 2  | We can observe that when we provide input in the text box and click on "CountWords", we get incorrect results| ![image4](images/workflow3/image4.png) ![image5](images/workflow3/image5.png)|
| 3  | Connect telepresence to the K8s cluster and intercept the microservice.| <pre>   <br>$ telepresence intercept example3-my-microservice --port 5000<br>Using Deployment example3-my-microservice<br>intercepted<br>   Intercept name         : example3-my-microservice<br>   State                  : ACTIVE<br>   Workload kind          : Deployment<br>   Destination            : 127.0.0.1:5000<br>   Service Port Identifier: http<br>   Volume Mount Point     : /tmp/telfs-761166714<br>   Intercepting           : all TCP requests<br></pre>|
| 4  | Run the same main.go file as we did [previously](#steps-to-run-the-example3-code-on-your-workstation) but in VScode (or your preferred IDE/Debugger) in debug mode with relevant breakpoints.<br>                                               | ![image6](images/workflow3/image6.png)|
| 5  | Now give some input and hit submit. And traverse via the code step by step to catch the bug. In the last image, we see that the issue, len((wordCounts) + 1) is being returned.          | ![image7](images/workflow3/image7.png)|
| 6  | You can edit the code to fix the issue(change it to len(words)) and save the file, reload the page, and test the fix again.                                                              | ![image8](images/workflow3/image8.png)|
| 7  | **Similarly, you can debug, analyze, and update your microservices running on the K8s cluster locally on your workstation using any tool you normally would when during local development.** |
| 8  | Once you are done intercepting you can stop the intercept and disconnect the telepresence.                                                                                               | <pre>#Run the below command to stop the intercept<br>$ telepresence leave example3-my-microservice<br> <br>#Run the below command to disconnect  telepresence<br>$ telepresence quit<br>Telepresence Daemons disconnecting...done<br></pre>|
| 9  | To clean up the K8s cluster we can use Helm to uninstall the deployment                                                                                                                  | <pre>$ helm uninstall example3<br>release "example3" uninstalled<br></pre>|

## Workflow 4: Using telepresence for automated testing of cloud-native code

Users can utilize the fact that all the endpoints within the K8s cluster are made available to the workstation once telepresence is connected to the K8s cluster. They can create scripts for automation/testing and also use tools like Postman, curl, netcat, nslookup on your workstation to test the microservice and the entire architecture from within the K8s cluster.

Let's consider an example where there are 2 versions of microservices that provide some processed data from their API endpoints which will be further used by the rest of the application workflow and you want to test this microservice live and compare the data returned by both the services. 

To set this up, download the source code as mentioned [here](#source-code-for-the-examples-used-in-the-walkthrough) and navigate to mw-example-telepresence/example2/
```
[maheshp@vdi-dd1bgl-022:~/Desktop] ...
$ ls
mw-example-telepresence/
 
$ cd mw-example-telepresence/example4/
```
### Steps to create the example4 deployment on K8s cluster
| Id | Steps | Details|
| -- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1  | First, we will create the container images.<br><br>Navigate to the example4/example4-image folder.<br><br>Build the docker image of the first microservice and load it to minikube| <pre>#Current directory<br>$ pwd<br>/home/maheshp/Desktop/mw-example-telepresence/example4<br> <br>#Navigate to example4-image<br>$ cd example4-image/<br> <br># Building the image<br>$ docker build -t example4:v1 . <br> <br>#Load the image to minikube<br>$ minikube image load example4:v1<br></pre>|
| 2  | Now let's create and update the microservice and the docker file to create a new version of the microservice (v2).| |
| 3  | First edit the file  example4/example4-image/main.go with the following changes:-<br>1\. Update the value of age for any user ( this will simulate the deviation in the data served by the new version)<br>2\. Update the API endpoint port.| 1\. ![image1](images/workflow4/image1.png)<br>2. ![image2](images/workflow4/image2.png)|
| 4  | Next, we will update the API endpoint to be exposed in the docker file as well| ![image3](images/workflow4/image3.png)|
| 5  | Now we build and load the image of the updated microservice (v2)| <pre># Building the image<br>$ docker build -t example4:v2 .<br> <br>#Load the image to minikube<br>$ minikube image load example4:v2<br> <br>#Navigate back to application directory<br>$ cd ..<br></pre>|
| 6  | We can now deploy the 2 microservices app1-my-microservice and app2-my-microservice<br>To do this go to Telepresence-examples-main/example4/helm/ and run the mentioned commands| <pre>#Navigate to helm directory<br>$ cd helm/<br> <br>$ pwd<br>/home/maheshp/Desktop/mw-example-telepresence/example4/helm<br> <br>#Installing first microservice<br>$ helm install app1 my-microservice<br> <br>#Installing second microservice<br>$ helm install app2 my-microservice -f values2.yaml<br> <br>#Naviagate back to the application folder<br>$ cd ..<br></pre> |
| 7  | Since the services of the deployments in the K8s cluster is of type ClusterIP, the endpoints are only exposed to the internal network of the K8s cluster, and hence<br>the user cannot interact with the API endpoints or microservices from his workstation | |

###  Steps to create a script to test the K8s workloads with telepresence
| Id | Steps| Details |
| -- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1  | Once the microservices are deployed to the K8s cluster the resources and endpoints of the microservice are isolated to the K8s network and are not accessible directly.<br><br>We can see that when we try to curl or perform nslookup the internal service urls | <pre>#These are the k8 services of the miroservices app1 and app2<br>$ kubectl get svc<br> NAME                   TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   <br>app1-my-mircoservice   ClusterIP   10.107.194.180   <none>        5000/TCP  <br>app2-my-mircoservice   ClusterIP   10.100.187.151   <none>        5001/TCP  <br> <br> <br> <br> <br>$ nc -zv  app1-my-microservice.default 8080<br>nc: getaddrinfo for host "app1-my-microservice.default" port 8080: Name or service not known  <br> <br> <br>$ curl http://app1-my-microservice.default:8080/users<br>curl: (6) Could not resolve host: app1-my-microservice.default  <br> <br> <br>$ nslookup app1-my-microservice.default<br>Server:         172.18.74.9<br>Address:        172.18.74.9#53<br> <br>\*\* server can't find app1-my-microservice.default: NXDOMAIN<br></pre> |
| 2  | Connect telepresence to your K8s cluster | <pre>$ telepresence connect<br>Connected to context minikube (https://192.168.49.2:8443)<br></pre>  |
| 3  | Once telepresence is connected to your K8s cluster your workstation behaves as part of the K8s internal network and hence all the resources are now accessible.<br><br>we can see that all the commands that previously failed now succeed                       | <pre>$ nslookup app1-my-microservice.default<br>Server:         172.18.74.9<br>Address:        172.18.74.9#53<br> <br>Name:   app1-my-microservice.default<br>Address: 10.104.129.106  <br> <br>$ curl http://app1-my-microservice.default:8080/users<br>[{"name":"Alice","age":23},{"name":"Bob","age":30},{"name":"Charlie","age":35}]  <br> <br>$ nc -zv  app1-my-microservice.default 8080<br>Connection to app1-my-microservice.default (10.104.129.106) 8080 port [tcp/http-alt] succeeded!<br></pre> |
| 4  | We can hit the service URLs directly to on the workstation browser as well  | ![image4](images/workflow4/image4.png)  |
| 5  | We can run scripts (example4/main.go )from our workstation which refer to these internal endpoints directly | <pre>#Current directory<br>$ pwd<br>/home/maheshp/Desktop/mw-example-telepresence/example4<br> <br>$ ls<br>example4-image/  helm/  main.go  readme-example4<br> <br> <br># Run the golang http server<br>  go run main.go<br></pre>  |
| 6  | Here we can see that the script creates GET requests to each microservice and then compares the responses and prints a relevant message if there is a deviation in the response| <pre>#Below code snippet is from the main.go script in the previous step.<br>#We can see that the code executes a get request to the API endpoint which is only accesible from within the K8s cluster<br> <br> <br> <br>resp, err := http.Get("http://app1-my-microservice.default:8080/users")<br>    if err != nil {<br>        fmt.Println("Error: ", err)<br>        return<br>    }<br>    defer resp.Body.Close()<br> <br>resp1, err := http.Get("http://app2-my-microservice.default:8081/users")<br>    if err != nil {<br>        fmt.Println("Error: ", err)<br>        return<br>    }<br>    defer resp1.Body.Close()<br></pre>  |
| 7  |**Similarly, developers can use any tool or language they prefer to interact with the microservices  and automate tests inside the K8s cluster**| |
| 8  | Once you are done working, you can terminate the telepresence connection to the K8s cluster | <pre>#Run the below command to disconnect  telepresence<br>$ telepresence quit<br>Telepresence Daemons disconnecting...done<br></pre>|
| 9  | To clean up the K8s cluster we can use Helm to uninstall the deployment| <pre>$ helm uninstall app1<br>release "app1" uninstalled<br> <br>$ helm uninstall app2<br>release "app2" uninstalled<br></pre>|
