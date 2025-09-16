library(tidyverse)
library(broom)

# This script replicates models (2), (4), and (6) from Table 2 of the paper.
# Models (1), (3), and (5) require restricted data, though abbreviated versions
# of these models are included here for comparison.

# BENCH WARRANT AT FIRST COURT DATE ############################################

data_first_cd <- read_csv("data/bw_first_cd.csv") |>
  uncount(count)

# Total population count
data_first_cd |>
  count()

# Count by assignment arm
data_first_cd |>
  count(assignment_arm)

# Bench warrant rates by assignment arm
data_first_cd |>
  count(bw_issued_first_cd, assignment_arm) |>
  group_by(assignment_arm) |>
  mutate(pct = n / sum(n)) |>
  filter(bw_issued_first_cd) |>
  ungroup() |>
  mutate(diff = pct - lag(pct))

# Table 2, model (2)
model_simple_first_cd <-
  glm(
    bw_issued_first_cd ~ 1 + assignment_arm,
    data = data_first_cd,
    family = "binomial"
  )
model_simple_first_cd |>
  tidy(exponentiate = TRUE) |>
  mutate(delta.std.error = (estimate^2 * std.error^2)^0.5)

# Adjusted model
# (Table 2, model (1) requires restricted data)
model_adjusted_first_cd <-
  glm(
    bw_issued_first_cd ~ 1 + assignment_arm + .,
    data = data_first_cd,
    family = "binomial"
  )
model_adjusted_first_cd |>
  tidy(exponentiate = TRUE) |>
  mutate(delta.std.error = (estimate^2 * std.error^2)^0.5)


# BENCH WARRANT AT ANY COURT DATE ##############################################

data_any_cd <- read_csv("data/bw_any_cd.csv") |>
  uncount(count)

# Total population count
data_any_cd |>
  count()

# Count by assignment arm
data_any_cd |>
  count(assignment_arm)

# Bench warrant rates by assignment arm
data_any_cd |>
  count(bw_issued_any_cd, assignment_arm) |>
  group_by(assignment_arm) |>
  mutate(pct = n / sum(n)) |>
  filter(bw_issued_any_cd) |>
  ungroup() |>
  mutate(diff = pct - lag(pct))

# Table 2, model (4)
model_simple_any_cd <-
  glm(
    bw_issued_any_cd ~ 1 + assignment_arm,
    data = data_any_cd,
    family = "binomial"
  )
model_simple_any_cd |>
  tidy(exponentiate = TRUE) |>
  mutate(delta.std.error = (estimate^2 * std.error^2)^0.5)

# Adjusted model
# (Table 2, model (3) requires restricted data)
model_adjusted_any_cd <-
  glm(
    bw_issued_any_cd ~ 1 + assignment_arm + .,
    data = data_any_cd,
    family = "binomial"
  )
model_adjusted_any_cd |>
  tidy(exponentiate = TRUE) |>
  mutate(delta.std.error = (estimate^2 * std.error^2)^0.5)


# REMAND AT ANY COURT DATE #####################################################

data_remand <- read_csv("data/bw_remand.csv") |>
  uncount(count)

# Total population count
data_remand |>
  count()

# Count by assignment arm
data_remand |>
  count(assignment_arm)

# Bench warrant rates by assignment arm
data_remand |>
  count(any_solo_bw_remand, assignment_arm) |>
  group_by(assignment_arm) |>
  mutate(pct = n / sum(n)) |>
  filter(any_solo_bw_remand) |>
  ungroup() |>
  mutate(diff = pct - lag(pct))

# Table 2, model (6)
model_simple_remand <-
  glm(
    any_solo_bw_remand ~ 1 + assignment_arm,
    data = data_remand,
    family = "binomial"
  )
model_simple_remand |>
  tidy(exponentiate = TRUE) |>
  mutate(delta.std.error = (estimate^2 * std.error^2)^0.5)

# Adjusted model
# (Table 2, model (5) requires restricted data)
model_adjusted_remand <-
  glm(
    any_solo_bw_remand ~ 1 + assignment_arm + .,
    data = data_remand,
    family = "binomial"
  )
model_adjusted_remand |>
  tidy(exponentiate = TRUE) |>
  mutate(delta.std.error = (estimate^2 * std.error^2)^0.5)
