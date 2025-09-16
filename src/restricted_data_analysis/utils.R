library(scales)

months_vec <- c(
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec"
)

race_ethnicity_vec <- c(
  "White",
  "Asian",
  "Black",
  "Hispanic",
  "Native",
  "Other"
)

courthouse_vec <- c(
  "Hall of Justice",
  "Palo Alto",
  "South County",
  "Other"
)

factorize_cols <- function(df) {
  df |>
    mutate(
      month = factor(month, levels = months_vec),
      race = factor(race, levels = race_ethnicity_vec),
      prefers_english = factor(prefers_english, levels = c(T, F))
    )
}

counts_by_cut <- function(df, col, category_name, cuts, cut_labels = NULL) {
  if (is.null(cut_labels)) {
    max_digits <- max(nchar(cuts))
    cut_chars <- str_pad(cuts, max_digits, pad = "0")
    cut_labels <- paste0(
      cut_chars[1:(length(cut_chars) - 1)],
      "-",
      cut_chars[2:length(cut_chars)]
    )
  }

  df %>%
    mutate(
      value = cut(
        {{ col }},
        breaks = cuts,
        labels = cut_labels,
        right = FALSE,
        ordered_result = TRUE
      )
    ) %>%
    count(category = category_name, value) %>%
    arrange(value) %>%
    mutate(
      pct = n / sum(n),
      sort_order = row_number(),
      sort_order = if_else(is.na(value), 0, sort_order),
      value = as.character(value),
      value = replace_na(value, "N/A")
    )
}

counts_by_val <- function(df, col, name, value_order = NULL) {
  if (!is.null(value_order)) {
    df <- df %>%
      mutate(
        {{ col }} := factor({{ col }}, levels = value_order, ordered = TRUE)
      )
  }

  df %>%
    count(category = name, value = {{ col }}) %>%
    arrange(value) %>%
    mutate(
      value = str_to_title(value),
      pct = n / sum(n),
      sort_order = row_number(),
      value = as.character(value)
    )
}

calculate_sample_stats <- list(
  . %>%
    counts_by_val(
      any_remand,
      "Any remand during experiment",
      c("TRUE", "FALSE")
    ),
  . %>%
    counts_by_val(
      any_bw_remand,
      "Any bench warrant remand during experiment",
      c("TRUE", "FALSE")
    ),
  . %>%
    counts_by_val(
      any_solo_bw_remand,
      "Any bench warrant remand (without new charges) during experiment",
      c("TRUE", "FALSE")
    ),
  . %>%
    counts_by_cut(
      age_interacted,
      "Age (years)",
      c(18, 25, 35, 45, 55, 99),
      c("18-24", "25-34", "35-44", "45-54", "55+")
    ),
  . %>%
    counts_by_cut(
      distance_to_courthouse_interacted,
      "Distance from home to courthouse (miles)",
      c(0, 1, 4, 8, 100000),
      c("0-0.9", "1-3.9", "4-7.9", "8+")
    ),
  . %>%
    counts_by_cut(
      time_since_phone_update,
      "Time since phone update (months)",
      c(0, (1 / 12), (2 / 12), 3 / 12, 100),
      c("Under 1", "1-2", "2-3", "3+")
    ),
  . %>%
    counts_by_cut(
      bws_5_year_window,
      "Num. bench warrants (prev. 5 years)",
      c(0, 1, 2, 6, 1000),
      c("0", "1", "2-5", "6+")
    ),
  . %>%
    counts_by_cut(
      appts_5_year_window,
      "Num. appearances (prev. 5 years)",
      c(0, 1, 2, 6, 20, 1000),
      c("0", "1", "2-5", "6-19", "20+")
    ),
  . %>%
    counts_by_cut(
      appearance_seq_num,
      "Case appearance sequence number",
      c(1, 2, 3, 6, 1000),
      c("1", "2", "3-5", "6+")
    ),
  . %>%
    counts_by_val(
      race,
      "Race and ethnicity",
      c("Asian", "Black", "Hispanic", "Native", "White", "Other")
    ),
  . %>%
    counts_by_val(
      identifies_as_male,
      "Gender (identifies as male)",
      c("TRUE", "FALSE")
    ),
  . %>%
    counts_by_val(
      new_client,
      "New client (within prev. year)",
      c("TRUE", "FALSE")
    ),
  . %>% counts_by_val(prefers_english, "Prefers English", c("TRUE", "FALSE")),
  . %>%
    counts_by_val(
      mental_health,
      "Potential mental health issue(s)",
      c("TRUE", "FALSE")
    ),
  . %>%
    counts_by_val(
      day_of_week,
      "Day of week",
      c("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat")
    ),
  . %>%
    counts_by_val(
      month,
      "Month",
      months_vec
    ),
  . %>% counts_by_val(case_type, "Case severity"),
  . %>% counts_by_val(courthouse, "Courthouse"),
  . %>%
    count() %>%
    mutate(
      category = "Total clients",
      value = "Total clients",
      pct = 1,
      sort_order = 1
    )
)

latex_percent <- percent_format(accuracy = 0.1, suffix = "\\%")
latex_pp <- percent_format(accuracy = 0.1, suffix = "pp")
date_format_string <- "%B %d, %Y"
negate <- function(x) {
  x * -1
}
pval_to_stars <- function(pval) {
  if (pval < 0.001) {
    return("***")
  } else if (pval < 0.01) {
    return("**")
  } else if (pval < 0.05) {
    return("*")
  } else if (pval < 0.1) {
    return(".")
  } else {
    return("")
  }
}
convert_logodds <- function(model) {
  model %>%
    tidy() %>%
    clean_names() %>%
    mutate(
      estimate_lower_ci = estimate - 1.96 * std_error,
      estimate_lower_one_se = estimate - std_error,
      estimate_upper_ci = estimate + 1.96 * std_error,
      estimate_upper_one_se = estimate + std_error,
      across(contains("estimate"), ~ exp(.), .names = "{.col}_exp")
    )
}
