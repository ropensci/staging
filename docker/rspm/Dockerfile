# TODO: get all from https://github.com/rstudio/r-system-requirements
FROM ubuntu:bionic

ENV DEBIAN_FRONTEND noninteractive

RUN \
    apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:marutter/rrutter3.5 && \
    apt-get update && \
    apt-get install -y git curl r-base-dev libcurl4-gnutls-dev libssl-dev libgdal-dev libgeos-dev \
    libproj-dev libopencv-dev libtesseract-dev tesseract-ocr-eng libmagick++-dev \
    libprotobuf-dev protobuf-compiler libgit2-dev libxml2-dev libudunits2-dev \
    libpoppler-cpp-dev libsodium-dev libjq-dev libicu-dev libavfilter-dev cargo \
    libv8-dev libmysqlclient-dev unixodbc-dev libpq-dev language-pack-en-base libgpgme-dev

RUN RPROFILE=$(R RHOME)/etc/Rprofile.site && \
    echo 'options(repos = c(CRAN = "https://demo.rstudiopm.com/all/__linux__/bionic/latest"))' >> "$RPROFILE" && \
    echo 'options(HTTPUserAgent = sprintf("R/%s R (%s)", getRversion(), paste(getRversion(), R.version$platform, R.version$arch, R.version$os)))' >> "$RPROFILE"
