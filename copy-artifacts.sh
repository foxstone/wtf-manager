#!/bin/bash

cd /shared/foxstone/
rsync -av artifacts-temp/ codebase-knowledge/
rm -rf artifacts-temp/legacy-api/*
rm -rf artifacts-temp/ng-frontend/*
rm -rf artifacts-temp/platform-api/*

echo 'Copied artifacts.'