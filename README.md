# German NUTS3 Weekly Mortality Data (2015–2021)

Weekly all-cause death counts for all 400 Kreise and kreisfreie Städte in Germany, covering ISO calendar weeks 1–52/53 for the years 2015–2021. This dataset was compiled to support subnational excess mortality analysis during the COVID-19 pandemic and supplements the analysis published in [Habershon et al. (2025), *Population Health Metrics*](https://link.springer.com/article/10.1186/s12963-025-00405-w).

---

## Files

| File | Description |
|---|---|
| `sterbefallzahlen.csv` | Main dataset: weekly deaths by Kreis, 2015–2021 |
| `12613-0013_de_flat.csv` | Validation data: Destatis national annual totals |
| `german_subnational.R` | Processing and cleaning script |
| `data/` | Raw data as received from Statistischen Landesämter |

---

## Coverage

- **Geographic unit:** NUTS3 (Kreise and kreisfreie Städte), n = 400
- **Time:** ISO weeks 1–52/53, years 2015–2021
- **Measure:** All-cause deaths, weekly counts
- **Date basis:** Deaths are counted by **Sterbedatum** (date of death), not date of registration (confirmed by Statistikamt Nord, June 2024)

---

## Data Sources and Licensing

Data were obtained from the 16 Statistischen Landesämter, coordinated in part through Statistisches Landesamt des Freistaates Sachsen (Gz 01-0127/566/21, contact: Renate Recknagel, renate.recknagel@statistik.sachsen.de). Total acquisition cost approximately €1,870.

The compiled dataset is released under **CC BY 4.0**. The underlying data from each Land carry the terms described below. All terms are compatible with open redistribution provided attribution requirements are met.

### Source table

| Land | Date received | Received from | Cost | License / Terms | Required copyright notice |
|---|---|---|---|---|---|
| Hamburg | 12 Jun 2024 | Petra Humfeldt, Statistikamt Nord (`statistik-nord.de`) | Free | No explicit terms → dl-de/by-2.0 | Statistikamt Nord |
| Schleswig-Holstein | 12 Jun 2024 | Petra Humfeldt, Statistikamt Nord (`statistik-nord.de`) | Free | No explicit terms → dl-de/by-2.0 | Statistikamt Nord |
| Nordrhein-Westfalen | Jun 2024 (correction 8 Jul 2024) | IT.NRW / Statistisches Landesamt NRW | Free | Explicitly: redistribution with attribution permitted | © Information und Technik NRW, Düsseldorf |
| Berlin | 23 May 2025 | StaLa Sachsen via LÜA coordination (bundled with Brandenburg) | Included in BB cost | No explicit terms → dl-de/by-2.0 | Amt für Statistik Berlin-Brandenburg |
| Brandenburg | 23 May 2025 | StaLa Sachsen via LÜA coordination | ~€250 | No explicit terms → dl-de/by-2.0 | Amt für Statistik Berlin-Brandenburg |
| Bremen | 23 May 2025 | StaLa Sachsen via LÜA coordination | ~€150 | No explicit terms → dl-de/by-2.0 | Statistisches Landesamt Bremen |
| Hessen | 23 May 2025 | StaLa Sachsen via LÜA coordination | ~€270 | No explicit terms → dl-de/by-2.0 | Statistisches Landesamt Hessen |
| Sachsen | 23 May 2025 | StaLa Sachsen via LÜA coordination | ~€269 | No explicit terms → dl-de/by-2.0 | Statistisches Landesamt des Freistaates Sachsen |
| Sachsen-Anhalt | 23 May 2025 | StaLa Sachsen via LÜA coordination | ~€268 | Explicitly: redistribution with attribution permitted | © Statistisches Landesamt Sachsen-Anhalt, Halle (Saale), 2025 |
| Mecklenburg-Vorpommern | May 2025 | StaLa Sachsen via LÜA coordination | Free | No explicit terms → dl-de/by-2.0 | Statistisches Amt Mecklenburg-Vorpommern |
| Saarland | 4 Jun 2025 | StaLa Sachsen via LÜA coordination | undisclosed | No explicit terms → dl-de/by-2.0 | Statistisches Amt des Saarlandes |
| Thüringen | 4 Jun 2025 | StaLa Sachsen via LÜA coordination | ~€55 | No explicit terms → dl-de/by-2.0 | Thüringer Landesamt für Statistik |
| Bayern | 11 Jun 2025 | StaLa Sachsen via LÜA coordination | ~€79 | No explicit terms → dl-de/by-2.0 | Bayerisches Landesamt für Statistik |
| Niedersachsen | 11 Jun 2025 | StaLa Sachsen via LÜA coordination | ~€324 | No explicit terms → dl-de/by-2.0 | Landesamt für Statistik Niedersachsen |
| Rheinland-Pfalz | 11 Jun 2025 | StaLa Sachsen via LÜA coordination | Free | No explicit terms → dl-de/by-2.0 | Statistisches Landesamt Rheinland-Pfalz |
| Baden-Württemberg | 16 Jun 2025 | StaLa Sachsen via LÜA coordination (forwarded from StaLa BaWü) | ~€150 | **Prior approval required for redistribution of paid products** — permission [requested / granted — *update once confirmed*] | © Statistisches Landesamt Baden-Württemberg, Fellbach |

### Notes on licensing

Where no explicit redistribution terms were provided in the delivery communications, the data fall under the default framework for German public statistical data: **Datenlizenz Deutschland – Namensnennung 2.0** ([dl-de/by-2.0](https://www.govdata.de/dl-de/by-2-0)), which permits redistribution with attribution.

Two Länder provided explicit written permission with their deliveries:

- **Nordrhein-Westfalen:** *"© Information und Technik NRW, Düsseldorf, 2024. Vervielfältigung und Verbreitung, auch auszugsweise, mit Quellenangabe gestattet."*
- **Sachsen-Anhalt:** *"© Statistisches Landesamt Sachsen-Anhalt, Halle (Saale), 2025. Vervielfältigung und Verbreitung, auch auszugsweise, nur mit Quellenangabe gestattet."*

**Baden-Württemberg** is the only Land requiring prior approval for redistribution of paid products (contact: vertrieb@stala.bwl.de). 

---

## Known Issues and Data Quality Notes

### KW53 (ISO week 53)
ISO week 53 occurs only in years where 1 January falls on a Thursday (or Wednesday in leap years). Handling is inconsistent across Länder and is addressed on a per-Land basis in `german_subnational.R`. See inline comments.

### Baden-Württemberg
Annual totals for 2016 and 2021 are approximately 1,000 deaths lower than Destatis national figures suggest. Cause is unknown.

### Thüringen
Some cells with fewer than 3 deaths are suppressed due to statistical confidentiality requirements. Suppressed values have been imputed at 10 deaths. Secondary suppression (to prevent back-calculation) means additional adjacent cells may also be affected.

### Bayern
Missing values are set to 0.

### Unassigned deaths
Weekly deaths in some Länder include a small proportion that cannot be attributed to a specific Kreis (e.g. deaths occurring in transit or with incomplete administrative records). These are excluded from the Kreis-level totals and represent a known downward bias, consistent with the limitation noted in the Eurostat ESMS metadata framework.

---

## Validation

# Land Validation Results

## Exact Match

| Land | Result | Details |
|------|--------|----------|
| Schleswig-Holstein | Match | Yearly sums identical with Destatis across all years |
| Niedersachsen | Match | Yearly sums identical with Destatis across all years |
| Saarland | Match | Yearly sums identical with Destatis across all years |
| Mecklenburg-Vorpommern | Match | Yearly sums identical with Destatis across all years |
| Sachsen | Match | Yearly sums identical with Destatis across all years |
| Bremen | Match after fix | Sums match once *vorjahr/folgejahr* deaths are attributed to the year of their column rather than the following year's sum. 2017 off by 1. Deaths redistributed across years due to different week counting (documented in processing script). |
| Rheinland-Pfalz | Match after fix | Sums match when KW1 deaths from the following year are added to the current year. Missing values for KW1/KW52 2016/2017 (Kaiserslautern, Pirmasens, others) handled in script. 2016 sum off by 1. |
| Hessen | Match after fix | Overall sums match, but Destatis and Hessen distribute deaths differently across 2015/2016 and 2020/2021 year boundaries. Discrepancies remain in individual totals for 2015, 2016, 2020, and 2021. |
| Berlin | Discrepancy | Sums across 2014–2021 off by 0.14%. Raw data does not split year-boundary weeks across years (no double KW1), so partial weeks are attributed entirely to one year. Destatis appears to split proportionally. |
| Brandenburg | Discrepancy | Sums across 2014–2021 off by 0.13%. Same cause as Berlin. |
| Bayern | Discrepancy | Sums across 2014–2021 off by 0.08%. Same cause as Berlin/Brandenburg. Two Kreise missing single weeks in 2021 (Kaufbeuren KW34, Ansbach KW37), imputed as 0. |
| Sachsen-Anhalt | Discrepancy | Year-boundary week attribution issue (same cause as Berlin/Brandenburg/Bayern). |
| Nordrhein-Westfalen | Discrepancy | Yearly sums match Destatis when using the `berichtsjahr` variable (corrected in script). 2018 remains off by ~0.3%. |
| Hamburg | Known issue | Yearly sums match Destatis in some years but not others. Original raw file missing, preventing full investigation. Disaggregated data appears to omit deaths in years with KW53 (possibly filtered before delivery). |
| Thüringen | Known issue | Sums off for 2016–2020 (years with below-threshold suppression). Other years match Destatis. Implied average suppressed value ≈10 deaths per cell (vs stated threshold <3). Suppressed values imputed as 10 in compiled dataset. |
| Baden-Württemberg | Known issue | All years match Destatis except 2016 (~1,000 too low) and 2021 (>1,000 too low). Cause unknown. |

---

# Notes on Year-Boundary Week Attribution

ISO week-year boundaries do not align with calendar year boundaries.

A week spanning 31 December and 1 January may be assigned to the preceding or following year depending on where the majority of its days fall.

Several Länder (Berlin, Brandenburg, Bayern, Sachsen-Anhalt) attribute all deaths in such a week to a single year rather than splitting them. This produces small but systematic discrepancies relative to Destatis totals (which appear to split more precisely).


## Citation

If you use this dataset, please cite:

> Habershon, S. et al. (2025). *[Dataset title]*. Zenodo. https://doi.org/[ZENODO DOI — add after upload]

---

## License

The compiled dataset is licensed under [Creative Commons Attribution 4.0 International (CC BY 4.0)](https://creativecommons.org/licenses/by/4.0/).

Underlying data from each Statistisches Landesamt are subject to the terms described in the Sources table above. Users redistributing derived works must comply with all applicable attribution requirements.
