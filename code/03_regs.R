
mayor <- readRDS("temp/mayor_clean.rds")

### overall

m1 <- feols(dv1 ~ all, data = mayor)

m2 <- feols(dv1 ~ all + voted_20 + voted_22 + support_trump +
              trust_social + trust_gov + male + college + inc +
              age + pid + ideo, mayor)

marg <- rbind(ggeffect(m1, terms = c("all[all]")) |> 
                mutate(f = "No Covariates"),
              ggeffect(m2, terms = c("all[all]")) |> 
                mutate(f = "With Covariates"))

ggplot(marg, aes(x = reorder(x, -predicted), y = predicted,
                 ymin = conf.low, ymax = conf.high)) +
  facet_grid(. ~ f)+
  geom_col(color = "black", fill = NA) +
  geom_errorbar(width = 0.2) +
  theme_bc() +
  labs(x = "Treatment Group", y = "Likelihood of Fraud")

###########################################################

### individ

m3 <- feols(dv1 ~ official, data = mayor)

m4 <- feols(dv1 ~ city, mayor)

marg2 <- rbind(ggeffect(m3, terms = c("official[all]")) |> 
                 mutate(f = "Official"),
               ggeffect(m4, terms = c("city[all]")) |> 
                 mutate(f = "Municipality"))

ggplot(marg2, aes(x = reorder(x, -predicted), y = predicted,
                  ymin = conf.low, ymax = conf.high)) +
  facet_grid(. ~ f) +
  geom_col(color = "black", fill = NA) +
  geom_errorbar(width = 0.2) +
  theme_bc() +
  labs(x = "Treatment Group", y = "Likelihood of Fraud")

m5 <- ivreg(dv1 ~ city_act | city, data = mayor)

marg3 <- rbind(ggeffect(m4, terms = c("city[all]")) |> 
                 mutate(f = "OLS"),
               ggeffect(m5, terms = c("city_act[all]")) |> 
                 mutate(f = "IV Reg (ITT)"))

ggplot(marg3, aes(x = reorder(x, -predicted), y = predicted,
                  ymin = conf.low, ymax = conf.high)) +
  facet_grid(. ~ f)+
  geom_col(color = "black", fill = NA) +
  geom_errorbar(width = 0.2) +
  theme_bc() +
  labs(x = "Treatment Group\n(City Demographics)", y = "Likelihood of Fraud")

################################

m6 <- feols(dv1 ~ official * dw_rr + voted_20 + voted_22 + support_trump +
              trust_social + trust_gov + male + college + inc +
              age + pid + ideo, data = mayor)

m7 <- feols(dv1 ~ official * old_rr + voted_20 + voted_22 + support_trump +
              trust_social + trust_gov + male + college + inc +
              age + pid + ideo, data = mayor)

m8 <- feols(dv1 ~ official * white_id + voted_20 + voted_22 + support_trump +
              trust_social + trust_gov + male + college + inc +
              age + pid + ideo, data = mayor)

marg <- rbind(ggeffect(m6, terms = c("dw_rr[all]", "official[all]")) |> 
                mutate(f = "Davis & Wilson\nWhite Resentment toward African Americans"),
              ggeffect(m7, terms = c("old_rr[all]", "official[all]")) |> 
                mutate(f = "Classical Racial Resentment"),
              ggeffect(m8, terms = c("white_id[all]", "official[all]")) |> 
                mutate(f = "White Identity"))

ggplot(marg, aes(x = x, y = predicted, ymin = conf.low, ymax = conf.high,
                 color = group, fill = group)) +
  geom_line() +
  facet_grid(. ~ f) +
  geom_ribbon(alpha = 0.2, color = NA) +
  theme_bc(legend.position = "bottom") +
  labs(x = "Value on Constructed Index",
       y = "Likelihood of Fraud", color = "Treatment Group\n(Official's Race)",
       fill = "Treatment Group\n(Official's Race)",
       caption = "Covariates include self-reported turnout in 2020 and 2022; reported support for Trump over Biden; social and government trust; gender; collegiate education; income; age; party identification (7-points); ideology (7-points).") +
  scale_x_continuous(breaks = c(min(marg$x), max(marg$x)),
                     labels = c("Low", "High"))
