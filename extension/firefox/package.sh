#!/bin/bash
rm charting.xpi
zip -r charting.xpi chrome.manifest chrome/ defaults/ install.rdf
cp charting.xpi ../../server/public
