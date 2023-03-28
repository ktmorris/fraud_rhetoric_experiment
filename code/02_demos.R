mayor_raw <- fread("temp/mayor_with_dq_col.csv")

mayor <- mayor_raw %>% # Make new object ``mayor'' by piping in raw data.
  filter(dq != "1") |> 
  mutate(across(c(bcbm1, bcwm1, wcbm1, wcwm1,
                  bcbm2, bcwm2, wcbm2, wcwm2), ~ ifelse(is.na(.), 0, .)),
         city = case_when(wcwm == 1 | wcbm == 1 ~ "White",
                          bcbm == 1 | bcwm == 1 ~ "Black",
                          T ~ "Control"),
         official = case_when(wcwm == 1 | bcwm == 1 ~ "White",
                              bcbm == 1 | wcbm == 1 ~ "Black",
                              T ~ "Control"),
         all = case_when(wcwm == 1 ~ "White City,\nWhite Official",
                         wcbm == 1 ~ "White City,\nBlack Official",
                         bcbm == 1 ~ "Black City,\nBlack Official",
                         bcwm == 1 ~ "Black City,\nWhite Official",
                         T ~ "Control"),
         city_act = case_when(bcbm1 + bcwm1 + wcbm1 + wcwm1 == 1 ~ "White",
                              bcbm1 + bcwm1 + wcbm1 + wcwm1 == 2 ~ "Black",
                              T ~ "Control"),
         official_act = case_when(bcbm2 + bcwm2 + wcbm2 + wcwm2 == 1 ~ "White",
                                  bcbm2 + bcwm2 + wcbm2 + wcwm2 == 2 ~ "Black",
                                  T ~ "Control"),
         all_act = paste0(city_act, " City,\n", official_act, " Official"),
         all_act = ifelse(grepl("Control", all_act), "Control", all_act),
         across(c(city, official, all, city_act, all_act), ~ relevel(factor(.), ref = "Control")),
         across(c(city, official, city_act, official_act), ~ relevel(factor(.), ref = "Control")),
         across(c(dv1, dv2, starts_with("dw")), ~ 6 - .),
         cand = case_when(q20 == 1 ~ "Biden",
                          q20 == 2 ~ "Trump",
                          T ~ "Other"),
         across(c(rr1, rr4), ~ 6 - .))

#########################################################
rr <- select(mayor, responseid, starts_with("dw"))

rr <- rr[complete.cases(rr), ]

alpha <- psych::alpha(rr %>% 
                        select(-responseid))

ev <- eigen(cor(rr %>% 
                  select(-responseid)))
ev$values

factors_rr <- factanal(rr %>% 
                         select(-responseid), 
                       factors = 1, 
                       scores = "regression")

rr <- cbind(rr, factors_rr$scores) %>% 
  rename(rr_factor = Factor1) %>% 
  select(responseid, rr_factor)

mayor <- left_join(mayor, rename(rr, dw_rr = rr_factor))
#########################################################
rr <- select(mayor, responseid, starts_with("rr"))

rr <- rr[complete.cases(rr), ]

alpha <- psych::alpha(rr %>% 
                        select(-responseid))

ev <- eigen(cor(rr %>% 
                  select(-responseid)))
ev$values

factors_rr <- factanal(rr %>% 
                         select(-responseid), 
                       factors = 1, 
                       scores = "regression")

rr <- cbind(rr, factors_rr$scores) %>% 
  rename(rr_factor = Factor1) %>% 
  select(responseid, rr_factor)

mayor <- left_join(mayor, rename(rr, old_rr = rr_factor))

cleanup(c("mayor", "mayor_raw"))
#########################################################
rr <- select(mayor, responseid, starts_with("white")) |> 
  mutate(across(c(starts_with("white")), ~ 6 - .))

rr <- rr[complete.cases(rr), ]

alpha <- psych::alpha(rr %>% 
                        select(-responseid))

ev <- eigen(cor(rr %>% 
                  select(-responseid)))
ev$values

factors_rr <- factanal(rr %>% 
                         select(-responseid), 
                       factors = 1, 
                       scores = "regression")

rr <- cbind(rr, factors_rr$scores) %>% 
  rename(rr_factor = Factor1) %>% 
  select(responseid, rr_factor)

mayor <- left_join(mayor, rename(rr, white_id = rr_factor))

cleanup(c("mayor", "mayor_raw"))
#############################

mayor <- mayor |> 
  mutate(voted_20 = q19_1 == 2,
         voted_22 = q19_2 == 2,
         support_trump = q20 == 2,
         trust_social = 6 - trust_social,
         trust_gov = 6 - trust_gov,
         male = sex == 1,
         education = case_when(edu <= 2 ~ "HS",
                               edu <= 5 ~ "College",
                               edu <= 8 ~ "Grad"),
         college = education %in% c("College", "Grad"),
         inc = case_when(inc == 1 ~ 10000,
                         inc == 2 ~ 30000,
                         inc == 3 ~ 50000,
                         inc == 4 ~ 70000,
                         inc == 5 ~ 90000,
                         inc == 6 ~ 110000,
                         inc == 7 ~ 120000),
         correct = all == all_act,
         correct_official = official == official_act)

saveRDS(mayor, "temp/mayor_clean.rds")
################################
vars <- c("voted_20", "voted_22", "support_trump", "trust_social",
          "trust_gov", "male", "college", "inc", "dw_rr", "old_rr",
          "white_id", "age", "pid", "ideo")

out <- rbindlist(lapply(vars, function(v){
  
  form <- paste0(v, " ~ all")
  
  m <- rownames_to_column(as.data.frame(summary(lm(form, mayor))[["coefficients"]])) |> 
    mutate(var = v)
  
}))

countof <- mayor |> 
  group_by(rowname = all) |> 
  tally(name = "Estimate") |> 
  mutate(Estimate = comma(Estimate),
         var = "n",
         sig = F)

out <- rbind(out |> 
  mutate(int = (rowname == "(Intercept)") * Estimate) |> 
  group_by(var) |> 
  mutate(int = max(int),
         Estimate = as.character(ifelse(rowname == "(Intercept)", Estimate, int + Estimate)),
         sig = `Pr(>|t|)` < 0.05) |>
  select(var, rowname, Estimate, sig),
         countof) |> 
  mutate(Estimate = case_when(var %in% c("voted_20", "voted_22",
                                             "support_trump", "male",
                                             "college") ~ gsub("%", "\\\\%", percent(as.numeric(Estimate), .1)),
                              var %in% c("trust_social", "trust_gov",
                                         "dw_rr", "old_rr", "white_id",
                                         "age", "pid", "ideo", "n") ~ comma(as.numeric(Estimate), .1),
                              T ~ paste0("\\$", comma(as.numeric(Estimate)))),
         Estimate = ifelse(sig & rowname != "(Intercept)", paste0(Estimate, "*"), Estimate),
         rowname = ifelse(rowname == "(Intercept)", "Control",
                          gsub("all", "", gsub("\n", " ", rowname)))) |> 
  select(-sig) |> 
  pivot_wider(id_cols = var, names_from = rowname, values_from = Estimate)

out <- left_join(out, fread("raw_data/vars.csv")) |> 
  ungroup() |> 
  select(Variable = name, everything(), -var)

note = "* Statistically significantly different than control group (p < 0.05)."

note <- sub("<", "&lt", note)

kable(out, "latex", caption = "\\label{tab:exp-demos} Demographics by Treatment Condition",
      linesep = "",
      booktabs = T, escape = F) |> 
  column_spec(c(1), width = "4cm") |>
  column_spec(c(2:6), width = "2cm") |>
  row_spec(seq(1, nrow(out), by = 2), background = "lightgray") |> 
  
  footnote(general = note) |> 
  save_kable("temp/demos.tex")

df <- data.frame(
  col1 = c("A", "B", "C"),
  col2 = c(1, 2, 3),
  col3 = c("<", "=", ">")
)

# create a footnote with \textless instead of <
footnote <- "The \\textless{} symbol represents less than."

# use kable to output the table with the footnote
kable(df, "latex") %>%
  kable_styling(latex_options = c("striped", "hold_position"),
                font_size = 12) %>%
  footnote(general = footnote) |> 
  save_kable("temp/demos.tex")