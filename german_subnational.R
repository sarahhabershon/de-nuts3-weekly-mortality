library("needs")
needs(tidyverse, ggplot2, readxl, glue, lubridate)
codes <- read_csv("data/nuts3_codes.csv")
nw_codes <- codes %>%
  filter(grepl( "DEA", code_nuts))

ags_mapping_url <- "https://raw.githubusercontent.com/samoeles/AGS-and-NUTS-Germany/main/nuts_ags.csv"
nuts_ags <- read_csv(ags_mapping_url, col_types = "cccccc", locale = locale(encoding = "Latin1")) %>%
  rename(code_nuts = nuts_id)

dates_helper <- data.frame(
  yday = rep(seq(from = 1, by = 1, length.out = 365), 11),
  year = rep(seq(from = 2014, to = 2024, by = 1), each = 365)
)%>%
  mutate(date = ymd(glue("{year}-01-01")) + yday - 1)%>%
  mutate(week_iso = isoweek(date),
         week_thüringen = if_else(yday == 1, 1, NA))

dates_helper$year_iso <- c(NA)
dates_helper$year_iso[1] <- 2014

week_counter <- 1
year_counter <- 2014
for(cur_index in c(2:nrow(dates_helper))){
  if(!is.na(dates_helper$week_thüringen[cur_index])){
    week_counter <- dates_helper$week_thüringen[cur_index]
  }else{
    if(dates_helper$week_iso[cur_index]!= dates_helper$week_iso[cur_index - 1]){
      week_counter <- week_counter + 1
    } 
  }
  if(dates_helper$week_iso[cur_index]== 1 & dates_helper$week_iso[cur_index - 1]!=1){
    year_counter <- year_counter + 1
  }
  dates_helper$week_thüringen[cur_index] <- week_counter
  dates_helper$year_iso[cur_index] <- year_counter
}

weeks_helper <- dates_helper %>%
  select(year_thüringen = year, week_thüringen, week_iso, year_iso)%>%
  unique()

## no original file?
hamburg <- read_csv("data/hamburg.csv") %>%
  drop_na()%>%
 # filter(week < 53) %>%
  pivot_longer(!week, names_to = "year", values_to = "deaths") %>%
  mutate(code_nuts = "DE600",
         name = "Hamburg",
         bundesland = "Hamburg")

## no original file?
schleswig_holstein <- read_csv("data/schleswigholstein.csv") %>%
  mutate(week = as.numeric(week))%>%
  drop_na()%>%
  pivot_longer(!c(week, year), names_to = "name", values_to = "deaths") %>%
  left_join(read_csv("data/SH_nuts3.csv") %>%
              rename(name = NUTS_NAME)) %>%
  mutate(bundesland = "Schleswig-Holstein")

## no original file?
nordrhine_westphalen <- read_csv("data/NRW.csv", skip = 5) %>%
  ## when using berichtsjahr (first col) sums match destatis data
  rename(year = ...1,
         week = Nr.) %>%
  select(!c(Jahr, `Nordrhein-Westfalen`)) %>%
  drop_na()%>%
  pivot_longer(!c( year, week), names_to = "name", values_to = "deaths") %>%
  mutate(name = gsub("Kreisfreie Stadt ", "" , name),
         name = gsub("Kreis ", "", name),
         bundesland = "Nordrhine-Westphalen") %>%
  left_join(nw_codes)

berlin <- read_excel("data/Sterbefälle_KW_2014-2023_K_BBB.xlsx", sheet = 1, skip = 5)  %>%
  rename(year = Jahr) %>%
  pivot_longer(!c(year, Kalenderwoche), names_to = "name", values_to = "deaths") %>%
  mutate(name = gsub("[\r\n]", "", name),
         Kalenderwoche = as.numeric(str_extract(Kalenderwoche, "\\d+")),
         bundesland = "Berlin",
         nuts3_code = "DE300") %>%
  rename(week = Kalenderwoche,
         code_nuts = nuts3_code)

brandenburg <- read_excel("data/Sterbefälle_KW_2014-2023_K_BBB.xlsx", sheet = 2, skip = 5)  %>%
  rename(year = Jahr) %>%
  pivot_longer(!c(year, Kalenderwoche), names_to = "original_name", values_to = "deaths") %>%
  mutate(name = gsub("[\r\n]", "", original_name),
         week = as.numeric(str_extract(Kalenderwoche, "\\d+")),
         bundesland = "Brandenburg") %>%
  left_join(nuts_ags %>% mutate(name = str_trim(str_remove(name, ",.*$")))) %>%
  select(colnames(berlin))

sachsen_anhalt <- read_excel("data/sachsenanhalt 2025_0456.xlsx", skip = 4) %>%
  rename(year = ...1,
         week = ...2) %>% 
  select(!...17) %>%
  filter(week != "insgesamt") %>%
  pivot_longer(!c(year, week), names_to = "original_name", values_to = "deaths") %>%
  mutate(week = as.numeric(str_extract(week, "\\d+")),
         bundesland = "Sachsen-Anhalt",
         name = str_trim(str_remove(original_name, ",.*$")),
         regionale.bezeichnung = ifelse(grepl("kreisfreie Stadt", original_name), "Kreisfreie Stadt", "Landkreis")) %>%
  left_join(nuts_ags %>% 
              mutate(name = str_trim(str_remove(name, ",.*$")))) %>%
  select(colnames(berlin))

## for 2024
# rheinland_pfalz <- read_excel("data/20250406_Mortalität_Uni Leipzig_Recknagel.xlsx", skip = 6) %>%
#   pivot_longer(!c(Jahr, Kalenderwoche), names_to = "original_name", values_to = "deaths") %>%
#   mutate(
#     ags = str_extract(original_name, "^\\d+"),
#     original_name = str_trim(str_remove(original_name, "^\\d+\\s*")),
#     week = as.numeric(str_extract(Kalenderwoche, "\\d+")),
#     bundesland = "Rheinland-Phalz") %>%
#   left_join(nuts_ags) %>%
#   rename(year = Jahr) %>%
#   select(colnames(berlin))

rheinland_pfalz <- read_csv("data/rheinland_pflalz.csv") %>%
  pivot_longer(!c(Jahr, Kalenderwoche), names_to = "original_name", values_to = "deaths") %>%
  mutate(
    ags = str_extract(original_name, "^\\d+"),
    original_name = str_trim(str_remove(original_name, "^\\d+\\s*")),
    week = as.numeric(str_extract(Kalenderwoche, "\\d+")),
    bundesland = "Rheinland-Phalz") %>%
  left_join(nuts_ags) %>%
  rename(year = Jahr) %>%
  drop_na(deaths)%>%
  select(colnames(berlin))


bayern <- read_excel("data/Muster_LÜA_SF_2014-2023_Kr_KW_Bayern.xlsx", skip = 5) %>%
  pivot_longer(!c(Jahr, Kalenderwoche), names_to = "name", values_to = "deaths") %>%
  mutate(week = as.numeric(str_extract(Kalenderwoche, "\\d+")),
    bundesland = "Bayern",
    cleaned_name = str_remove(name, "\\s*\\([^()]*\\)\\s*$") %>% str_trim(),
    regionale.bezeichnung = ifelse(grepl("(Krfr.St)", name), "Kreisfreie Stadt", "Landkreis")) %>%
  left_join(nuts_ags %>%
              rename(cleaned_name = name) %>%
              filter(nchar(code_nuts) == 5)) %>%
  mutate(code_nuts = ifelse(name == "München (Krfr.St)", "DE212", code_nuts),
         bundesland = "Bayern",
         deaths = if_else(is.na(deaths),0, deaths)) %>%
  rename(year = Jahr) %>%
  select(colnames(berlin))


niedersachsen <- read_excel("data/LÜA_Uni_Leipzig_Sterbefälle_KW_20142024.xlsx", skip = 4) %>%
  pivot_longer(!c(Jahr, `Kalender-woche`), names_to = "name", values_to = "deaths") %>%
  filter(`Kalender-woche` != "Insgesamt",
         name != "03 Niedersachsen") %>%
  mutate(
    ags = str_extract(name, "^\\d+"),
    name = str_trim(str_remove(name, "^\\d+\\s*")),
    week = as.numeric(str_extract(`Kalender-woche`, "\\d+")),
    bundesland = "Niedersachsen",
    year = Jahr) %>%
  left_join(nuts_ags) %>%
  select(colnames(berlin))

ba_wu <- read_excel("data/20250613_Anfrage_LÜA_SF_2014-2023_Kr_KW.xlsx", skip = 4) %>%
  select(!`Baden-Württemberg`) %>%
  filter(Jahr != "© Statistisches Landesamt Baden-Württemberg, 2025") %>%
  pivot_longer(!c(Jahr, Kalenderwoche), names_to = "original_name", values_to = "deaths") %>%
  left_join(read_csv("data/ba_wu_assumptions.csv")) %>%
  mutate(week = as.numeric(str_extract(Kalenderwoche, "\\d+")),
         bundesland = "Baden-Württemberg",
         year = as.numeric(Jahr),
         name = ifelse(is.na(name), original_name, name)) %>%
  left_join(nuts_ags) %>%
  select(colnames(berlin))

sachsen <- read_excel("data/109_LÜA_SF_2014-2023_Kr_KW_VIS.xlsx", skip = 5) %>%
  pivot_longer(!c(Jahr, Kalenderwoche), names_to = "name", values_to = "deaths") %>%
  mutate(regionale.bezeichnung = ifelse(grepl("Stadt", name), "Kreisfreie Stadt", "Landkreis"),
         week = as.numeric(str_extract(Kalenderwoche, "\\d+")),
         name = gsub("\u00A0", " ", name),
         bundesland = "Sachsen") %>%
  rename(year = Jahr) %>%
  left_join(nuts_ags) %>%
  select(colnames(berlin))%>%
  ## filter out calculated sums
  filter(name != "Sachsen ")
  


# Ba-wu sent a file that did not differentiate between the two Heilbronns, nor the two Karlsruhes. So for now I am making an assumption based on the figures for 2014 as to which is which, depending on their respective populations.
# Heilbronn Stadt has a population of 131,653, Landkreis Heilbronn has population 353,609, so based on the death values I assign Heilbronn Stadt to Heilbronn...9, and Landkreis Heilbronn to Heilbronn...10. Similar with Karlsruhe, Karlsruhe Stadt has population 308,197, Landkreis Karlsrude has population 455,350. Therefore I assign Karlsruhe Stadt to Karlsruhe...17, and Landkreis Karlsruhe to Karlsruhe...18.

hessen <- read_excel("data/Gestorbene_in Hessen_2014bis 2023_wochenbasiert.xlsx", skip = 1) %>%
  select(!`Land Hessen`) %>%
  pivot_longer(!c(Jahr, KW), names_to = "original_name", values_to = "deaths") %>%
  mutate(
    ags = paste0("06", str_extract(original_name, "^\\d+")),
    original_name = str_trim(str_remove(original_name, "^\\d+\\s*")),
    week = as.numeric(str_extract(KW, "\\d+")),
    bundesland = "Hessen",
    year = Jahr) %>%
  left_join(nuts_ags) %>%
  select(colnames(berlin))

bremen_yearly_sum <- read_excel('data/LUEK_Uni Leipzig_  Auswertung_Sterbefälle_Bremen.xlsx', skip = 4) %>%
select(!...1) %>%
  rename(name = ...2,
         calendar_week = ...3) %>%
  filter(calendar_week != "Insgesamt",
         name != "Land Bremen") %>% 
  pivot_longer(!c(name, calendar_week), names_to = "year", values_to = "deaths") %>% 
  mutate(year = as.numeric(year),
         week = case_when(
           ## unclear what these labels mean - possibly for weekly calculations need
           ## to be attributed to year before/after, but for yearly sums the year is correct
           ## in comparison with destatis yearly sums.
           calendar_week == "52/ 53 (Vorjahr)" ~ "53", 
           calendar_week == "1 (Folgejahr)" ~ "53",
           TRUE ~ calendar_week),
         code_nuts = ifelse(name == "Stadt Bremen", "DE501", "DE502"),
         bundesland = "Bremen") %>%
  mutate(week = as.numeric(week))%>%
  ## there are week 53's for all years, some of them NAs
  drop_na(deaths)%>%
  select(colnames(berlin))
## in the above, the yearly sum matches with destatis.
## but for analysis the weeks need to be made consistent with other states, see below

bremen_iso_weeks <- bremen_yearly_sum %>%
  left_join(weeks_helper, by = c("year" = "year_thüringen", "week" = "week_thüringen"))%>%
  select(-year,-week)%>%
  group_by(across(c(-deaths)))%>%
  summarize(deaths = sum(deaths))%>%
  rename(year = year_iso, week= week_iso)

thuringen <- read_excel("data/TH_wöchentliche Sterbefallzahlen_Uni Leipzig_0477-2025.xlsx", skip = 20) %>%
  filter(!is.na(Jahr)) %>% pivot_longer(!c(Jahr, Kalenderwoche), names_to = "ags" , values_to = "redacted_deaths")  %>%
  mutate(week = as.numeric(str_extract(Kalenderwoche, "\\d+")),
         year = as.numeric(Jahr),
         bundesland = "Thuringen",
         deaths = ifelse(redacted_deaths == ".", 0 , as.numeric(redacted_deaths))) %>%
  filter(nchar(ags) == 5) %>%
  left_join(nuts_ags) %>%
  select(colnames(berlin))
# Thuringen redacts values lower than 3. when comparing with destatis sums 
## (see below) the average redacted value should be a death-count of 10 though

thuringen_iso_weeks <- thuringen %>%
  left_join(weeks_helper, by = c("year" = "year_thüringen", "week" = "week_thüringen"))%>%
  select(-year,-week)%>%
  group_by(across(c(-deaths)))%>%
  summarize(deaths = sum(deaths))%>%
  rename(year = year_iso, week= week_iso)

saarland <- read_excel("data/Anfrage_Fr-Vainberger_Sterbefälle_SL_KW-2014-2023.xlsx", skip = 1) %>%
  filter(!is.na(Kalenderwoche))%>%
  pivot_longer(!c(Jahr, Kalenderwoche), names_to = "original_name", values_to = "deaths") %>%
  mutate(name = str_replace(original_name, "LK ", ""),
         bundesland = "Saarland") %>%
  filter(name != "Saarland") %>% 
  left_join(nuts_ags) %>%
  rename(year = Jahr,
         week = Kalenderwoche) %>%
  select(colnames(berlin))

meck_pom <- read_excel("data/Mecklenburg-Vorpommern_LÜA_SF_2014-2023_Kr_KW.xlsx", skip = 5) %>%
  select(!`Mecklenburg-Vorpommern`) %>%
  pivot_longer(!c(Jahr, Kalenderwoche), names_to = "name", values_to = "deaths") %>%
  left_join(nuts_ags) %>%
  mutate(week = as.numeric(str_extract(Kalenderwoche, "\\d+")),
         year = as.numeric(Jahr),
         bundesland = "Mecklenburg-Vorpommen") %>%
  select(colnames(berlin))

germany <- berlin %>%
  rbind(hamburg) %>%
  rbind(schleswig_holstein) %>%
  rbind(nordrhine_westphalen) %>%
  rbind(rheinland_pfalz) %>%
  rbind(bayern) %>%
  rbind(niedersachsen) %>%
  rbind(hessen) %>%
  rbind(ba_wu) %>%
  rbind(sachsen_anhalt) %>%
  rbind(brandenburg) %>%
  rbind(thuringen_iso_weeks) %>%
  rbind(sachsen) %>%
  rbind(bremen_iso_weeks) %>%
  rbind(meck_pom) %>%
  rbind(saarland) %>%
  mutate(year = as.numeric(year))%>%
  left_join(dates_helper %>%
              group_by(year_iso, week_iso)%>%
              ## you can also chose the first or last day of the iso week, as you prefer
              summarize (date = mean(date))%>%
              rename(year = year_iso, 
                     week = week_iso))
  ## doesn't work like the below since weeks are now isoweeks, in accordance with eurostat
  ## not sure what the date is supposed to do so i left it out now
  #mutate(date = as.Date(paste0(year, "/", week, "/", 1), format ="%Y/%U/%u"))

## test whether there are any more "half-weeks" for week 1
plotdata <- germany %>% group_by(week, bundesland)%>%mutate(deaths = sum(deaths))
ggplot(plotdata)+
  geom_line(mapping = aes(x = week, y = deaths, color = bundesland))
## nope, looks good

# germany_imputed <- germany %>%
#   group_by(code_nuts) %>%
#   arrange(date) %>%
#   mutate(raw_mort = ifelse(is.na(deaths), lag(deaths), deaths))
# ## what does the above do? is it reasonable?
# 
# ggplot(germany %>% left_join(geodata), aes(geometry = geometry, fill = bundesland)) +
#   geom_sf() +
#   scale_fill_viridis_d(direction = -1)
# 
# write_csv(germany, "germany.csv")
  

# Excess mortality - including Germany

weekly_raw_mort_nuts3 <- weekly_raw_mort_nuts3 %>%
  select(!rollmean) %>%
  rbind(germany_imputed %>% select(c(code_nuts, raw_mort, year, week, date)))

# weekly mortality by nuts3 pre-pando
nuts3_weekly_baseline_mort <- weekly_raw_mort_nuts3 %>%
  drop_na() %>%
  filter(year %in% c(2015, 2016, 2017, 2018, 2019),
         nchar(code_nuts) == 5) %>%
  group_by(code_nuts, week) %>%
  summarise(expected_mort = (sum(raw_mort))/5,
            count = n())

# ex mortality nuts3
exmort_weekly_nuts3 <- weekly_raw_mort_nuts3 %>%
  filter(year %in% c(2020, 2021),
         week < 53,
         nchar(code_nuts) == 5) %>%
  group_by(year, week, code_nuts) %>%
  summarise(actual_mort = sum(raw_mort)) %>%
  left_join(nuts3_weekly_baseline_mort) %>%
  mutate(exmort = (actual_mort-expected_mort)/expected_mort,
         yearweek = as.numeric(paste0(year, week)),
         date = as.Date(paste0(year, "/", week, "/", 1), format ="%Y/%U/%u")) %>%
  ungroup()


exmort_weekly_nuts3_wide <- exmort_weekly_nuts3 %>%
  select(code_nuts, date, exmort) %>%
  mutate(date = paste(date)) %>%
  pivot_wider(names_from = "date", values_from = exmort) 

# view(exmort_weekly_nuts3_wide %>% filter(grepl("DE", code_nuts))) %>% glimpse()


## TESTS COMPARING DISAGGREGATED AND AGGREGATED DATA (destatis)

## bundesländer_years 

test_bl_years <- germany %>%
  left_join(nuts_ags %>% select(ags, code_nuts))%>%
  mutate(ags = case_when(
    bundesland == "Sachsen" ~ "14",
    bundesland == "Niedersachsen" ~ "03",
    T ~ substr(ags, 1, 2)),
    year = as.numeric(year))%>%
  group_by(year, ags)%>%
  ## there are some NA values
  summarize(deaths_ul = sum(deaths, na.rm = T))

destatis_months_bl <- read_csv2("12613-0013_de_flat.csv")%>%
  ## no non-numeric values. in case there are any in the future: destatis has different letters and symbols to add infos to values
  mutate(value_num = as.numeric(value))%>%
  filter(`3_variable_attribute_label` == "Insgesamt")

destatis_years_bl <- destatis_months_bl %>%
  group_by(year = time, ags =  `2_variable_attribute_code`, name = `2_variable_attribute_label`)%>%
  summarise(deaths_destatis = sum(value_num))

compare_yearly_sums <- destatis_years_bl %>%
  full_join(test_bl_years)%>%
  mutate(diff = deaths_destatis - deaths_ul)

ggplot(compare_yearly_sums %>%
         ungroup()%>%
         select(year, name, deaths_ul, deaths_destatis)%>%
         gather(-year, -name, key = key, value = deaths))+
  geom_line(mapping = aes(x = year, y = deaths, color = name, linetype = key))

ggsave("compare_years_bl.png")

ggplot(compare_yearly_sums %>%
         ungroup()%>%
         select(year, name, deaths_ul, deaths_destatis)%>%
         gather(-year, -name, key = key, value = deaths))+
  geom_line(mapping = aes(x = year, y = deaths, color = name, linetype = key))+
  facet_wrap(vars(name))

ggsave("compare_years_bl_facets.png", 
       unit = "px", 
       dpi = 150,
       width = 2000,
       height = 1500)

ggplot(compare_yearly_sums %>%
         ungroup()%>%
         select(year, name, deaths_ul, deaths_destatis)%>%
         gather(-year, -name, key = key, value = deaths))+
  geom_line(mapping = aes(x = year, y = deaths, color = name, linetype = key))+
  facet_wrap(vars(name), scales = "free")

ggsave("compare_years_bl_facets_freey.png", 
       unit = "px", 
       dpi = 150,
       width = 2000,
       height = 1500)


## thüringen

test <- read_excel("data/TH_wöchentliche Sterbefallzahlen_Uni Leipzig_0477-2025.xlsx", skip = 20) %>%
  filter(!is.na(Jahr)) %>% pivot_longer(!c(Jahr, Kalenderwoche), names_to = "ags" , values_to = "redacted_deaths")  %>%
  mutate(week = as.numeric(str_extract(Kalenderwoche, "\\d+")),
         year = as.numeric(Jahr),
         bundesland = "Thuringen",
         deaths = ifelse(redacted_deaths == ".", 0 , as.numeric(redacted_deaths))) %>%
  filter(nchar(ags) == 5) %>%
  left_join(nuts_ags)%>% 
  group_by(year)%>%
  summarize(
    deaths = sum(deaths), 
    redacted_vals = sum(redacted_deaths == ".")) %>% 
  left_join(destatis_years_bl %>% 
              filter(name == "Thüringen"))%>%
  mutate(diff = deaths_destatis - deaths)%>%
  mutate(avg_redacted_death = diff/redacted_vals)%>% 
  select(-ags)%>%
  relocate(name, .before = year)
## shows average redacted value are ~ 10 deaths

## loading eurostat to see how they count the weeks and distribute deaths around end/beginning of year
eurostat <- read_tsv("eurostat/estat_demo_r_mwk_ts.tsv")%>%
  gather(-c(1), key = "date", value = "deaths")%>%
  mutate(week = as.numeric(substr(date, 7,8)),
         year = as.numeric(substr(date, 1,4)))

eurostat %>% group_by(year)%>%summarize(min_week = min(week), max_week = max(week))%>%filter(year > 2013)
## no double weeks
eurostat %>% group_by(year, week, `freq,sex,unit,geo\\TIME_PERIOD`)%>% summarize(n = n())%>%arrange(desc(n))
weeks_deaths <- eurostat%>% 
  group_by(week)%>% 
  summarize(total = sum(as.numeric(deaths), na.rm=T))%>%
  arrange(total)
ggplot(weeks_deaths)+
  geom_line(mapping = aes(x = week, y = total))


## from https://www.destatis.de/DE/Themen/Querschnitt/Corona/_Grafik/_Interaktiv/sterbefallzahlen-woechentlich-jahre.html
destatis_weeks_de <- read_csv2("sterbefallzahlen.csv")%>%
  gather(-Kalenderwoche, key = year, value = deaths_destatis)%>%
  rename(week = Kalenderwoche)%>%
  mutate(year = as.numeric(year))%>%
  arrange(year, week)%>%
  drop_na()%>%
  full_join(germany %>% 
              group_by(year, week)%>%
              summarize(deaths_ul = sum(deaths))) %>%
  ## only year 2022 is comparable, from 2023 onwards berlin is missing in disaggregated data and 2024 even more
  filter(year == 2022)%>%
  ## why is there no data at all in "germany" for weeks 6 - 9 in 2022?
  mutate(difference_percent = (deaths_ul/deaths_destatis - 1) * 100,
         difference_abs = deaths_ul - deaths_destatis)

ggplot(destatis_weeks_de %>%
         select(week, deaths_ul, deaths_destatis)%>%
         gather(-week, key = key, value = deaths))+
  geom_line(mapping = aes(x = week, y= deaths, color = key))

ggsave("compare_weeks_de_total.png")
