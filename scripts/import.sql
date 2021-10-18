-- Copyright 2022 Meta Mind AB
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

-- Just for safety...
DROP TABLE IF EXISTS allcountries_raw;
DROP TABLE IF EXISTS wpcountries;
DROP TABLE IF EXISTS knownalpha2;

-- When importing into new tables, the schema is created based on the CSV header row.
.mode csv
.import data/all-countries.csv allcountries_raw
.import data/WP_country_options.csv wpcountries
.import data/exiobase_known_alpha2.csv knownalpha2

-- Map region names to Exiobase region codes in a view, and combine country names.
DROP VIEW IF EXISTS allcountries;
CREATE VIEW allcountries AS SELECT
  -- Combined name; SMECH if it's in SMECH's list, otherwise the ISO name.
  (case smech_name
    when '' then iso_name
    else smech_name
  end) as name,
  -- Copy most columns.
  iso_name,
  nullif(smech_name, '') as smech_name,  -- Convert blank to null
  alpha2, alpha3, country_code, iso_std, region, sub_region, intermediate_region,
  (case region
    when 'Asia' then
      (case sub_region when 'Western Asia' then 'WM' else 'WA' end)
    when 'Oceania' then 'WA'
    when 'Americas' then 'WL'
    when 'Europe' then 'WE'
    when 'Africa' then 'WF'
    else '' end
  ) as exiobase_region_code
FROM allcountries_raw;
