library(rmarkdown)

render(
  "src/restricted_data_analysis/calculate_stats.Rmd",
  output_file = "stats.tex",
  output_dir = "output/"
)
