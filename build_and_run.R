library(devtools)

document()
build()
install()

library(distogram)
library(opencpu)

ocpu_start_app("distogram", no_cache = TRUE)
