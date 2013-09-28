PRSAnnotationExtractor
=======================

A Ruby script that extracts ePub highlights from pre-PRS-T1 Sony readers and possibly other ADE-based devices. It includes Nokogiri and CSSPool additions to implement something akin to getComputedStyle in JS (the actual text extraction part doesn't take more than 150 lines, and what remains is the style stuff).

Previously on Linux there was no way to extract those as far as I know (Sony Reader Library seems to work on Wine but nor it nor ADE does recognize the reader). It's probably very late to release this since there have been 3 generations of readers since with a different way to store annotations, but it was never done and I have accumulated too many annotations to count over those 2 years.

Prerequisites
------------

Required gems: nokogiri, csspool, zipruby

        sudo gem install nokogiri
        sudo gem install csspool
        sudo gem install zipruby
        
racc and rexical are also needed to generate the parser, but the generated files are already in the repository.

Usage
------------

        ruby prsannotextract.rb <.annot input> <.epub input>

On my PRS-650 the .annot files can be found in /Digital Editions/Annotations/database/media/books.

The three .rb files must be in the same folder.

Note/Todo
------------

Initially the script was only extracting the text but the first released version also preserves parts of the style. However the CSS selector match checks make the previously lightning fast script, now exponentially crawl, and the extraction can take __up to one minute for two annotations__.

It's really not ideal because we might want to gather all the annotations on the reader and some people have hundreds of them, so although the script can be useful in its current state I'll look for a more efficient way to test for CSS selectors (cache node styles?).

Other TODOs: preserve <br />, 'background-color' (not inheritable so currently isn't preserved for inline elements), ...
