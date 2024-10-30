#!/bin/bash

# Check if user is logged in to OpenShift
if ! oc whoami &>/dev/null; then
    echo "You must be logged in to an OpenShift cluster to run this script."
    exit 1
fi

# Loop through each Subscription in all namespaces and update the upgrade mode
for subscription in $(oc get subscriptions --all-namespaces -o jsonpath='{range .items[*]}{.metadata.namespace}{"|"}{.metadata.name}{"\n"}{end}'); do
    # Extract namespace and subscription name
    namespace=$(echo "$subscription" | cut -d'|' -f1)
    name=$(echo "$subscription" | cut -d'|' -f2)

    echo "Updating Subscription '$name' in namespace '$namespace' to Manual upgrade mode..."

    # Patch the Subscription to set installPlanApproval to Manual
    oc patch subscription "$name" -n "$namespace" --type=json -p='[{"op": "replace", "path": "/spec/installPlanApproval", "value": "Manual"}]'

    echo "Subscription '$name' updated successfully."
done

echo "All subscriptions have been updated to Manual upgrade mode."
