<!--
 Copyright 2022 Meta Mind AB

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
-->

# SME Climate Hub country mapping

SME Climate Hub references countries by name, not by an standard identifier. We need to map those SMECH-specific names to ISO alpha-2 country codes for use by the sector average service.

Sector average service API v1 requires Exiobase location codes, which are either (a) an ISO 3166 alpha-2 code if Exiobase has data for that country, or (b) a non-ISO two-letter code
representing a continent-level region (Asia, Africa, Europe, etc).

The codes known in Exiobase v3 can be seen in `data/exiobase_known_alpha2.csv`. To find out more about the avilable countries and regions in Exiobase look at section 2.2.1 of this [document](https://www.aramis.admin.ch/Default?DocumentID=61243&Load=true)

This repository contains three data sources:
- A table of country names exported from the SME Climate Hub wordpress database (`data/WP_country_options.csv`).
- A table of ISO 3166-1 country names, alpha-2 codes and other identifiers, including a manual mapping to the corresponding SMECH country name (`data/all-countries.csv`).
- A table of country and region codes which have emission factor data in Exiobase v3 (`data/exiobase_known_alpha2.csv`).

## Building the mapping

The country mapping data is loaded by running:

```
./scripts/initialize-db.sh
```

The country name mapping can be verified to make sure all SMECH country names are mapped to some ISO code by running:

```
./scripts/verify.sh
```

## Generate client data table

The following script generates JSON data arrays which are used in public profile client to map SMECH country names to ISO 3166 alpha-2 codes, and to let the user select a country.

```
./scripts/generate-client-mapping.sh
```

The resulting typescript file `output/countries.ts` is a self-contained file that can be copied directly into the sme-public-profile-client repo for use.
Mapping logic is in the sme-public-profile-client repo; the generated file just contains data (and a typescript type definition).
A plain JSON output file `output/iso-countries.json` is also written for use by other tools (eg, the Exiobase country coverage check).

## Generate Sector average service mapping

The following script generates a mapping object which is used in sector average service to map ISO 3166-1 alpha-2 country codes to exiobase location code:

```
./scripts/generate-sector-avg-mapping.sh
```

The resulting typescript file is created as `output/sector-average-mapping.ts` and is a self-contained file that can be imported into sector average service.
Mapping logic is in the sector-average-service repo; the generated file just contains data.

## Contributing

This project is maintained by Normative but currently not actively seeking external contributions. If you however are interested in contributing to the project please [sign up here](https://docs.google.com/forms/d/e/1FAIpQLSe80c9nrHlAq6w2vUbeFSPVGG7IPqorKMkizhHJ98viwnT-OA/viewform?usp=sf_link) or come [join us](https://normative.io/jobs/).

Thank you to all the people from Google.org who were critical in making this project a reality!
- John Bartholomew ([@johnbartholomew](https://github.com/johnbartholomew))
- Craig Rogers ([@twentyrogersc](https://github.com/twentyrogersc))

## License
Copyright (c) Meta Mind AB. All rights reserved.

Licensed under the [Apache-2.0 license](/LICENSE)
