library(tidyverse)
library(jsonlite)
library(lubridate)
library(glue)
library(googlesheets4)
library(countrycode)
library(zoo)
library(scales)



df <- read_csv('https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/vaccinations/vaccinations.csv')

pop_pt <- 10196707

#
# # Checking additional data
# pt_data_sheets <- read_sheet('https://docs.google.com/spreadsheets/d/1x00tupx8Kb20fxAXQW6tCaaDp9ArbLogrlsMQz81R_E/edit?usp=sharing')
#
# #update data fully vaccinated
# date_sheets <- pt_data_sheets %>% filter(date == max(date)) %>% select(date) %>% pull()
# date_df <- df %>% filter(location == 'Portugal') %>% filter(date == max(date)) %>% select(date) %>% pull()
#
#
# # Replace data from OWID with Google Sheets data
# # pt <- df %>% filter(location == "Portugal") %>% filter(date < '2021-02-01')
# df <- df %>% filter(location != "Portugal")
#
#
# azores <- read_sheet('https://docs.google.com/spreadsheets/d/1x00tupx8Kb20fxAXQW6tCaaDp9ArbLogrlsMQz81R_E/edit?usp=sharing', sheet = 'Açores')
# madeira <- read_sheet('https://docs.google.com/spreadsheets/d/1x00tupx8Kb20fxAXQW6tCaaDp9ArbLogrlsMQz81R_E/edit?usp=sharing', sheet = 'Madeira')
#
#
# pt_data_sheets <- pt_data_sheets %>%
#   left_join(azores, by = 'date') %>%
#   left_join(madeira, by = 'date') %>%
#   fill(total_vaccinations_acores, .direction = 'down') %>%
#   fill(people_vaccinated_acores, .direction = 'down') %>%
#   fill(people_fully_vaccinated_acores, .direction = 'down') %>%
#   fill(total_vaccinations_madeira, .direction = 'down') %>%
#   fill(people_vaccinated_madeira, .direction = 'down') %>%
#   fill(people_fully_vaccinated_madeira, .direction = 'down')
#
#
# pt_data_sheets <- pt_data_sheets %>%
#   rowwise() %>%
#   mutate(total_vaccinations = sum(total_vaccinations, total_vaccinations_acores, total_vaccinations_madeira, na.rm = T) ) %>%
#   mutate(people_vaccinated = sum(people_vaccinated, people_vaccinated_acores, people_vaccinated_madeira, na.rm = T) ) %>%
#   mutate(people_fully_vaccinated = sum(people_fully_vaccinated, people_fully_vaccinated_acores, people_fully_vaccinated_madeira, na.rm = T) )
#
#
# pt_data_sheets$total_vaccinations[30] <- NA
# pt_data_sheets$people_vaccinated[30:34] <- NA
# pt_data_sheets$people_fully_vaccinated[30:34] <- NA
#
#
# pt <- pt_data_sheets %>%
#   select(-total_vaccinations_acores, -total_vaccinations_madeira,  -people_vaccinated_acores, -people_vaccinated_madeira, -people_fully_vaccinated_acores, -people_fully_vaccinated_madeira)
#
#
# pt <- pt %>%
#     ungroup() %>%
#     mutate(daily_vaccinations_raw = total_vaccinations - lag(total_vaccinations)) %>%
#     mutate(daily_vaccinations_raw_fake = ifelse(is.na(daily_vaccinations_raw), 10258, daily_vaccinations_raw)) %>%
#     mutate(daily_vaccinations_fake = zoo::rollmean(
#       daily_vaccinations_raw_fake, k = 7, fill = NA, align = 'right')) %>%
#     mutate(daily_vaccinations_fake = round(daily_vaccinations_fake)) %>%
#     mutate(daily_vaccinations = coalesce(daily_vaccinations, daily_vaccinations_fake)) %>%
#     select(-daily_vaccinations_raw_fake, -daily_vaccinations_fake)
#
#
#
# # #Get latest values from Açores
# # azores <- read_sheet('https://docs.google.com/spreadsheets/d/1x00tupx8Kb20fxAXQW6tCaaDp9ArbLogrlsMQz81R_E/edit?usp=sharing', sheet = 'Açores') %>%
# #   filter(date == max(date))
# #
# # madeira <- read_sheet('https://docs.google.com/spreadsheets/d/1x00tupx8Kb20fxAXQW6tCaaDp9ArbLogrlsMQz81R_E/edit?usp=sharing', sheet = 'Madeira') %>%
# #   filter(date == max(date))
# #
# # #Sum the latest data
# # pt_latest <- pt %>% filter(date == max(date))
# # pt <- pt %>% filter(date != max(date))
# #
# # pt_latest <- pt_latest %>%
# #   mutate(total_vaccinations = total_vaccinations + azores$total_vaccinations[1] + madeira$total_vaccinations[1]) %>%
# #   mutate(people_vaccinated = people_vaccinated + azores$people_vaccinated[1] + madeira$people_vaccinated[1]) %>%
# #   mutate(people_fully_vaccinated = people_fully_vaccinated + azores$people_fully_vaccinated[1] + madeira$people_fully_vaccinated[1])
# #
# # pt <- pt %>%
# #   bind_rows(pt_latest)
#
# pt <- pt %>%
#     mutate(total_vaccinations_per_hundred = ifelse(
#       date == date_sheets, round((total_vaccinations /pop_pt) * 100, 2),
#       total_vaccinations_per_hundred
#     )) %>%
#     mutate(people_vaccinated_per_hundred = ifelse(
#       date == date_sheets, round((people_vaccinated /pop_pt) * 100, 2),
#       people_vaccinated_per_hundred
#     )) %>%
#     mutate(people_fully_vaccinated_per_hundred = ifelse(
#       date == date_sheets, round((people_fully_vaccinated /pop_pt) * 100, 2),
#       people_fully_vaccinated_per_hundred
#     ))
#
#
#   pt <- pt %>%
#     mutate(total_vaccinations_per_hundred = round( (total_vaccinations /pop_pt)* 100, 2)) %>%
#     mutate(people_vaccinated_per_hundred = round( (people_vaccinated /pop_pt)* 100, 2)) %>%
#     mutate(people_fully_vaccinated_per_hundred = round( (people_fully_vaccinated /pop_pt)* 100, 2) )
#
#
#
# df <- df %>% bind_rows(pt)
#
# df <- df %>%
#   mutate(date = as.Date(date))



# if (is.na(value_owid)) {
#
#   df <- df %>%
#     mutate(people_fully_vaccinated = ifelse(date == date_sheets & location == 'Portugal',value_sheets, people_fully_vaccinated)) %>%
#     mutate(people_vaccinated = ifelse(date == date_sheets & location == 'Portugal', total_vaccinations - value_sheets, people_vaccinated)) %>%
#     mutate(people_vaccinated_per_hundred = ifelse(date == date_sheets & location == 'Portugal', round((people_vaccinated/pop_pt)*100, 2), people_vaccinated_per_hundred )) %>%
#     mutate(people_fully_vaccinated_per_hundred = ifelse(date == date_sheets & location == 'Portugal', round((people_fully_vaccinated/pop_pt)*100, 2), people_fully_vaccinated_per_hundred ))
#
# }




portugal <- df %>%
  filter(location == "Portugal")


updated_pt <- max(portugal$date)
updated_pt_all_data <- portugal %>% filter(people_fully_vaccinated == max(people_fully_vaccinated, na.rm = T)) %>% pull(date)


updated_pt_text <- glue('{day(updated_pt_all_data)} de {month(updated_pt_all_data, label = TRUE, abbr = FALSE, locale="pt_PT")} de {year(updated_pt_all_data)}')

# vacinados_1_dose <- portugal %>% filter(date == updated_pt) %>% select(vacinas_1_dose) %>% pull()
# per_unit <- floor(vacinados_1_dose / pop_pt) * 100

update <- Sys.Date()
updated <- glue('Actualizado a {day(update)} de {month(update, label = TRUE, abbr = FALSE, locale="pt_PT")} de {year(update)}')

dateTime <- glue('{weekdays(update,abbreviate = T)}, {day(update)} {month(update,label = TRUE, abbr = TRUE)} {year(update)} {format(Sys.time(), "%X")} GMT')


# Ritmo para atingir os 70% da população adulta:

ages <- read_csv('ages.csv') %>%
  filter(TIME == 2019) %>%
  filter(SEX == "Total") %>%
  group_by(GEO) %>%
  summarise(sum = sum(Value)) %>%
  filter(GEO != "European Economic Area (EU28 - 2013-2020 and IS, LI, NO)" & GEO != "European Economic Area (EU27 - 2007-2013 and IS, LI, NO)"
         & GEO != "European Union - 28 countries (2013-2020)"
         & GEO != "European Union - 27 countries (2007-2013)"
         & GEO != "Euro area - 19 countries  (from 2015)"
         & GEO != "Euro area - 18 countries (2014)"
         & GEO != "Germany (until 1990 former territory of the FRG)"
         & GEO != "European Free Trade Association"
         & GEO != "European Union - 27 countries (from 2020)"
         & GEO != "Kosovo (under United Nations Security Council Resolution 1244/99)"
         ) %>%
  mutate(GEO = gsub('Germany including former GDR', 'Germany', GEO)) %>%
  filter(!is.na(sum)) %>%
  rename('location' = "GEO")

# Pop com mais de 20 anos

latest_data <- df %>% filter(!is.na(total_vaccinations)) %>%  group_by(location) %>% filter(date == max(date))

# Prevision

prevision <- left_join(latest_data %>% select(location, date, total_vaccinations, daily_vaccinations), ages ) %>%
  filter(!is.na(sum)) %>%
  mutate(sum = 0.7* sum) %>%
  mutate(doses_prev = sum * 2) %>%
  mutate(doses_prev = doses_prev - total_vaccinations) %>%
  mutate(prev_dias = ceiling(doses_prev / daily_vaccinations)) %>%
  mutate(prev_date = date + prev_dias) %>%
  mutate(dias_faltam = as.numeric(as.Date('2021-09-22') - date)) %>%
  mutate(expected_daily_vacination = round(doses_prev / dias_faltam)) %>%
  mutate(ratio = ceiling(expected_daily_vacination / daily_vaccinations)) %>%
  mutate(prev_date_long = glue('{day(prev_date)} de {month(prev_date, label = TRUE, abbr = FALSE, locale="pt_PT")} de {year(prev_date)}')) %>%
  filter(location != 'Liechtenstein') %>%
  filter(location != 'Ukraine') %>%
  filter(location != 'Armenia')

prevision_table <- prevision %>%
  select(location, date, daily_vaccinations, prev_date, prev_date_long, expected_daily_vacination)

prev_values <- data.frame(
  location = NA,
  values = NA
)

for (i in 1:length(prevision_table$location)) {

  cat(i)

  pais <- prevision_table$location[i]
  date_loop <- prevision_table$date[i]

  y <- data.frame(
    V1 = NA
  )

  week <- 7
  for (a in 0:7) {


    x <- df %>%
      filter(location == pais) %>%
      filter(date == date_loop - (week-a)) %>%
      select(daily_vaccinations) %>%
      pull()


    y[a,1] <- x
  }

  y$V1 <- rescale(y$V1, to = c(0, 100))
  y$V1 <- round(y$V1)

  prev_values[i,1] <- pais
  prev_values[i,2] <- glue('{y}')

}


prevision_table <- prevision_table %>% left_join(prev_values)


eu_countries <- read_csv('https://pkgstore.datahub.io/opendatafortaxjustice/listofeucountries/listofeucountries_csv/data/5ab24e62d2ad8f06b59a0e7ffd7cb556/listofeucountries_csv.csv') %>%
  rename('location' = 'x') %>%
  filter(location != "United Kingdom") %>%
  mutate(location = gsub('Slovak Republic','Slovakia', location)) %>%
  mutate(location = gsub('Czech Republic','Czechia', location))



prevision_table <- left_join(eu_countries,prevision_table) %>%
  arrange(prev_date) %>%
  mutate(pais_pt = countrycode(location, origin = 'country.name', destination = 'cldr.short.pt')) %>%
  mutate(pais_pt = gsub('Eslovênia','Eslovénia', pais_pt)) %>%
  mutate(pais_pt = gsub('Estônia','Estónia', pais_pt)) %>%
  mutate(pais_pt = gsub('Polônia','Polónia', pais_pt)) %>%
  mutate(pais_pt = gsub('Romênia','Roménia', pais_pt)) %>%
  mutate(pais_pt = gsub('Tchéquia','República Checa', pais_pt)) %>%
  mutate(pais_pt = gsub('Letônia','Letónia', pais_pt)) %>%
  mutate(pais = gsub('Mônaco','Mónaco', pais)) %>%
  select(-location) %>%
  mutate(order = rank(prev_date)) %>%
  mutate(values = gsub('c\\(','{', values)) %>%
  mutate(values = gsub('\\)','}', values)) %>%
  mutate(values = gsub(' ','', values))


# Estado Vacinação em PT

estado_vc <- read_csv('state_vc.csv')






most_vacinated <- df %>% group_by(location) %>%
  filter(people_vaccinated== max(people_vaccinated, na.rm = T)) %>%
  filter(date == max(date)) %>%
  arrange(-people_vaccinated_per_hundred) %>%
  ungroup() %>%
  filter(location != "World") %>%
  filter(location != 'Northern Ireland' & location != 'England' & location != 'Scotland' & location != 'Wales' & location != 'European Union'  & location != 'Europe') %>%
  filter(location != 'Gibraltar' & location != 'Guernsey'  & location != 'Isle of Man' & location != 'Faeroe Islands' & location != 'Bermuda' & location != 'Jersey' & location != 'Cayman Islands' & location != 'Montserrat' & location != 'North America' & location != 'Northern Cyprus' & location != 'Falkland Islands' & location != 'Saint Helena' & location != 'Anguilla' & location != 'Turks and Caicos Islands' & location != 'Macao' & location != 'Greenland' & location != 'South America' & location != 'Hong Kong' & location != 'Curacao' & location != 'Wallis and Futuna' & location != 'Pitcairn') %>%
  mutate(pais_pt = countrycode(location, origin = 'country.name', destination = 'cldr.short.pt')) %>%
  mutate(pais_pt = gsub('Eslovênia','Eslovénia', pais_pt)) %>%
  mutate(pais_pt = gsub('Estônia','Estónia', pais_pt)) %>%
  mutate(pais_pt = gsub('Polônia','Polónia', pais_pt)) %>%
  mutate(pais_pt = gsub('Romênia','Roménia', pais_pt)) %>%
  mutate(pais_pt = gsub('Tchéquia','República Checa', pais_pt)) %>%
  mutate(pais_pt = gsub('Letônia','Letónia', pais_pt)) %>%
  mutate(pais_pt = gsub('Egito','Egipto', pais_pt)) %>%
  mutate(pais_pt = gsub('Mônaco','Mónaco', pais_pt)) %>%
  mutate(pais_pt = gsub('Emirados Árabes Unidos','Emir. Árabes Unidos', pais_pt)) %>%
  mutate(flags =  countrycode(location, origin = 'country.name', destination = 'unicode.symbol')) %>%
  mutate(order = row_number(-people_vaccinated_per_hundred)) %>%
  mutate(pais_pt2 = glue('{pais_pt} {flags} - {order}º')) %>%
  mutate(pais = glue('{pais_pt}')) %>%
  mutate(pais_pt = glue('{pais_pt} {flags}'))
  # filter(!is.na(people_vaccinated_per_hundred)) %>%
  # mutate(people_fully_vaccinated_per_hundred = ifelse(is.na(people_fully_vaccinated_per_hundred),0,people_fully_vaccinated_per_hundred ))




data_eu <- df %>% group_by(location) %>% filter(date == max(date)) %>% arrange(-people_vaccinated_per_hundred) %>%
  ungroup() %>%
  filter(location == "European Union")


most_vacinated_with_pt <- most_vacinated %>%
  select(location,pais, pais_pt, pais_pt2, total_vaccinations_per_hundred,people_vaccinated_per_hundred, people_fully_vaccinated_per_hundred, total_vaccinations, order, date) %>%
  filter(order <= 20) %>%
  mutate(people_fully_vaccinated_per_hundred = replace_na(people_fully_vaccinated_per_hundred, 0))

pt_data <- most_vacinated %>% filter(location == 'Portugal') %>% select(location,pais, pais_pt, pais_pt2, total_vaccinations_per_hundred,people_vaccinated_per_hundred, people_fully_vaccinated_per_hundred, total_vaccinations, order, date)

if (most_vacinated_with_pt %>% filter(location == "Portugal") %>% nrow() == 0) {
  most_vacinated_with_pt[21,4] <- "..."

  most_vacinated_with_pt <- bind_rows(most_vacinated_with_pt, pt_data )
}

artigos <- read_csv('artigos_paises.csv')
most_vacinated_with_pt  <- left_join(most_vacinated_with_pt,artigos)


lista_nomes_paises <- df %>%
  filter(location != "World") %>%
  filter(location != 'Northern Ireland' & location != 'England' & location != 'Scotland' & location != 'Wales' & location != 'European Union' ) %>%
  filter(location != 'Gibraltar' & location != 'Guernsey'  & location != 'Isle of Man' & location != 'Faeroe Islands' & location != 'Bermuda' & location != 'Jersey' & location != 'Cayman Islands' & location != 'Montserrat' & location != 'North America' & location != 'Northern Cyprus' & location != 'Falkland Islands' & location != 'Saint Helena' & location != 'Anguilla' & location != 'Turks and Caicos Islands' & location != 'Macao' & location != 'Greenland' & location != 'South America' & location != 'Hong Kong' & location != 'Curacao' & location != 'Wallis and Futuna' & location != 'Pitcairn') %>%
  mutate(pais = countrycode(location, origin = 'country.name', destination = 'cldr.short.pt')) %>%
  mutate(pais = gsub('Eslovênia','Eslovénia', pais)) %>%
  mutate(pais = gsub('Estônia','Estónia', pais)) %>%
  mutate(pais = gsub('Polônia','Polónia', pais)) %>%
  mutate(pais = gsub('Romênia','Roménia', pais)) %>%
  mutate(pais = gsub('Tchéquia','República Checa', pais)) %>%
  mutate(pais = gsub('Letônia','Letónia', pais)) %>%
  mutate(pais = gsub('Egito','Egipto', pais)) %>%
  mutate(pais = gsub('Mônaco','Mónaco', pais)) %>%
  mutate(pais = gsub('Groenlândia','Gronelândia', pais)) %>%
  mutate(pais = gsub('Groenlândia','Gronelândia', pais)) %>%
  mutate(pais = gsub('Irã','Irão', pais)) %>%
  mutate(pais = gsub('Irã','Irão', pais)) %>%
  mutate(pais = gsub('Quênia','Quénia', pais)) %>%
  mutate(pais = gsub('Quênia','Quénia', pais)) %>%
  mutate(pais = gsub('Maurício','Maurícia', pais)) %>%
  mutate(pais = gsub('Maurício','Maurícia', pais)) %>%
  mutate(pais = gsub('Moldova','Moldávia', pais)) %>%
  mutate(pais = gsub('Moldova','Moldávia', pais)) %>%
  mutate(pais = gsub('Macedônia do Norte','Macedónia do Norte', pais)) %>%
  mutate(pais = gsub('Macedônia do Norte','Macedónia do Norte', pais)) %>%
  mutate(pais = gsub('Vietnã','Vietnam', pais)) %>%
  mutate(pais = gsub('Emirados Árabes Unidos','Emir. Árabes Unidos', pais)) %>%
  select(pais) %>%
  distinct(pais) %>%
  mutate(value = pais,
         text = pais) %>%
  arrange(value) %>%
  select(-pais)


# Get data for all Countries

countries <- df %>%
  filter(location != "World") %>%
  filter(location != 'Northern Ireland' & location != 'England' & location != 'Scotland' & location != 'Wales' & location != 'European Union' ) %>%
  filter(location != 'Gibraltar' & location != 'Guernsey'  & location != 'Isle of Man' & location != 'Faeroe Islands' & location != 'Bermuda' & location != 'Jersey' & location != 'Cayman Islands' & location != 'Montserrat' & location != 'North America' & location != 'Northern Cyprus' & location != 'Falkland Islands' & location != 'Saint Helena' & location != 'Anguilla' & location != 'Turks and Caicos Islands' & location != 'Macao' & location != 'Greenland' & location != 'South America' & location != 'Hong Kong' & location != 'Curacao' & location != 'Wallis and Futuna' & location != 'Pitcairn') %>%
  mutate(pais = countrycode(location, origin = 'country.name', destination = 'cldr.short.pt')) %>%
  mutate(pais = gsub('Eslovênia','Eslovénia', pais)) %>%
  mutate(pais = gsub('Estônia','Estónia', pais)) %>%
  mutate(pais = gsub('Polônia','Polónia', pais)) %>%
  mutate(pais = gsub('Romênia','Roménia', pais)) %>%
  mutate(pais = gsub('Tchéquia','República Checa', pais)) %>%
  mutate(pais = gsub('Letônia','Letónia', pais)) %>%
  mutate(pais = gsub('Egito','Egipto', pais)) %>%
  mutate(pais = gsub('Mônaco','Mónaco', pais)) %>%
  mutate(pais = gsub('Groenlândia','Gronelândia', pais)) %>%
  mutate(pais = gsub('Groenlândia','Gronelândia', pais)) %>%
  mutate(pais = gsub('Irã','Irão', pais)) %>%
  mutate(pais = gsub('Irã','Irão', pais)) %>%
  mutate(pais = gsub('Quênia','Quénia', pais)) %>%
  mutate(pais = gsub('Quênia','Quénia', pais)) %>%
  mutate(pais = gsub('Maurício','Maurícia', pais)) %>%
  mutate(pais = gsub('Maurício','Maurícia', pais)) %>%
  mutate(pais = gsub('Moldova','Moldávia', pais)) %>%
  mutate(pais = gsub('Moldova','Moldávia', pais)) %>%
  mutate(pais = gsub('Macedônia do Norte','Macedónia do Norte', pais)) %>%
  mutate(pais = gsub('Macedônia do Norte','Macedónia do Norte', pais)) %>%
  mutate(pais = gsub('Vietnã','Vietnam', pais)) %>%
  mutate(pais = gsub('Emirados Árabes Unidos','Emir. Árabes Unidos', pais)) %>%
  select(location,pais) %>%
  distinct(pais, .keep_all = T)










a <- df %>% left_join(countries) %>% filter(!is.na(pais))

min_date <- min(a$date)
max_date <- max(a$date)

dates <- data.frame(
  date = seq(min_date, max_date , by="days")
)

list_countries <- a %>% select(pais) %>% distinct() %>% pull()

final_dates <- data.frame(
)

for (i in 1:length(list_countries)) {
  dates$pais <- list_countries[i]

  final_dates <- bind_rows(final_dates, dates)
}

a <- final_dates %>% left_join(a)


object <- list()

for (i in 1:length(list_countries)) {

  pais_1 <- list_countries[i]
  data<- a %>% filter(pais == pais_1) %>% select(total_vaccinations_per_hundred) %>% pull()

  values <- list(data)

 object[i] <- values
}

names(object) <- list_countries


# Create Data for Continents

countries <- countries %>%
  mutate(continente =  countrycode(location, origin = 'country.name', destination = 'region')) %>%
  select(-location) %>%
  mutate(continente = ifelse(pais == "Malta", gsub('Middle East & North Africa', 'Europe & Central Asia',continente), continente)) %>%
  mutate(continente = ifelse(pais == "North America", gsub('Middle East & North Africa', 'Latin America & Caribbean',continente), continente))

t <- countries %>% select(continente) %>% distinct()

a <- a %>% left_join(countries)




#Middle East & North Africa

list_countries_middle_east <- a %>% filter(continente == 'Middle East & North Africa') %>%
  arrange(-total_vaccinations_per_hundred) %>% select(pais) %>% distinct() %>% pull()

max_middle_east <- a %>% filter(continente == 'Middle East & North Africa') %>% select(total_vaccinations_per_hundred) %>% distinct() %>% arrange(-total_vaccinations_per_hundred)

max_middle_east <- max_middle_east[1,1]

object_middle_east <- list()

for (x in 1:length(list_countries_middle_east )) {

  pais_1 <- list_countries_middle_east[x]
  data<- a %>%
    filter(continente == 'Middle East & North Africa') %>%
    filter(pais == pais_1) %>% select(total_vaccinations_per_hundred) %>%
    pull()

  values <- list(data)

  data<- a %>%
    filter(continente == 'Middle East & North Africa') %>%
    filter(pais == pais_1) %>% select(people_fully_vaccinated_per_hundred) %>%
    pull(people_fully_vaccinated_per_hundred)

  values2 <- list(data)

  teste <- rbind(values, values2)

  object_middle_east[x] <- list(
    teste
  )
}

names(object_middle_east) <- list_countries_middle_east




#Europe & Central Asia

list_countries_europe <- a %>% filter(continente == 'Europe & Central Asia') %>%
  arrange(-total_vaccinations_per_hundred) %>% select(pais) %>% distinct() %>% pull()

max_europe <- a %>% filter(continente == 'Europe & Central Asia') %>% select(total_vaccinations_per_hundred) %>% distinct() %>% arrange(-total_vaccinations_per_hundred)

max_europe <- max_europe[1,1]

object_europe <- list()

for (x in 1:length(list_countries_europe)) {

  pais_1 <- list_countries_europe[x]
  data<- a %>%
    filter(continente == 'Europe & Central Asia') %>%
    filter(pais == pais_1) %>% select(total_vaccinations_per_hundred) %>%
    pull()

  values <- list(data)

  data<- a %>%
    filter(continente == 'Europe & Central Asia') %>%
    filter(pais == pais_1) %>% select(people_fully_vaccinated_per_hundred) %>%
    pull(people_fully_vaccinated_per_hundred)

  values2 <- list(data)

  teste <- rbind(values, values2)

  object_europe[x] <- list(
    teste
  )
}

names(object_europe ) <- list_countries_europe





#Sub-Saharan Africa

list_countries_africa <- a %>% filter(continente == 'Sub-Saharan Africa') %>%
  arrange(-total_vaccinations_per_hundred) %>% select(pais) %>% distinct() %>% pull()

max_africa <- a %>% filter(continente == 'Sub-Saharan Africa') %>% select(total_vaccinations_per_hundred) %>% distinct() %>% arrange(-total_vaccinations_per_hundred)

max_africa  <- max_africa[1,1]

object_africa <- list()

for (x in 1:length(list_countries_africa)) {

  pais_1 <- list_countries_africa[x]
  data<- a %>%
    filter(continente == 'Sub-Saharan Africa') %>%
    filter(pais == pais_1) %>% select(total_vaccinations_per_hundred) %>%
    pull()

  values <- list(data)

  data<- a %>%
    filter(continente == 'Sub-Saharan Africa') %>%
    filter(pais == pais_1) %>% select(people_fully_vaccinated_per_hundred) %>%
    pull(people_fully_vaccinated_per_hundred)

  values2 <- list(data)

  teste <- rbind(values, values2)

  object_africa[x] <- list(
    teste
  )
}

names(object_africa) <- list_countries_africa




#Sub-Saharan Africa

list_america_norte <- a %>% filter(continente == 'North America') %>%
  arrange(-total_vaccinations_per_hundred) %>% select(pais) %>% distinct() %>% pull()

max_america_norte <- a %>% filter(continente == 'North America') %>% select(total_vaccinations_per_hundred) %>% distinct() %>% arrange(-total_vaccinations_per_hundred)

max_america_norte   <- max_america_norte[1,1]

object_america_norte<- list()

for (x in 1:length(list_america_norte )) {

  pais_1 <- list_america_norte[x]
  data<- a %>%
    filter(continente == 'North America') %>%
    filter(pais == pais_1) %>% select(total_vaccinations_per_hundred) %>%
    pull()

  values <- list(data)

  data<- a %>%
    filter(continente == 'North America') %>%
    filter(pais == pais_1) %>% select(people_fully_vaccinated_per_hundred) %>%
    pull(people_fully_vaccinated_per_hundred)

  values2 <- list(data)

  teste <- rbind(values, values2)

  object_america_norte[x] <- list(
    teste
  )
}

names(object_america_norte) <- list_america_norte




#East Asia & Pacific
list_east_asia <- a %>% filter(continente == 'East Asia & Pacific') %>%
  arrange(-total_vaccinations_per_hundred) %>% select(pais) %>% distinct() %>% pull()

max_east_asia <- a %>% filter(continente == 'East Asia & Pacific') %>% select(total_vaccinations_per_hundred) %>% distinct() %>% arrange(-total_vaccinations_per_hundred)

max_east_asia <- max_east_asia [1,1]

object_east_asia<- list()

for (x in 1:length(list_east_asia )) {

  pais_1 <- list_east_asia[x]
  data<- a %>%
    filter(continente == 'East Asia & Pacific') %>%
    filter(pais == pais_1) %>% select(total_vaccinations_per_hundred) %>%
    pull()

  values <- list(data)

  data<- a %>%
    filter(continente == 'East Asia & Pacific') %>%
    filter(pais == pais_1) %>% select(people_fully_vaccinated_per_hundred) %>%
    pull(people_fully_vaccinated_per_hundred)

  values2 <- list(data)

  teste <- rbind(values, values2)

  object_east_asia[x] <- list(
    teste
  )
}

names(object_east_asia) <- list_east_asia



#Latin America & Caribbean
list_america_latina <- a %>% filter(continente == 'Latin America & Caribbean') %>%
  arrange(-total_vaccinations_per_hundred) %>% select(pais) %>% distinct() %>% pull()

max_america_latina <- a %>% filter(continente == 'Latin America & Caribbean') %>% select(total_vaccinations_per_hundred) %>% distinct() %>% arrange(-total_vaccinations_per_hundred)

max_america_latina  <- max_america_latina[1,1]

object_america_latina <- list()

for (x in 1:length(list_america_latina )) {

  pais_1 <- list_america_latina[x]
  data<- a %>%
    filter(continente == 'Latin America & Caribbean') %>%
    filter(pais == pais_1) %>% select(total_vaccinations_per_hundred) %>%
    pull()

  values <- list(data)

  data<- a %>%
    filter(continente == 'Latin America & Caribbean') %>%
    filter(pais == pais_1) %>% select(people_fully_vaccinated_per_hundred) %>%
    pull(people_fully_vaccinated_per_hundred)

  values2 <- list(data)

  teste <- rbind(values, values2)

  object_america_latina[x] <- list(
    teste
  )
}

names(object_america_latina) <- list_america_latina



#South Asia
list_south_asia <- a %>% filter(continente == 'South Asia') %>%
  arrange(-total_vaccinations_per_hundred) %>% select(pais) %>% distinct() %>% pull()

max_south_asia <- a %>% filter(continente == 'South Asia') %>% select(total_vaccinations_per_hundred) %>% distinct() %>% arrange(-total_vaccinations_per_hundred)

max_south_asia  <- max_south_asia[1,1]

object_south_asia <- list()

for (x in 1:length(list_south_asia)) {

  pais_1 <- list_south_asia[x]
  data<- a %>%
    filter(continente == 'South Asia') %>%
    filter(pais == pais_1) %>% select(total_vaccinations_per_hundred) %>%
    pull()

  values <- list(data)

  data<- a %>%
    filter(continente == 'South Asia') %>%
    filter(pais == pais_1) %>% select(people_fully_vaccinated_per_hundred) %>%
    pull(people_fully_vaccinated_per_hundred)

  values2 <- list(data)

  teste <- rbind(values, values2)

  object_south_asia[x] <- list(
    teste
  )
}

names(object_south_asia) <- list_south_asia


rrr <- df %>%
  group_by(location) %>%
  filter(date == max(date)) %>%
  select(location, total_vaccinations_per_hundred) %>%
  filter(location != "World") %>%
  filter(location != 'Northern Ireland' & location != 'England' & location != 'Scotland' & location != 'Wales' & location != 'European Union') %>%
  filter(location != 'Gibraltar' & location != 'Guernsey'  & location != 'Isle of Man' & location != 'Faeroe Islands' & location != 'Bermuda' & location != 'Jersey' & location != 'Cayman Islands' & location != 'Montserrat' & location != 'North America' & location != 'Northern Cyprus' & location != 'Falkland Islands' & location != 'Saint Helena' & location != 'Anguilla' & location != 'Turks and Caicos Islands' & location != 'Macao' & location != 'Greenland' & location != 'South America' & location != 'Hong Kong' & location != 'Curacao' & location != 'Wallis and Futuna' & location != 'Pitcairn') %>%
  ungroup() %>%
  mutate(order = row_number(-total_vaccinations_per_hundred)) %>%
  arrange(order)




daily_vacinations_pt <- df %>% filter(location == "Portugal") %>%
  select(date, daily_vaccinations ) %>%
  filter(!is.na(daily_vaccinations))



# Novos dados da DGS

new_data <- read_delim('RV_CSV_1.csv', delim = ';') %>%
  mutate(DATE = dmy(DATE)) %>%
  filter(WEEK == '27')

update_dados_idades <- new_data %>% select(DATE, TYPE) %>% filter(TYPE == 'GENERAL') %>%  filter(DATE == max(DATE)) %>% select(DATE) %>% pull()

update_dados_idades <- glue('{day(update_dados_idades)} de {month(update_dados_idades, label = TRUE, abbr = FALSE, locale="pt_PT")} de {year(update_dados_idades)}')

ages_pt <- new_data %>%
  filter(AGEGROUP != 'All') %>%
  select(AGEGROUP, CUMUL_VAC_1, CUMUL_VAC_2, COVER_1_VAC, COVER) %>%
  mutate(COVER_1_VAC = gsub(',','.',COVER_1_VAC)) %>%
  mutate(COVER = gsub(',','.',COVER)) %>%
  mutate(COVER_1_VAC = as.numeric(COVER_1_VAC)) %>%
  mutate(COVER = as.numeric(COVER)) %>%
  mutate(COVER_1_VAC = round(COVER_1_VAC * 100, 2)) %>%
  mutate(COVER = round(COVER * 100, 2))

ages_pt_2 <- ages_pt %>%
  arrange(-COVER_1_VAC)

ars <- new_data %>%
  filter(REGION != "All") %>%
  select(REGION,  CUMUL_VAC_1, CUMUL_VAC_2, COVER_1_VAC, COVER) %>%
  mutate(COVER_1_VAC = gsub(',','.',COVER_1_VAC)) %>%
  mutate(COVER = gsub(',','.',COVER)) %>%
  mutate(COVER_1_VAC = as.numeric(COVER_1_VAC)) %>%
  mutate(COVER = as.numeric(COVER)) %>%
  mutate(COVER_1_VAC = round(COVER_1_VAC * 100, 2)) %>%
  mutate(COVER = round(COVER * 100, 2)) %>%
  mutate(REGION = gsub('RA_Madeira', 'R.A. Madeira', REGION)) %>%
  mutate(REGION = gsub('RA_Acores', 'R.A. Açores', REGION))

ars_no_other <- ars %>%
  filter(REGION != 'Outro') %>%
  arrange(COVER_1_VAC)

#
# # doses admin vs stock
# vacinas_stock <- read_sheet('https://docs.google.com/spreadsheets/d/1x00tupx8Kb20fxAXQW6tCaaDp9ArbLogrlsMQz81R_E/edit#gid=1437138386',sheet = 'Folha2')
#
#
# doses_admin <- df %>% filter(location == "Portugal") %>%
#   select(date, total_vaccinations) %>%
#   filter(date >= '2021-01-24') %>%
#   left_join(vacinas_stock)
#
# date_values_true_stock <- doses_admin %>%
#   filter(!is.na(doses)) %>%
#   filter(doses == max(doses)) %>%
#   select(date) %>%
#   pull()




data <- list(
  update_geral = list(
    updated = updated,
    dateTime = dateTime
  ),
  portugal = list(
    vacinados_1_dose = list(
      total = portugal %>% filter(people_vaccinated == max(people_vaccinated,na.rm = T)) %>% select(people_vaccinated) %>% pull(),
      per = round(portugal %>% filter(people_vaccinated == max(people_vaccinated,na.rm = T)) %>% select(people_vaccinated_per_hundred)%>% pull(), digits = 2),
      per_unit = floor(portugal %>% filter(people_vaccinated == max(people_vaccinated,na.rm = T)) %>% select(people_vaccinated_per_hundred)%>% pull()),
      per_dec = (round(portugal %>% filter(people_vaccinated == max(people_vaccinated,na.rm = T)) %>% select(people_vaccinated_per_hundred)%>% pull(), digits = 2) - floor(portugal %>% filter(people_vaccinated == max(people_vaccinated,na.rm = T)) %>% select(people_vaccinated_per_hundred)%>% pull())) * 100
      ),
    vacinados_imunizados = list(
      total = portugal %>% filter(people_fully_vaccinated == max(people_fully_vaccinated,na.rm = T)) %>% select(people_fully_vaccinated) %>% pull(),
      per = portugal %>% filter(people_fully_vaccinated == max(people_fully_vaccinated,na.rm = T)) %>% select(people_fully_vaccinated_per_hundred) %>% pull(),
      per_unit= floor(portugal %>% filter(people_fully_vaccinated == max(people_fully_vaccinated,na.rm = T)) %>% select(people_fully_vaccinated_per_hundred) %>% pull()),
      per_dec = (portugal %>% filter(people_fully_vaccinated == max(people_fully_vaccinated,na.rm = T)) %>% select(people_fully_vaccinated_per_hundred) %>% pull() - floor(portugal %>% filter(people_fully_vaccinated == max(people_fully_vaccinated,na.rm = T)) %>% select(people_fully_vaccinated_per_hundred) %>% pull()) ) * 100
    ),
    # doses_administradas = portugal %>% filter(date == updated_pt) %>% select(total_vaccinations) %>% pull(),
    estado = estado_vc  %>% filter(atual == TRUE) %>% select(fase) %>% pull(),
    rank = rrr %>% filter(location == "Portugal") %>% pull(order),
    updated = updated_pt_text,
    ritmo_vacinacao = list(
      dates = daily_vacinations_pt$date,
      data = daily_vacinations_pt$daily_vaccinations
      ),
    estado_fase_1 = list(
      estado = estado_vc %>% filter(atual == TRUE) %>% select(fase) %>% pull(fase),
      sub_hospitais_fs = list(
        started = estado_vc  %>% filter(sub == 11) %>% select(started) %>% pull(started),
        data = estado_vc  %>% filter(sub == 11) %>% select(data) %>% pull(data),
        completed = estado_vc  %>% filter(sub == 11) %>% select(completed) %>% pull(completed),
        end_prev = estado_vc  %>% filter(sub == 11) %>% select(data_conclusao_prevista) %>% pull(data_conclusao_prevista),
        total_previstos = estado_vc  %>% filter(sub == 11) %>% select(total_previstos) %>% pull(total_previstos),
        updated = estado_vc  %>% filter(sub == 11) %>% select(updated) %>% pull(updated),
        total_vacinados = list(
          data = estado_vc  %>% filter(sub == 11) %>% select(data) %>% pull(data),
          total_1_vacina = estado_vc  %>% filter(sub == 11) %>% select(total_1_vacina) %>% pull(total_1_vacina),
          total_2_vacina = estado_vc  %>% filter(sub == 11) %>% select(total_2_vacina) %>% pull(total_2_vacina)
        )
      ),
      sub_lares = list(
        started = estado_vc  %>% filter(sub == 12) %>% select(started) %>% pull(started),
        data = estado_vc  %>% filter(sub == 12) %>% select(data) %>% pull(data),
        completed = estado_vc  %>% filter(sub == 12) %>% select(completed) %>% pull(completed),
        end_prev = estado_vc  %>% filter(sub == 12) %>% select(data_conclusao_prevista) %>% pull(data_conclusao_prevista),
        total_previstos = estado_vc  %>% filter(sub == 12) %>% select(total_previstos) %>% pull(total_previstos),
        total_vacinados = list(
          data = estado_vc  %>% filter(sub == 12) %>% select(data) %>% pull(data),
          total_1_vacina = estado_vc  %>% filter(sub == 12) %>% select(total_1_vacina) %>% pull(total_1_vacina),
          total_2_vacina = estado_vc  %>% filter(sub == 12) %>% select(total_2_vacina) %>% pull(total_2_vacina)
        )
      ),
      sub_50_pat = list(
        started = estado_vc  %>% filter(sub == 13) %>% select(started) %>% pull(started),
        data = estado_vc  %>% filter(sub == 13) %>% select(data) %>% pull(data),
        completed = estado_vc  %>% filter(sub == 13) %>% select(completed) %>% pull(completed),
        end_prev = estado_vc  %>% filter(sub == 13) %>% select(data_conclusao_prevista) %>% pull(data_conclusao_prevista),
        total_previstos = estado_vc  %>% filter(sub == 13) %>% select(total_previstos) %>% pull(total_previstos),
        total_vacinados = list(
          data = estado_vc  %>% filter(sub == 13) %>% select(data) %>% pull(data),
          total_1_vacina = estado_vc  %>% filter(sub == 13) %>% select(total_1_vacina) %>% pull(total_1_vacina),
          total_2_vacina = estado_vc  %>% filter(sub == 13) %>% select(total_2_vacina) %>% pull(total_2_vacina)
        )
      ),

      politicos = list(
        started = estado_vc  %>% filter(sub == 14) %>% select(started) %>% pull(started),
        data = estado_vc  %>% filter(sub == 14) %>% select(data) %>% pull(data),
        completed = estado_vc  %>% filter(sub == 14) %>% select(completed) %>% pull(completed),
        end_prev = estado_vc  %>% filter(sub == 14) %>% select(data_conclusao_prevista) %>% pull(data_conclusao_prevista),
        total_previstos = estado_vc  %>% filter(sub == 14) %>% select(total_previstos) %>% pull(total_previstos),
        total_vacinados = list(
          data = estado_vc  %>% filter(sub == 14) %>% select(data) %>% pull(data),
          total_1_vacina = estado_vc  %>% filter(sub == 14) %>% select(total_1_vacina) %>% pull(total_1_vacina),
          total_2_vacina = estado_vc  %>% filter(sub == 14) %>% select(total_2_vacina) %>% pull(total_2_vacina)
        )
      ),

      mais_80 = list(
        started = estado_vc  %>% filter(sub == 15) %>% select(started) %>% pull(started),
        data = estado_vc  %>% filter(sub == 15) %>% select(data) %>% pull(data),
        completed = estado_vc  %>% filter(sub == 15) %>% select(completed) %>% pull(completed),
        end_prev = estado_vc  %>% filter(sub == 15) %>% select(data_conclusao_prevista) %>% pull(data_conclusao_prevista),
        total_previstos = estado_vc  %>% filter(sub == 15) %>% select(total_previstos) %>% pull(total_previstos),
        total_vacinados = list(
          data = estado_vc  %>% filter(sub == 15) %>% select(data) %>% pull(data),
          total_1_vacina = estado_vc  %>% filter(sub == 15) %>% select(total_1_vacina) %>% pull(total_1_vacina),
          total_2_vacina = estado_vc  %>% filter(sub == 15) %>% select(total_2_vacina) %>% pull(total_2_vacina)
        )
      )


    ),

    estado_fase_2 = list(
      sub_65_sem_pat = list(
        started = estado_vc  %>% filter(sub == 21) %>% select(started) %>% pull(started),
        data = estado_vc  %>% filter(sub == 21) %>% select(data) %>% pull(data),
        completed = estado_vc  %>% filter(sub == 21) %>% select(completed) %>% pull(completed),
        end_prev = estado_vc  %>% filter(sub == 21) %>% select(data_conclusao_prevista) %>% pull(data_conclusao_prevista),
        total_previstos = estado_vc  %>% filter(sub == 21) %>% select(total_previstos) %>% pull(total_previstos),
        total_vacinados = list(
          data = estado_vc  %>% filter(sub == 21) %>% select(data) %>% pull(data),
          total_1_vacina = estado_vc  %>% filter(sub == 21) %>% select(total_1_vacina) %>% pull(total_1_vacina),
          total_2_vacina = estado_vc  %>% filter(sub == 21) %>% select(total_2_vacina) %>% pull(total_2_vacina)
        )
      ),
      sub_50_pat = list(
        started = estado_vc  %>% filter(sub == 22) %>% select(started) %>% pull(started),
        data = estado_vc  %>% filter(sub == 22) %>% select(data) %>% pull(data),
        completed = estado_vc  %>% filter(sub == 22) %>% select(completed) %>% pull(completed),
        end_prev = estado_vc  %>% filter(sub == 22) %>% select(data_conclusao_prevista) %>% pull(data_conclusao_prevista),
        total_previstos = estado_vc  %>% filter(sub == 22) %>% select(total_previstos) %>% pull(total_previstos),
        total_vacinados = list(
          data = estado_vc  %>% filter(sub == 22) %>% select(data) %>% pull(data),
          total_1_vacina = estado_vc  %>% filter(sub == 22) %>% select(total_1_vacina) %>% pull(total_1_vacina),
          total_2_vacina = estado_vc  %>% filter(sub == 22) %>% select(total_2_vacina) %>% pull(total_2_vacina)
        )
      )
    ),


    estado_fase_3 = list(
      sub_tres = list(
        started = estado_vc  %>% filter(sub == 31) %>% select(started) %>% pull(started),
        data = estado_vc  %>% filter(sub == 31) %>% select(data) %>% pull(data),
        completed = estado_vc  %>% filter(sub == 31) %>% select(completed) %>% pull(completed),
        end_prev = estado_vc  %>% filter(sub == 31) %>% select(data_conclusao_prevista) %>% pull(data_conclusao_prevista),
        total_previstos = estado_vc  %>% filter(sub == 31) %>% select(total_previstos) %>% pull(total_previstos),
        total_vacinados = list(
          data = estado_vc  %>% filter(sub == 31) %>% select(data) %>% pull(data),
          total_1_vacina = estado_vc  %>% filter(sub == 31) %>% select(total_1_vacina) %>% pull(total_1_vacina),
          total_2_vacina = estado_vc  %>% filter(sub == 31) %>% select(total_2_vacina) %>% pull(total_2_vacina)
        )
      )
    )

  ),
  # previsao = list(
  #   portugal = prevision %>% filter(location == "Portugal"),
  #   europe = list(
  #     order_pt = prevision_table %>% filter(pais_pt == "Portugal") %>% select(order) %>% pull(),
  #     europe_data = prevision_table
  #   )
  # ),
  vacinas_mundo = list(
    paises = most_vacinated_with_pt$pais_pt2,
    vacines = most_vacinated_with_pt$total_vaccinations_per_hundred,
    dates =  as.character(as.Date(most_vacinated_with_pt$date, "%Y%m%d"),"%d-%m-%Y"),
    people_vacinated = round(most_vacinated_with_pt$people_vaccinated_per_hundred - most_vacinated_with_pt$people_fully_vaccinated_per_hundred, 2),
    people_fully_vaccinated = most_vacinated_with_pt$people_fully_vaccinated_per_hundred,
    data_normal = most_vacinated_with_pt,
    data_pt = most_vacinated_with_pt %>% filter(location == "Portugal"),
    atras = most_vacinated %>% filter(order == most_vacinated_with_pt %>% filter(location == "Portugal") %>% pull(order) - 1) %>% select(pais_pt,total_vaccinations_per_hundred),
    a_frente = most_vacinated %>% filter(order == most_vacinated_with_pt %>% filter(location == "Portugal") %>% pull(order) + 1) %>% select(pais_pt,total_vaccinations_per_hundred),
    data_eu = data_eu %>% select(people_vaccinated_per_hundred) %>% pull()
  ),
  vacinas_selector = list(
    names_paises = lista_nomes_paises,
    data_paises = object,
    dates = a %>% select(date) %>% distinct() %>% pull()
  ),
  # wall_charts = list(
  #   middle_east = list(
  #     names_paises = list_countries_middle_east,
  #     data_paises = object_middle_east,
  #     dates = a %>% select(date) %>% distinct() %>% pull(),
  #     max = max_middle_east
  #   ),
  #   europe = list(
  #     names_paises = list_countries_europe,
  #     data_paises = object_europe,
  #     dates = a %>% select(date) %>% distinct() %>% pull(),
  #     max = max_europe
  #   ),
  #   africa = list(
  #     names_paises = list_countries_africa,
  #     data_paises = object_africa,
  #     dates = a %>% select(date) %>% distinct() %>% pull(),
  #     max = max_africa
  #   ),
  #   america_norte = list(
  #     names_paises = list_america_norte,
  #     data_paises = object_america_norte,
  #     dates = a %>% select(date) %>% distinct() %>% pull(),
  #     max = max_america_norte
  #   ),
  #   east_asia = list(
  #     names_paises = list_east_asia,
  #     data_paises = object_east_asia,
  #     dates = a %>% select(date) %>% distinct() %>% pull(),
  #     max = max_east_asia
  #   ),
  #   america_latina = list(
  #     names_paises = list_america_latina,
  #     data_paises = object_america_latina,
  #     dates = a %>% select(date) %>% distinct() %>% pull(),
  #     max = max_america_latina
  #   ),
  #   south_asia = list(
  #     names_paises = list_south_asia,
  #     data_paises = object_south_asia,
  #     dates = a %>% select(date) %>% distinct() %>% pull(),
  #     max = max_south_asia
  #   )
  # ),
  idades = list(
    labels = ages_pt$AGEGROUP,
    per_1dose = ages_pt$COVER_1_VAC - ages_pt$COVER,
    per_2dose = ages_pt$COVER,
    data = ages_pt
  ),
  ars = list(
    labels = ars_no_other$REGION,
    per_1dose = ars_no_other$COVER_1_VAC - ars_no_other$COVER,
    per_2dose = ars_no_other$COVER,
    data = ars_no_other
  )
  # stock = list(
  #   dates = doses_admin$date,
  #   values_doses_admin = doses_admin$total_vaccinations,
  #   values_stock_true = doses_admin %>% filter(date <= date_values_true_stock) %>% select(doses) %>% pull()
  # )
)




data <- data %>% toJSON(pretty = FALSE, auto_unbox = TRUE, na = "null")

write(data, "data.json")

# pt %>% select(location, iso_code, date, total_vaccinations, people_vaccinated, people_fully_vaccinated, daily_vaccinations_raw) %>%
#   write_csv('portuguese_data_vaccination.csv')
# #
# # madeira %>% write_csv('dados_madeira.csv')
# # azores %>% write_csv('dados_acores.csv')

