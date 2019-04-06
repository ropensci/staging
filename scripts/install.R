install_with_deps <- function(pkg){
	cat("Installing: ", pkg, "\n")
	stopifnot(file.exists(pkg))
	path <- normalizePath(dirname(pkg), winslash = "/")
	name <- strsplit(basename(pkg), "_")[[1]][1]

	# Install current version + depds from binary packages
	type <- ifelse(grepl("mingw|darwin", R.Version()$platform), "binary", "source")
	try(install.packages(name, dependencies = TRUE, type = type))

	# Install dev version
	tools::write_PACKAGES(path, type = 'source', verbose = TRUE)
	if(is_windows()) unlink(file.path(path, 'PACKAGES.gz'))
	contrib_url <- c(paste0("file:", path), contrib.url(getOption('repos'), 'source'))
	install.packages(name, contriburl = contrib_url, type = 'source', dependencies = TRUE)
}

is_windows <- function(){
	.Platform$OS.type == 'windows'
}

Sys.setenv(TAR = "internal")
options(repos = c(CRAN = "https://cloud.r-project.org"))
setRepositories(ind = 1:4)
install_with_deps(commandArgs(TRUE))
