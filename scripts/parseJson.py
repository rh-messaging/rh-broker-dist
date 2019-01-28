#!/usr/bin/python

import json
import sys
import os

f=open("build.properties","w+")
json=json.loads(sys.argv[1])
f.write("BUILDID=%s\r\n" % json["build_id"])
f.write("BUILDZIP=%s\r\n" % json["artifacts"]["broker-zip"]["url"])
f.write("BUILDTAR=%s\r\n" % json["artifacts"]["broker-tar"]["url"])
f.write("BUILDMAVEN=%s\r\n" % json["artifacts"]["amq-broker"]["repository_url"])
f.close()
print(zip)

