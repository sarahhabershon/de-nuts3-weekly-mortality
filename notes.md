what did you do about the deaths that were reported but not assigned to a specific week? https://ec.europa.eu/eurostat/cache/metadata/en/demomwk_esms.htm#shortsource_typeDisseminated

## missing raw files

raw files missing for:
- rp (file for 2024 is there)
- hh
- sh
- nrw

## KW inconsistecies

KWs in germany seem to be named depending on which year most of the days fall into. so there can be 2 KW1 in a year (but from both weeks, the days count into that year) or there can be a KW53 https://www.kw-kalenderwochen.de/
2014: 2 KW1s
2015: 1-53
2016: starts with KW53 then 1-52
2017: starts with KW52 then 1-52
2018: 2 KW1s
2019: 2 KW1s
2020: 1-53
2021: starts with KW53 then 1-52

- hamburg doesn't use W53
- sh uses W53 in 2015, 2016, 2020 and 2021
- nrw uses 53 in 2015 and 2020; if you look at berichtsjahr instead it has kw53 in 2016 and 2021 
- rp uses W53 in 2015, 2016 (doesn't actually have a W53), (not in 2018 & 2019 though it had one), 2020 and 2021 (doesn't actually have a W53)
- bb has one for 2015 and 2020
- sn has one for 2015, 2016, 2020 and 2021
- by has it for 2015 and 2020
- ni uses W53 in 2015, 2016 (doesn't actually have a W53), (not in 2018 & 2019 though it had one), 2020 and 2021 (doesn't actually have a W53)
- bawu uses 53 in 2015 and 2020
- hessen has it for 2015 and 2020
- thür has w53 in all years. deaths for W1 and W53 seem low in most years, so i think they count whatever are the first weeks of jan as a "W1" (incompete week) and all deaths from the last days of the prev year (incomplete week) as "W53". means that the actual full "W1" is in thüringen's data "W2" most years. fixed it in the script..
- saarland uses W53 in 2015, 2016 (doesn't actually have a W53), (not in 2018 & 2019 though it had one), 2020 and 2021 (doesn't actually have a W53)
- meckpom uses W53 in 2015, 2016 (doesn't actually have a W53), (not in 2018 & 2019 though it had one), 2020 and 2021 (doesn't actually have a W53)

## final data comparisons

ISSUES:
- hh: yearly sum identical in some years with destatis others not. can't investigate more bc original file missing. disaggregated data seems to be missing deaths in all years that had a KW53 - were those maybe filtered out?!
- bawu: 2016 too low (by almost 1000), 2021 too low (by more than 1000), all other years identical with destatis
- th: sums off for years 2016-2020 (which is where there are redacted values), before and after is same (2023 & 2024 also off but irrelevant). calculating the difference of destatis deaths and thüringen values without redacted deaths gives an average of 10 per redacted value, though thüringen says they only redact below 3.
- nrw: yearly sum identitcal with destatis if using "berichtsjahr" variable (now fixed, was wrong before) - 2018 is off by 0.3% though

SLIGHTLY OFF:
- berlin & brandenburg & sachsen: numbers all slightly off; original data doesn't split first/last week across years (there are never 2 KW1s) so all deaths from inbetween weeks are probably attributed to one year or the other, while destatis seems to split them more accurately between years. SUMs across 2014 - 2021 are off by 0.14% (Berlin), 0.13% (Brandenburg), 0.08% (Sachsen). 
- bayern: numbers all slightly off; original data doesn't split first/last week across years (there are never 2 KW1s) so all deaths from inbetween weeks are probably attributed to one year or the other, while destatis seems to split them more accurately between years. MISSING VALUES for 2 kreise, 1 week each, in 2021 (W34 kaufbeuren, W37 ansbach). i assume they mean 0 because there are no 0's anywhere else -> fixed like that for now. SUMs across 2014 - 2021 are off by 0.08%

MATCHES:
- sh: yearly sum identical with destatis
- bremen: yearly sum identical with destatis if "vorjahr" & "folgejahr" data is counted for the year of its column and not in the following/yearly sum (except for 2017 is off by 1). fixed in data. (because of different week counting i had to redistribute deaths across years again for the final data, but the sums match - all documented in the script)
- rp: yearly sum identical with destatis if data from KW1 of the following year is added
- sn: yearly sums identical with destatis
- rh-pf: yearly sums identical with destatis when ignoring missing values from W1/52 2016/2017 for kaiserslautern, pirmasens and some others. (fixed in the script now) (only 2016 sum is off by 1)
- ni: yearly sum identical with destatis
- saarland: identical sums
- meckpom: identical sums
- hessen off for some years: 2015, 2016, 2020, 2021, but the sums are the same. destatis and hessen just seem to distribute deaths between 2015 + 2016 and 2020 + 2021 differently.
