#!/usr/bin/env bash
# Copyright 2022 Meta Mind AB
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


cd "$(dirname "$0")/.."

if [[ `sqlite3 data/mapping.db < scripts/verify.sql | wc -l` -eq 0 ]] ; then
  echo OK
else
  echo "SMECH countries with no mapped data:"
  sqlite3 data/mapping.db < scripts/verify.sql
  exit 1
fi

printf 'All countries: %d\n' "$(sqlite3 data/mapping.db \
  'select count(alpha2) from allcountries;')"
printf 'Distinct alpha-2 codes: %d\n' "$(sqlite3 data/mapping.db \
  'select count(distinct alpha2) from allcountries;')"
printf 'SMECH country names: %d\n' "$(sqlite3 data/mapping.db \
  'select count(*) from wpcountries;')"
echo 'ISO countries missing from SMECH:'
sqlite3 data/mapping.db "select printf('- %s', iso_name) from allcountries where smech_name is null;"
