#!/bin/sh

wget -O MemberSystems.json  "http://192.168.91.128/boundary/1.0/boundary/?format=json&sets=member-systems&limit=10000"

wget -O StateHouseDistricts.json  "http://192.168.91.128/boundary/1.0/boundary/?format=json&sets=state-house-districts&limit=10000"

wget -O StateSenateDistricts.json  "http://192.168.91.128/boundary/1.0/boundary/?format=json&sets=state-senate-districts&limit=10000"

wget -O Counties.json  "http://192.168.91.128/boundary/1.0/boundary/?format=json&sets=counties&limit=10000"

