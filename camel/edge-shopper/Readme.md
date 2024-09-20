## Prerequisites

This Camel Quarkus component integrates, MQTT and HTTP clients (such as IoT devices, handsets, 3rd party clients) with an AI/ML engine, to obtain detection results from images. It also acts as an ingestion system and pushes training data to the central data center.

You'll need:

 - the ML Model Server (TensorFlow Server)
 - the REST Price engine (Camel K)
 - an AMQ Broker (local or remote)
 <!-- - an AMQ Streams cluster -->
 - Camel K Operator
 - S3 storage
 - Feeder (in central) system deployed.
 
<br>

### Deploy the AI/ML model server:

Follow the main instructions (main project README)


<br>

### Deploy the broker

- Local broker \
  Follow AMQ instructions to deploy a local instance.

- on OpenShift \
  You can use the AMQ operator to deploy an instance.
  Or you can follow these instructions:

  1. Login with admin credentials and create a new project
		```
		oc new-project edge1
		```

  2. Install the AMQ Broker Operator in the 'edge1' namespace

  3. Use the YAML definition under:

     * ../../deployment/edge/amq-broker.yaml

  3. Create a route by exposing the MQTT service \
     You need to ensure the HTML page can access the broker remotely via secure WebSockets.
	 ```
	 oc create route edge broker-amq-mqtt --service broker-amq-mqtt-0-svc
	 ```
	 Make sure the route created has the `broker-amq-mqtt`.

<br>


### Deploy the Price engine

The Camel Edge integration obtains detections from the inference engine, and requests a price match to the price engine.
The price engine is a Camel K instance.

Go to the `price-engine` directory and from there run the following command:

You can run locally with Camel JBang with the following command:

```
camel run * --port 8090
```

To deploy in OpenShift, run the following commands:

```
oc create cm catalogue --from-file=catalogue.json
```
```
kamel run price-engine.xml \
--resource configmap:catalogue@/deployments/config
```


You can test using the following cURL command:

```
curl \
-H "item: Apple" \
http://price-engine-edge1.apps.cluster-lv7nl.lv7nl.sandbox257.opentlc.com/price
```

<br>


### S3 Storage

You can use S3 storage based on Minio as per the main README instructions.

<br>

## Running the service


Run it locally executing the command below:

```
./mvnw clean compile quarkus:dev
```

## Test with cURL

### Binary mode

To send an image in binary via HTTP, use the following `curl` command:

```
MY_IMAGE=./images/small-dog.jpeg && \
MY_ROUTE=http://localhost:8080 && \
curl -H 'Content-Type:application/octet-stream' ${MY_ROUTE}/binary --data-binary @${MY_IMAGE}
```

### JSON mode

To send a JSON message containing the image encoded in base64 use the following `curl` command:

```
MY_IMAGE=./images/small-dog.jpeg && \
MY_ROUTE=http://localhost:8080 && \
(echo -n '{"image": "'; base64 $MY_IMAGE; echo '"}') | \
curl -X POST -H "Content-Type: application/json" -d @- ${MY_ROUTE}/detection
```

<br>

## Deploying to Openshift


### Configure your integration with S3

Configure:
 - `src/main/resources/application.properties`

<br>

### Deploy

Ensure you create/switch-to the namespace where you want to deploy the stub.

Run the following command to trigger the deployment:
```
./mvnw clean package -DskipTests -Dquarkus.kubernetes.deploy=true
```

Create the route to the instance (needs to match the name of the service)

```
oc create route edge camel-edge --service shopper
```

# Keycloak integration to this component

## Overview

The goal of this exercise is to demostrate the power of Keycloak in the easiness of protecting application with both login screen and authorization policies. 

## How to

To run locally: 
```
mvn quarkus:dev
```
Then open the dev UI and navigate to Keycloak tab - in realm quarkus2 create new user.
Try to get to the http://localhost:8080 and then you are presented with keycloak login screen
You have permission to view the index.html page, but after other pages are forbidden to see.

### Managing access to pages
Access is managed directly in keycloak at quarkus2 realm in client edge-shopper tab Authorization.

You need to create Resource with exact URI and then create permission and policy that will allow user to get to specific resource. 
Now is the time to experiment about every aspect of Keycloak Authorization

## How to run on Openshift

- you need to install keycloak and import src/main/resources/quarkus2-realm.json. 
- fill in this property (ENV variable according to quarkus documentation should be fine ):
```
quarkus.oidc.auth-server-url=<URL of the Keycloak quarkus2 realm>
```


