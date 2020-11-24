#!/bin/bash

jupyter-book build ./notebooks/

# notebooks=`find ../notebooks/ -name *.ipynb|grep -v checkpoint|sed 's/ /\ /g'|tr '\n' ' ' `
#jupyter nbconvert --output-dir=target/slides --execute --allow-errors --to slides $notebooks
#jupyter nbconvert --output-dir=target/slides  --no-prompt --allow-errors --to slides $notebooks --SlidesExporter.reveal_theme=sky --SlidesExporter.reveal_scroll=True  
#jupyter nbconvert --output-dir=target/pdf --to pdf $notebooks
