PRSAnnotationExtractor
=======================

A Ruby script that extracts ePub highlights from pre-PRS-T1 Sony readers and possibly other ADE-based devices. It includes Nokogiri and CSSPool additions to implement something akin to getComputedStyle in JS (the actual text extraction part doesn't take more than 150 lines, and what remains is the style stuff).

Previously on Linux there was no way to extract those as far as I know (Sony Reader Library seems to work on Wine but nor it nor ADE does recognize the reader). It's probably very late to release this since there have been 3 generations of readers since then that brought a different way to store annotations, but such a tool was never made and I have accumulated too many annotations to count over those 2 years.

Prerequisites
------------

Required gems: nokogiri, csspool, zipruby

        sudo gem install nokogiri
        sudo gem install csspool
        sudo gem install zipruby

Currently csspool is already included because vanilla doesn't support some rare but simple features (@namespace, @page) that are fairly commonly found among epub files, and racc and rexical are also needed to generate the parser, but the generated files are already in the repository.

Usage
------------

        ruby prsannotextract.rb <.annot input> <.epub input>

Will generate an HTML file with all the annotations and print it to the standard output.

On my PRS-650 the .annot files can be found in /Digital Editions/Annotations/database/media/books.

TODOs
------------

*   Preserve 'background-color' (not inheritable so currently isn't preserved for inline elements), ...
*   Test the script with more complex layouts (lists, tables).
*   Add the page number, which isn't stored in the same XML file
*   Merge all annotations of the reader together and sort them by date.
*   QT4 GUI?
