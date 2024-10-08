# Activate renv if not already done
if (!renv::activated()) {
  renv::activate()
}

# Get the list of packages from renv.lock file
lockfile <- renv::load("renv.lock")

# Extract the package names
packages <- names(lockfile$Packages)

# Load each package
invisible(lapply(packages, library, character.only = TRUE))
