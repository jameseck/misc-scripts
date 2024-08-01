#!/bin/bash

kubectl patch app --type merge -p '{"operation": {"sync": {"syncStrategy": { "hook": {}}}}}' $@
