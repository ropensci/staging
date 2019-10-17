install_deps <- function(pkg){
  deps <- package_deps(pkg)
  pkgs <- sapply(strsplit(deps, " "), utils::head, 1)
  type <- ifelse(grepl("mingw|darwin", R.Version()$platform), "binary", "source")
  install.packages(pkgs, type = type)
}

package_deps <- function(path = '.'){
  file <- file.path(path, "DESCRIPTION")
  df <- as.data.frame(read.dcf(file), stringsAsFactors = FALSE)
  types <- unlist(unclass(df)[c("Imports", "Depends", "LinkingTo", "Suggests")])
  pkgs <- lapply(types, strsplit, split = ",\\s*")
  unique(unlist(pkgs))
}

Sys.setenv(TAR = "internal")
options(repos = c(CRAN = "https://cloud.r-project.org"))
setRepositories(ind = 1:4)
install_deps(commandArgs(TRUE))
