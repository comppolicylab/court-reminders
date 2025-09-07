library(tidyverse)
source("src/utils.R")

experiment_pop <-
  read_csv("data/experiment_population.csv") |>
  factorize_cols()
prereg_pop <-
  read_csv("data/preregistration_population.csv") |>
  factorize_cols()

drop_cols_except <- function(df, outcome_col) {
  df %>%
    select(
      everything(),
      -client_id,
      -experiment_phase,
      -reminder_sent,
      -reminder_confirmed,
      -matches("bw_"),
      {{ outcome_col }}
    )
}

# BENCH WARRANT AT FIRST COURT DATE ############################################

model_first_cd <-
  glm(
    bw_issued_first_cd ~
      1 + assignment_arm + . + bws_5_year_window * appts_5_year_window_inv,
    data = experiment_pop %>%
      drop_cols_except(bw_issued_first_cd),
    family = "binomial"
  )

model_reduced_first_cd <-
  glm(
    bw_issued_first_cd ~ 1 + assignment_arm,
    data = experiment_pop %>%
      drop_cols_except(bw_issued_first_cd),
    family = "binomial"
  )

model_first_cd_interact_severity <-
  glm(
    bw_issued_first_cd ~ 1 + assignment_arm * case_type_adult_felony,
    data = experiment_pop %>%
      drop_cols_except(bw_issued_first_cd),
    family = "binomial"
  )


# BENCH WARRANT AT ANY COURT DATE ##############################################

model_any_cd <-
  glm(
    bw_issued_any_cd ~
      1 + assignment_arm + . + bws_5_year_window * appts_5_year_window_inv,
    data = experiment_pop %>%
      drop_cols_except(bw_issued_any_cd),
    family = "binomial"
  )

model_reduced_any_cd <-
  glm(
    bw_issued_any_cd ~ 1 + assignment_arm,
    data = experiment_pop %>%
      drop_cols_except(bw_issued_any_cd),
    family = "binomial"
  )

model_any_cd_interact_severity <-
  glm(
    bw_issued_any_cd ~ 1 + assignment_arm * case_type_adult_felony,
    data = experiment_pop %>%
      drop_cols_except(bw_issued_any_cd),
    family = "binomial"
  )


# REMAND AT ANY COURT DATE #####################################################

model_incarceration <-
  glm(
    any_solo_bw_remand ~
      1 + assignment_arm + . + bws_5_year_window:appts_5_year_window_inv,
    data = experiment_pop %>%
      drop_cols_except(any_solo_bw_remand),
    family = "binomial"
  )

model_incarceration_simple <-
  glm(
    any_solo_bw_remand ~ 1 + assignment_arm,
    data = experiment_pop %>%
      drop_cols_except(any_solo_bw_remand),
    family = "binomial"
  )

model_incarceration_interact_severity <-
  glm(
    any_solo_bw_remand ~ 1 + assignment_arm * case_type_adult_felony,
    data = experiment_pop %>%
      drop_cols_except(any_solo_bw_remand),
    family = "binomial"
  )


# PREREGISTERED ANALYSIS #######################################################

model_short_v_long_first_cd <-
  glm(
    bw_issued ~
      1 + assignment_arm + . + bws_5_year_window * appts_5_year_window_inv,
    data = prereg_pop %>% select(-client_id),
    family = "binomial"
  )

model_reduced_short_v_long_first_cd <-
  glm(
    bw_issued ~ 1 + assignment_arm,
    data = prereg_pop %>% select(-client_id),
    family = "binomial"
  )
