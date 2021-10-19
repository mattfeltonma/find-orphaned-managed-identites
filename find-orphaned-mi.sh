#!/bin/bash
touch orphaned-smi.json
az ad sp list --query="[?servicePrincipalType=='ManagedIdentity' && alternativeNames[?contains(@,'isExplicit=False')]]" --all | jq -c '.[]' | while read i; do 
    resourceId=$(echo $i | jq -r '.alternativeNames[1]')
    az resource show --ids $resourceId > /dev/null
    if [ $? -ne 0 ]
    then
        if ! [[ "$resourceId" =~ .*policyAssignments.* ]]
        then
            echo $i | jq '.displayName' >> results.json
        fi
    fi
done
