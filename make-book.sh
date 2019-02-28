#!/bin/bash

set -e

# apt install docbook-xsl docbook-xsl-ns docbook5-xml

#BOOTSTRAP_HOME=~/src/bootstrap/current

#if [ ! -e ${BOOTSTRAP_HOME}/js/bootstrap.js ];
#then
#  echo "Please check that BOOTSTRAP_HOME is set correctly"
#  exit 1
#fi

(
  cd figs/gnuplot
  ./build.sh
)

STYLESHEET_BASE=/usr/share/xml/docbook/stylesheet/nwalsh
PAPER_SIZE=A4

PDF_BOOK=testoutput/RTCQuickStartGuide.pdf

XSLTPROC="xsltproc --xinclude"
XSLTPROC_HTML="$XSLTPROC"
#XSLTPROC_HTML="$XSLTPROC --stringparam html.stylesheet css/bootstrap.min.css"

# Validate the XML

xmllint \
    --nonet \
    --path '/usr/share/xml/docbook/schema/rng/5.0' \
    --relaxng http://www.docbook.org/xml/5.0/rng/docbookxi.rng \
    --noout book.xml

# Prepare the output directory

rm -rf testoutput
mkdir -p testoutput/single testoutput/multi

# Build the single file HTML document

ln -s ../../figs testoutput/single
#ln -s ${BOOTSTRAP_HOME}/* testoutput/single
$XSLTPROC_HTML -o testoutput/single/book.html ${STYLESHEET_BASE}/xhtml/docbook.xsl book.xml
#$XSLTPROC_HTML -o testoutput/single/book.html book-single.xsl book.xml

# Build the multipage HTML document

ln -s ../../figs testoutput/multi
#ln -s ${BOOTSTRAP_HOME}/* testoutput/multi
$XSLTPROC_HTML --stringparam base.dir testoutput/multi/ --param use.id.as.filename 1 --param chunk.first.sections 1 ${STYLESHEET_BASE}/xhtml/chunk.xsl book.xml
#$XSLTPROC_HTML --stringparam base.dir testoutput/multi/ book-chunk.xsl book.xml

# Build the PDF document

$XSLTPROC \
  --stringparam paper.type $PAPER_SIZE \
  -o testoutput/book.fo \
  ${STYLESHEET_BASE}/fo/docbook.xsl \
  book.xml

fop -pdf testoutput/RTCQuickStartGuide.pdf -fo testoutput/book.fo
rm testoutput/book.fo

