# German NUTS3 Weekly Mortality Data (2015–2021)

Weekly all-cause death counts for all 400 Kreise and kreisfreie Städte in Germany, covering ISO calendar weeks 1–52/53 for the years 2015–2021 (for most regions, additional years are available and included). This dataset was compiled to support subnational excess mortality analysis during the COVID-19 pandemic and supplements the analysis published in [Habershon et al. (2025), _Population Health Metrics_](https://link.springer.com/article/10.1186/s12963-025-00405-w).

---

## Files

| File                                      | Description                                            |
| ----------------------------------------- | ------------------------------------------------------ |
| `data/destatis_de/12613-0013_de_flat.csv` | Validation data: Destatis monthly totals by Bundesland |
| `german_subnational.R`                    | Processing and cleaning script                         |
| `data/`                                   | Raw data as received from Statistische Landesämter     |

---

## Coverage

- **Geographic unit:** NUTS3 (Kreise and kreisfreie Städte), n = 400
- **Time:** ISO weeks 1–52/53, years 2015–2021
- **Measure:** All-cause deaths, weekly counts
- **Date basis:** Deaths are counted by **Sterbedatum** (date of death), not date of registration (confirmed by Statistikamt Nord, June 2024)

---

## Data Sources and Licensing

Data were obtained from the 16 Statistische Landesämter, coordinated in part through Statistisches Landesamt des Freistaates Sachsen (Gz 01-0127/566/21). Total acquisition cost €2,140 + VAT.

The compiled dataset is released under **CC BY 4.0**. The underlying data from each Bundesland carry the terms described below. All terms are compatible with open redistribution provided attribution requirements are met.

### Source table

| Land                   | Date received                    | Received from                                                  | Cost                | License / Terms                                                                                                              | Required copyright notice                                     |
| ---------------------- | -------------------------------- | -------------------------------------------------------------- | ------------------- | ---------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------- |
| Hamburg                | 12 Jun 2024                      | Petra Humfeldt, Statistikamt Nord (`statistik-nord.de`)        | Free                | No explicit terms → dl-de/by-2.0                                                                                             | Statistikamt Nord                                             |
| Schleswig-Holstein     | 12 Jun 2024                      | Petra Humfeldt, Statistikamt Nord (`statistik-nord.de`)        | Free                | No explicit terms → dl-de/by-2.0                                                                                             | Statistikamt Nord                                             |
| Nordrhein-Westfalen    | Jun 2024 (correction 8 Jul 2024) | IT.NRW / Statistisches Landesamt NRW                           | Free                | Explicitly: redistribution with attribution permitted                                                                        | © Information und Technik NRW, Düsseldorf                     |
| Berlin                 | 23 May 2025                      | StaLa Sachsen via LÜA coordination (bundled with Brandenburg)  | Included in BB cost | No explicit terms → dl-de/by-2.0                                                                                             | Amt für Statistik Berlin-Brandenburg                          |
| Brandenburg            | 23 May 2025                      | StaLa Sachsen via LÜA coordination                             | ~€250               | No explicit terms → dl-de/by-2.0                                                                                             | Amt für Statistik Berlin-Brandenburg                          |
| Bremen                 | 23 May 2025                      | StaLa Sachsen via LÜA coordination                             | ~€150               | No explicit terms → dl-de/by-2.0                                                                                             | Statistisches Landesamt Bremen                                |
| Hessen                 | 23 May 2025                      | StaLa Sachsen via LÜA coordination                             | ~€270               | No explicit terms → dl-de/by-2.0                                                                                             | Statistisches Landesamt Hessen                                |
| Sachsen                | 23 May 2025                      | StaLa Sachsen via LÜA coordination                             | ~€269               | No explicit terms → dl-de/by-2.0                                                                                             | Statistisches Landesamt des Freistaates Sachsen               |
| Sachsen-Anhalt         | 23 May 2025                      | StaLa Sachsen via LÜA coordination                             | ~€268               | Explicitly: redistribution with attribution permitted                                                                        | © Statistisches Landesamt Sachsen-Anhalt, Halle (Saale), 2025 |
| Mecklenburg-Vorpommern | May 2025                         | StaLa Sachsen via LÜA coordination                             | Free                | No explicit terms → dl-de/by-2.0                                                                                             | Statistisches Amt Mecklenburg-Vorpommern                      |
| Saarland               | 4 Jun 2025                       | StaLa Sachsen via LÜA coordination                             | undisclosed         | No explicit terms → dl-de/by-2.0                                                                                             | Statistisches Amt des Saarlandes                              |
| Thüringen              | 4 Jun 2025                       | StaLa Sachsen via LÜA coordination                             | ~€55                | No explicit terms → dl-de/by-2.0                                                                                             | Thüringer Landesamt für Statistik                             |
| Bayern                 | 11 Jun 2025                      | StaLa Sachsen via LÜA coordination                             | ~€79                | No explicit terms → dl-de/by-2.0                                                                                             | Bayerisches Landesamt für Statistik                           |
| Niedersachsen          | 11 Jun 2025                      | StaLa Sachsen via LÜA coordination                             | ~€324               | No explicit terms → dl-de/by-2.0                                                                                             | Landesamt für Statistik Niedersachsen                         |
| Rheinland-Pfalz        | 11 Jun 2025                      | StaLa Sachsen via LÜA coordination                             | Free                | No explicit terms → dl-de/by-2.0                                                                                             | Statistisches Landesamt Rheinland-Pfalz                       |
| Baden-Württemberg      | 16 Jun 2025                      | StaLa Sachsen via LÜA coordination (forwarded from StaLa BaWü) | ~€150               | **Prior approval required for redistribution of paid products** — permission [requested / granted — *update once confirmed*] | © Statistisches Landesamt Baden-Württemberg, Fellbach         |

### Notes on licensing

Where no explicit redistribution terms were provided in the delivery communications, the data fall under the default framework for German public statistical data: **Datenlizenz Deutschland – Namensnennung 2.0** ([dl-de/by-2.0](https://www.govdata.de/dl-de/by-2-0)), which permits redistribution with attribution.

Two Länder provided explicit written permission with their deliveries:

- **Nordrhein-Westfalen:** _"© Information und Technik NRW, Düsseldorf, 2024. Vervielfältigung und Verbreitung, auch auszugsweise, mit Quellenangabe gestattet."_
- **Sachsen-Anhalt:** _"© Statistisches Landesamt Sachsen-Anhalt, Halle (Saale), 2025. Vervielfältigung und Verbreitung, auch auszugsweise, nur mit Quellenangabe gestattet."_

**Baden-Württemberg** is the only Land requiring prior approval for redistribution of paid products (contact: vertrieb@stala.bwl.de).

---

## Known Issues and Data Quality Notes

### Validation

#### Results of comparing obtained disaggregated data (for 400 Kreise and each week) with publicly available data from Destatis (for Bundesländer and months)

| Land                   | Result                                    | Details                                                                                                                                                                                                                                                                                                                                                                                                 |
| ---------------------- | ----------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Schleswig-Holstein     | Match                                     | Yearly sums identical with Destatis across all years                                                                                                                                                                                                                                                                                                                                                    |
| Niedersachsen          | Match                                     | Yearly sums identical with Destatis across all years                                                                                                                                                                                                                                                                                                                                                    |
| Saarland               | Match                                     | Yearly sums identical with Destatis across all years                                                                                                                                                                                                                                                                                                                                                    |
| Mecklenburg-Vorpommern | Match                                     | Yearly sums identical with Destatis across all years                                                                                                                                                                                                                                                                                                                                                    |
| Sachsen-Anhalt         | Match                                     | Yearly sums identical with Destatis across all years                                                                                                                                                                                                                                                                                                                                                    |
| Hamburg                | Match                                     | Yearly sums identical with Destatis across all years                                                                                                                                                                                                                                                                                                                                                    |
| Bremen                 | Match (except 1 death difference in 2017) | Sums match if all _vorjahr/folgejahr_ deaths are attributed to the year of their column (only 2017 off by 1), resulting in week 53 entries for all years. For comparability with other Länder, the weeks had to be reassigned based on ISO weeks, leading to annual sums no longer aligning with the Destatis sums when looking at the final data, but the sum across multiple years remains identical. |
| Rheinland-Pfalz        | Match (except 1 death difference in 2016) | 2016 sum off by 1.                                                                                                                                                                                                                                                                                                                                                                                      |
| Hessen                 | Match                                     | Overall sums match, but Destatis and Hessen distribute deaths differently across 2015/2016 and 2020/2021 year boundaries.                                                                                                                                                                                                                                                                               |
| Nordrhein-Westfalen    | Match (except 7 deaths between 2015-2021) | Yearly sums match Destatis when using the `berichtsjahr` variable. Only 2016 (1 death) and 2017 (6 deaths) have slight differences.                                                                                                                                                                                                                                                                     |
| Sachsen                | 0.2% difference                           | Total across years 2015-2021 is 0.2% higher for the disaggregated data compared with the monthly sums provided by Destatis                                                                                                                                                                                                                                                                              |
| Berlin                 | 0.2% difference                           | Total across years 2015-2021 is 0.2% higher for the disaggregated data compared with the monthly sums provided by Destatis. Disaggregated data doesn't split first/last week across years (there are never 2 KW1s), so all deaths from inbetween weeks must be attributed to one year or the other, while in the Destatis sums deaths from the weeks inbetween years seem to be split across years      |
| Brandenburg            | 0.21% difference                          | Total across years 2015-2021 is 0.21% higher. Same cause as Berlin.                                                                                                                                                                                                                                                                                                                                     |
| Bayern                 | 0.2% difference                           | Total across years 2015-2021 is 0.2% higher. Same cause as Berlin/Brandenburg. Two Kreise missing data for single weeks in 2021 (Kaufbeuren KW34, Ansbach KW37), imputed as 0.                                                                                                                                                                                                                          |
| Thüringen              | 0.07% difference                          | Total across years 2015-2021 is 0.07% higher. Calculating the difference of destatis deaths and thüringen values without redacted deaths gives an average of 11 deaths per redacted value, though thüringen says they only redact below 3.                                                                                                                                                              |
| Baden-Württemberg      | -0.26% difference                         | All years match Destatis sums except 2016 (828 too low) and 2021 (1176 too low). Cause unknown.                                                                                                                                                                                                                                                                                                         |

### Notes on Year-Boundary Week Attribution

ISO week-year boundaries do not align with calendar year boundaries.

A week spanning 31 December and 1 January may be assigned to the preceding or following year depending on where the majority of its days fall.

ISO week 53 occurs only in years where 1 January falls on a Thursday (or Wednesday in leap years). Handling is inconsistent across Länder and is addressed on a per-Land basis in `german_subnational.R`. See inline comments.

Several Länder (Berlin, Brandenburg, Bayern, Sachsen-Anhalt) attribute all deaths in such a week to a single year rather than splitting them. This produces small but systematic discrepancies relative to Destatis totals (which appear to split more precisely).

---

## Citation

If you use this dataset, please cite:

> Habershon, S. et al. (2025). _[Dataset title]_. Zenodo. https://doi.org/[ZENODO DOI — add after upload]

---

## License

The compiled dataset is licensed under [Creative Commons Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/).

Underlying data from each Statistisches Landesamt are subject to the terms described in the Sources table above. Users redistributing derived works must comply with all applicable attribution requirements.
