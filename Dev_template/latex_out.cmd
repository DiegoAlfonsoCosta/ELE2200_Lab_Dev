@echo off
if not exist out mkdir out
lualatex -interaction=nonstopmode -halt-on-error -output-directory=out %*