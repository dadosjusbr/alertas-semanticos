# Este script só entra em ação após renderizar um arquivo qmd, funciona em conjunto com __ quarto.yml
# Após rodar um arquivo qmd, este script irá transfere arquivos HTML para a pasta `docs/``

out_dir <-
  Sys.getenv("QUARTO_PROJECT_OUTPUT_DIR") |>
  fs::path_tidy()

out_files <-
  strsplit(Sys.getenv("QUARTO_PROJECT_OUTPUT_FILES"), "\n")[[1]] |>
  fs::path_tidy()

# "notebook_files" for "notebook.html"
assets <-
  out_files |>
  grep("\\.html$", x = _, value = TRUE) |>
  gsub("\\.html$", "_files", x = _)
assets <- assets[fs::dir_exists(assets)]

fs::file_copy(out_files, out_dir, overwrite = TRUE)
fs::dir_copy(assets, fs::path(out_dir, fs::path_file(assets)), overwrite = TRUE)