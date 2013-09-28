# encoding: utf-8

# Pre-PRS-T1 Sony Readers (and possibly other ADE-based readers) annotation extraction tool
# Required gems: nokogiri, csspool and zipruby
#   ruby prsannotextract.rb <.annot input> <.epub input>

# Author: Elie 'Syniurge' Morisse
# License: MIT
# Date (version): 2013-09-27

# NOTE: initially the script was only extracting the text but the 
# version I'm releasing also preserves parts of the style. However the 
# CSS selector match checks make the previously lightning fast script 
# now exponentially crawl and the extraction can take up to one minute 
# for two annotations. It's really not ideal because we might want to 
# gather all the annotations on the reader and some people have hundreds 
# of them, so although the script can be useful in its current state 
# I'll look for a more efficient way to test for CSS selectors (cache 
# node's styles?).

require 'nokogiri'
require 'csspool'

require 'zipruby'
require 'date'
require 'pathname'

# Hack/extend Nokogiri and CSSPool to implement a function akin to getComputedStyle in JS
# It's a lot of work just to be able to know if a node is inline, bold, italic...
# The text itself of annotations can be extracted rather easily (see the end of the file), but if
# we want to preserve parts of the style, there's no other way but to add all this stuff.
# Maybe this should be included someday somehow in Nokogiri and/or CSSPool.

require './inlineparser'
require './inlinetokenizer'

module CSSPool::CSS
  class Property
    attr_accessor :initval
    attr_accessor :inherit

    def initialize initval, inherit
      @initval = initval.is_a?(String) ? CSSPool::Terms::Ident.new(initval) : initval
      @inherit = inherit
    end
    
    DEFAULTS = {
      'background-color' => Property.new('', true),
      
      'color' => Property.new('', true),
      
      'display' => Property.new('inline', false),
      
      'font-style' => Property.new('normal', true),
      'font-size' => Property.new('normal', true),
      'font-variant' => Property.new('normal', true),
      'font-weight' => Property.new('normal', true),
      
      'text-align' => Property.new('', true),
      'text-decoration' => Property.new('none', false),
      'text-transform' => Property.new('none', true),
      
      'white-space' => Property.new('normal', true),
    }
  end
  
  class Style < Hash
    def initialize()
      super CSSPool::Terms::Ident.new('')
    end
    
    def add_declarations! decls
      for decl in decls
        self[decl.property] = decl.expressions
      end
    end
    
    def inherit! style
      style.each do |property, expressions|
        inherit = false
        
        if Property::DEFAULTS.has_key? property
          inherit = Property::DEFAULTS[property].inherit
        end
        
        if self[property] == 'inherit'
          inherit = true
        elsif self.has_key? property
          next  # the property value is already determined
        end
        
        if not inherit
          next
        end
        
        self[property] = expressions
      end
    end
    
    alias :<< :inherit!
    
    # NOTE: Return a string but not the value itself
    def [](key)
      if !has_key?(key) and Property::DEFAULTS.has_key?(key)
        value = Property::DEFAULTS[key].initval
      else
        value = super(key)
      end
      to_css value
    end
    
    private
    
    def to_css expr
      if expr.is_a? Array
        retval, pre = '', ''
        expr.each do |x|
          retval += "#{pre}#{to_css x}"
          pre = ' '
        end
        retval
      else
        expr.to_css
      end
    end
  end
  
  # CSSPool racc/rexical parser stripped down to parse only declarations
  # There is unfortunately no way to reuse the CSSPool parser so racc and rexical files were duplicated
  class InlineHandler
    attr_accessor :declarations

    def initialize
      @declarations = Array.new
    end

    def property name, exp, important
      @declarations << Declaration.new(name, exp, important, nil)
    end
  end

  class InlineParser < InlineTokenizerBase
    attr_accessor :handler

    def initialize handler = InlineHandler.new
      @handler = handler
    end

    def parse string
      scan_str string
      @handler.declarations
    end
  end
  
  # Recommended default stylesheet from http://www.w3.org/TR/CSS2/sample.html
  DEFAULT_STYLESHEET = <<-CSS
  html, address,
  blockquote,
  body, dd, div,
  dl, dt, fieldset, form,
  frame, frameset,
  h1, h2, h3, h4,
  h5, h6, noframes,
  ol, p, ul, center,
  dir, hr, menu, pre   { display: block; unicode-bidi: embed }
  li              { display: list-item }
  head            { display: none }
  table           { display: table }
  tr              { display: table-row }
  thead           { display: table-header-group }
  tbody           { display: table-row-group }
  tfoot           { display: table-footer-group }
  col             { display: table-column }
  colgroup        { display: table-column-group }
  td, th          { display: table-cell }
  caption         { display: table-caption }
  th              { font-weight: bolder; text-align: center }
  caption         { text-align: center }
  body            { margin: 8px }
  h1              { font-size: 2em; margin: .67em 0 }
  h2              { font-size: 1.5em; margin: .75em 0 }
  h3              { font-size: 1.17em; margin: .83em 0 }
  h4, p,
  blockquote, ul,
  fieldset, form,
  ol, dl, dir,
  menu            { margin: 1.12em 0 }
  h5              { font-size: .83em; margin: 1.5em 0 }
  h6              { font-size: .75em; margin: 1.67em 0 }
  h1, h2, h3, h4,
  h5, h6, b,
  strong          { font-weight: bolder }
  blockquote      { margin-left: 40px; margin-right: 40px }
  i, cite, em,
  var, address    { font-style: italic }
  pre, tt, code,
  kbd, samp       { font-family: monospace }
  pre             { white-space: pre }
  button, textarea,
  input, select   { display: inline-block }
  big             { font-size: 1.17em }
  small, sub, sup { font-size: .83em }
  sub             { vertical-align: sub }
  sup             { vertical-align: super }
  table           { border-spacing: 2px; }
  thead, tbody,
  tfoot           { vertical-align: middle }
  td, th, tr      { vertical-align: inherit }
  s, strike, del  { text-decoration: line-through }
  hr              { border: 1px inset }
  ol, ul, dir,
  menu, dd        { margin-left: 40px }
  ol              { list-style-type: decimal }
  ol ul, ul ol,
  ul ul, ol ol    { margin-top: 0; margin-bottom: 0 }
  u, ins          { text-decoration: underline }
  br:before       { content: "\A"; white-space: pre-line }
  center          { text-align: center }
  :link, :visited { text-decoration: underline }
  :focus          { outline: thin dotted invert }

  /* Begin bidirectionality settings (do not change) */
  BDO[DIR="ltr"]  { direction: ltr; unicode-bidi: bidi-override }
  BDO[DIR="rtl"]  { direction: rtl; unicode-bidi: bidi-override }

  *[DIR="ltr"]    { direction: ltr; unicode-bidi: embed }
  *[DIR="rtl"]    { direction: rtl; unicode-bidi: embed }

  @media print {
    h1            { page-break-before: always }
    h1, h2, h3,
    h4, h5, h6    { page-break-after: avoid }
    ul, ol, dl    { page-break-before: avoid }
  }
  CSS
end

module Nokogiri::XML
  class Node
    # I'm not sure how browsers do this efficiently, but it's probably not by doing that
    def style(cssdoc)
      retval = CSSPool::CSS::Style.new
      
      # First refer to the cssdoc stylesheet
      cssdoc.rule_sets.each do |rs|
        for selector in rs.selectors
          # FIXME: Nokogiri doesn't support many of the CSS pseudo-selectors,
          # it's planned for 2.0 but for now we'll have to ignore those rules
          selector_s = selector.to_s
          
          if selector_s.include? ':'
            next
          end
          
          if self.matches? selector.to_s
            retval.add_declarations! rs.declarations
            break
          end
        end
      end
      
      # Then append the inline style if any
      if self['style']
        inline_decls = CSSPool::CSS::InlineParser.new.parse(self['style'])
        retval.add_declarations! inline_decls
      end
      
      # Look for inherited properties among its parents
      n = self
      while (n = n.parent) and n != document.root
        retval << n.style(cssdoc)
      end
      
      retval
    end
  end

  class Document
    # Concatenate the document stylesheets, then parse the result with CSSPool
    def stylesheet(args=Hash.new)
      openuri = args[:openuri] || File.open
      
      sheet, head = CSSPool::CSS::DEFAULT_STYLESHEET, xpath("/xmlns:html/xmlns:head")
      head.xpath(".//xmlns:style | .//xmlns:link[@rel='stylesheet']").each do |node|
        if node.name == 'style'
          sheet << node.content << "\n"
        else
          sheet << openuri.(node['href']).force_encoding('UTF-8') << "\n"
        end
      end
      
      CSSPool::SAC::Parser.new.parse(sheet)
    end
  end
end

# TODO: separate the list of annotations from the rendering so they can be sorted by date
# whenever we want to merge all the annotations for every book together
# (make it an hash table with dates as keys?)

class ADEAnnotation
  def unpackpoint(point)
    filename, node_s, byte_s = /([^#]+)#point\(([0-9\/]*)(:[0-9]+)?\)/.match(point).captures

    node_i = node_s.split('/').map { |x| x.to_i } [2..-1]

    if !byte_s
      byte = 0
    else
      byte = byte_s[1..-1].to_i
    end

    [filename, node_i, byte]
  end

  def node_at(doc, node_i)
    node = doc.root
    node_i.each do |i|
      node = node.children[i-1]

      if node == nil
        puts "Node not found!"
      end
    end

    return node
  end
  
  def wraptext(inode, text=nil)
    if text == nil
      text = inode.content
    end
    
    if not /[^\s]/ =~ text
      return
    end
    
    # Look for the first parent block
    iblock, is_block = inode, true
    while iblock.parent
      if iblock.style(@stylesheet)['display'] != 'inline'
        break
      end
      iblock, is_block = iblock.parent, false
    end
    
    style, style_s, pre = inode.style(@stylesheet), '', ''
    
    [ 'color', 'font-style', 'font-size', 'font-weight', 'font-variant', 
      'text-decoration', 'text-transform' ].each do |property|
      if style[property] != CSSPool::CSS::Property::DEFAULTS[property].initval.to_s
        style_s += "#{pre}#{property}:#{style[property]};"
        pre = ' '
      end
    end
    
    if is_block
      [ 'text-align', 'white-space' ].each do |property|
        if style[property] != CSSPool::CSS::Property::DEFAULTS[property].initval.to_s
          style_s += "#{pre}#{property}:#{style[property]};"
          pre = ' '
        end
      end
    end
    
    attributes = (style_s != "") ? { :style => style_s } : Hash.new
    
    # Check whether we're in the same block or a new one
    if is_block
      # the input node is a new block itself
      # (which basically never happens since text nodes only)
      @xhtml.p text, attributes {
        @previblock, @lastblock = inode, @xhtml.parent
      }
      return
    end
    
    if @previblock != iblock
      # the input block isn't the same anymore, create a new paragraph
      @xhtml.p {
        @previblock, @lastblock = iblock, @xhtml.parent
      }
    end
    
    Nokogiri::XML::Builder.with(@lastblock) do |b|
      if !attributes.empty?
        b.span text, attributes
      else
        b.text text
      end
    end
  end

  def extract(annotfn, epubfn)
    builder = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xhtml|
      @xhtml = xhtml
      
      xhtml.doc.create_internal_subset(
        'html',
        "-//W3C//DTD XHTML 1.1//EN",
        "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"
      )

      annotdoc, xdoc = nil, nil
      
      Zip::Archive.open(epubfn) do |ar|
        File.open(annotfn) do |f|
          annotdoc = Nokogiri::XML(f)
        end
        
        title = annotdoc.at_xpath("//xmlns:publication//dc:title").content

        xhtml.html('xmlns' => 'http://www.w3.org/1999/xhtml') {
          xhtml.head {
            xhtml.meta(:'http-equiv' => "content-type",
                      :content => "application/xhtml+xml; charset=UTF-8")
            xhtml.style <<-FIN
        div#wrapper { margin:0 auto; background-color:#d8d880; }
        div.Annotation { margin:10px 0; border:thin dotted #080808; background-color:#f2f2ff; max-width:750px; }
        div.AnnotationTitle { margin-left:2px; }
        span.AnnotTitle { font-weight:bold; }
        span.AnnotDate { font-size:90%; color:sienna; }
        div.AnnotationBody { margin-left:8px; margin-top:3px; }
              FIN
          }

          xhtml.body {
            annotdoc.xpath("//xmlns:annotation").each do |annot|
              @previblock, @lastblock = nil, nil
                     
              xhtml.div(:class => "Annotation") {
                xhtml.div(:class => "AnnotationTitle") {
                  xhtml.span title, :class => "AnnotTitle"
                  date = DateTime.iso8601(annot.at_xpath(".//dc:date").content)
                  xhtml.span date.strftime("%Y-%m-%d %H:%M:%S"), :class => "AnnotDate"
                }

                xhtml.div(:class => "AnnotationBody") {                                                      
                  fragment = annot.at_xpath(".//xmlns:target//xmlns:fragment")

                  startfn, startnode_i, startbyte = unpackpoint(fragment["start"])
                  endfn, endnode_i, endbyte = unpackpoint(fragment["end"])
                                                      
                  startdir = Pathname.new(startfn).parent

                  if startfn != endfn
                    puts "Annotation spans multiple files, not implemented!"
                  end

                  ar.fopen(startfn) do |f|
                    xdoc = Nokogiri::XML(f)
                  end
                                                      
                  @stylesheet = xdoc.stylesheet(:openuri => lambda {|filename|
                          abspath = startdir + Pathname.new(filename)
                          ar.fopen(abspath.to_s) do |f| f.read end
                        })

                  startnode = node_at(xdoc, startnode_i)
                  endnode = node_at(xdoc, endnode_i)

                  if startnode == endnode
                    wraptext startnode, startnode.content.byteslice(startbyte..endbyte)
                  else
                    wraptext startnode, startnode.content.byteslice(startbyte..-1)

                    node_i, node = startnode_i, nil
                    until node == endnode
                      if node != nil
                        wraptext node
                      end
                            
                      # Look for the next text node (but is it always a text node?)
                      begin
                        # first climb back to the first parent which can be incremented
                        while node_i[-1] + 1 > node_at(xdoc, node_i[0..-2]).children.size
                          node_i.delete_at(-1)
                        end
                                                
                        if node_i.empty?
                          puts "EOF reached, something went wrong."
                        end
                        
                        node_i[-1] += 1
                        
                        # then go down until we reach a childless node
                        while !node_at(xdoc, node_i).children.empty?
                          node_i << 1
                        end
                                                
                        node = node_at(xdoc, node_i)
                      end until node.text?
                    end 

                    wraptext endnode, endnode.content.byteslice(0..endbyte)
                  end
                }
              }
            end
          }
        }
      end
    end

    return builder
  end
end

puts ADEAnnotation.new.extract(ARGV[0], ARGV[1]).to_xml
