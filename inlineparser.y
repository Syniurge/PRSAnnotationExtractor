class CSSPool::CSS::InlineParserBase

token CHARSET_SYM IMPORT_SYM STRING SEMI IDENT S COMMA LBRACE RBRACE STAR HASH
token LSQUARE RSQUARE EQUAL INCLUDES DASHMATCH RPAREN FUNCTION GREATER PLUS
token SLASH NUMBER MINUS LENGTH PERCENTAGE EMS EXS ANGLE TIME FREQ URI
token IMPORTANT_SYM MEDIA_SYM

rule
  inlineruleset
    : {}
    | '' | S
    | declarations
    ;

  declarations
    : declaration SEMI declarations
    | declaration SEMI
    | declaration
    ;
  declaration
    : property ':' expr prio
      { @handler.property val.first, val[2], val[3] }
    | property ':' S expr prio
      { @handler.property val.first, val[3], val[4] }
    | property S ':' expr prio
      { @handler.property val.first, val[3], val[4] }
    | property S ':' S expr prio
      { @handler.property val.first, val[4], val[5] }
    ;
  prio
    : IMPORTANT_SYM { result = true }
    |               { result = false }
    ;
  property
    : IDENT { result = interpret_identifier val[0] }
    | STAR IDENT { result = interpret_identifier val.join }
    ;
  operator
    : COMMA
    | SLASH
    | EQUAL
    ;
  expr
    : term operator expr {
        result = [val.first, val.last].flatten
        val.last.first.operator = val[1]
      }
    | term expr { result = val.flatten }
    | term      { result = val }
    ;
  term
    : ident
    | numeric
    | string
    | uri
    | hexcolor
    | function
    ;
  function
    : function S { result = val.first }
    | FUNCTION expr RPAREN {
        name = interpret_identifier val.first.sub(/\($/, '')
        if name == 'rgb'
          result = Terms::Rgb.new(*val[1])
        else
          result = Terms::Function.new name, val[1]
        end
      }
    ;
  hexcolor
    : hexcolor S { result = val.first }
    | HASH { result = Terms::Hash.new val.first.sub(/^#/, '') }
    ;
  uri
    : uri S { result = val.first }
    | URI { result = Terms::URI.new interpret_uri val.first }
  string
    : string S { result = val.first }
    | STRING { result = Terms::String.new interpret_string val.first }
    ;
  numeric
    : unary_operator numeric {
        result = val[1]
        val[1].unary_operator = val.first
      }
    | NUMBER {
        result = Terms::Number.new numeric val.first
      }
    | PERCENTAGE {
        result = Terms::Number.new numeric(val.first), nil, '%'
      }
    | LENGTH {
        unit    = val.first.gsub(/[\s\d.]/, '')
        result = Terms::Number.new numeric(val.first), nil, unit
      }
    | EMS {
        result = Terms::Number.new numeric(val.first), nil, 'em'
      }
    | EXS {
        result = Terms::Number.new numeric(val.first), nil, 'ex'
      }
    | ANGLE {
        unit    = val.first.gsub(/[\s\d.]/, '')
        result = Terms::Number.new numeric(val.first), nil, unit
      }
    | TIME {
        unit    = val.first.gsub(/[\s\d.]/, '')
        result = Terms::Number.new numeric(val.first), nil, unit
      }
    | FREQ {
        unit    = val.first.gsub(/[\s\d.]/, '')
        result = Terms::Number.new numeric(val.first), nil, unit
      }
    ;
  unary_operator
    : MINUS { result = :minus }
    | PLUS  { result = :plus }
    ;
  ident
    : ident S { result = val.first }
    | IDENT { result = Terms::Ident.new interpret_identifier val.first }
    ;

---- inner

def numeric thing
  thing = thing.gsub(/[^\d.]/, '')
  Integer(thing) rescue Float(thing)
end

def interpret_identifier s
  interpret_escapes s
end

def interpret_uri s
  interpret_escapes s.match(/^url\((.*)\)$/mu)[1].strip.match(/^(['"]?)((?:\\.|.)*)\1$/mu)[2]
end

def interpret_string s
  interpret_escapes s.match(/^(['"])((?:\\.|.)*)\1$/mu)[2]
end

def interpret_escapes s
  token_exp = /\\([0-9a-fA-F]{1,6}(?:\r\n|\s)?)|\\(.)|(.)/mu
  characters = s.scan(token_exp).map do |u_escape, i_escape, ident|
    if u_escape
      code = u_escape.chomp.to_i 16
      code = 0xFFFD if code > 0x10FFFF
      [code].pack('U')
    elsif i_escape
      if i_escape == "\n"
        ''
      else
        i_escape
      end
    else
      ident
    end
  end.join ''
end
