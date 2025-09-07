library(rmarkdown)

render(
  "src/calculate_stats.Rmd",
  output_file = "stats.tex",
  output_dir = "output/"
)
