
0.0.4 / 2016-08-26
==================

  * Cache packages and use code cov
  * Cran-requested changes

New features
  * Revise UI (A single function with console-driven UI)
  - Maintain reverse compatibility
  * Add basic tests for reverse compatibility

Documentation
  * Add usage instructions in README
  * Note deprecation in the reverse-compatible functions
  * Use travis CI for R CMD check and provide coverage from codecov

Fixes for CRAN
  * Use importFrom for functions from graphics, stats, etc
  * Add comments for cran release
  - Use `person` in DESCRIPTION

Author/Contributor

  - Add Tal Galili as contributor
  - Jaime Ashander is maintainer

0.0.3 / 2016-03-24
==================

New features
  * Expand image types using readbitmap package: bmp, png, jpeg

Documentation and citation

  * Add readme: install info, citation and link to Luke Miller's tutorial
  - Add citation info

Package structure and function
  * Passes `R CMD CHECK`
  - Expand Description field in DESCRIPTION
  * Restructure package to allow easy install with `devtools::install_github`
  * Restore graphical settings after plotting

Author/Contributor

  - Add Jaime Ashander as contributor
