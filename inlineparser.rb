#
# DO NOT MODIFY!!!!
# This file is automatically generated by Racc 1.4.9
# from Racc grammer file "".
#

require 'racc/parser.rb'
module CSSPool
  module CSS
    class InlineParserBase < Racc::Parser

module_eval(<<'...end inlineparser.y/module_eval...', 'inlineparser.y', 125)

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
...end inlineparser.y/module_eval...
##### State transition tables begin ###

racc_action_table = [
     7,     3,    12,     7,    51,     8,    50,    43,     8,    52,
    53,    54,    41,    28,    14,    40,    58,    13,    43,    10,
    61,    26,    43,     9,    43,   nil,   nil,   nil,    25,     2,
    39,    11,    30,    38,    32,    31,    33,    34,    35,    36,
    37,    27,    28,   nil,    40,   nil,   nil,   nil,   nil,   nil,
    26,   nil,   nil,   nil,   nil,   nil,   nil,    25,   nil,    39,
   nil,    30,    38,    32,    31,    33,    34,    35,    36,    37,
    27,    28,   nil,    40,   nil,   nil,   nil,   nil,   nil,    26,
   nil,   nil,   nil,   nil,   nil,   nil,    25,   nil,    39,   nil,
    30,    38,    32,    31,    33,    34,    35,    36,    37,    27,
    28,   nil,    40,   nil,   nil,   nil,   nil,   nil,    26,   nil,
   nil,   nil,   nil,   nil,   nil,    25,   nil,    39,   nil,    30,
    38,    32,    31,    33,    34,    35,    36,    37,    27,    28,
   nil,    40,   nil,    45,   nil,   nil,   nil,    26,   nil,   nil,
    47,   nil,   nil,   nil,    25,   nil,    39,    46,    30,    38,
    32,    31,    33,    34,    35,    36,    37,    27,    28,   nil,
    40,    17,   nil,   nil,   nil,   nil,    26,   nil,   nil,   nil,
   nil,   nil,   nil,    25,   nil,    39,   nil,    30,    38,    32,
    31,    33,    34,    35,    36,    37,    27,    28,   nil,    40,
   nil,   nil,   nil,   nil,   nil,    26,   nil,   nil,   nil,   nil,
   nil,   nil,    25,   nil,    39,   nil,    30,    38,    32,    31,
    33,    34,    35,    36,    37,    27,    39,   nil,    30,    38,
    32,    31,    33,    34,    35,    36,    37 ]

racc_action_check = [
     0,     0,     6,    10,    21,     0,    19,    16,    10,    22,
    23,    24,    12,    41,     9,    41,    41,     8,    44,     5,
    55,    41,    57,     1,    63,   nil,   nil,   nil,    41,     0,
    41,     6,    41,    41,    41,    41,    41,    41,    41,    41,
    41,    41,    58,   nil,    58,   nil,   nil,   nil,   nil,   nil,
    58,   nil,   nil,   nil,   nil,   nil,   nil,    58,   nil,    58,
   nil,    58,    58,    58,    58,    58,    58,    58,    58,    58,
    58,    48,   nil,    48,   nil,   nil,   nil,   nil,   nil,    48,
   nil,   nil,   nil,   nil,   nil,   nil,    48,   nil,    48,   nil,
    48,    48,    48,    48,    48,    48,    48,    48,    48,    48,
    25,   nil,    25,   nil,   nil,   nil,   nil,   nil,    25,   nil,
   nil,   nil,   nil,   nil,   nil,    25,   nil,    25,   nil,    25,
    25,    25,    25,    25,    25,    25,    25,    25,    25,    18,
   nil,    18,   nil,    18,   nil,   nil,   nil,    18,   nil,   nil,
    18,   nil,   nil,   nil,    18,   nil,    18,    18,    18,    18,
    18,    18,    18,    18,    18,    18,    18,    18,    11,   nil,
    11,    11,   nil,   nil,   nil,   nil,    11,   nil,   nil,   nil,
   nil,   nil,   nil,    11,   nil,    11,   nil,    11,    11,    11,
    11,    11,    11,    11,    11,    11,    11,    17,   nil,    17,
   nil,   nil,   nil,   nil,   nil,    17,   nil,   nil,   nil,   nil,
   nil,   nil,    17,   nil,    17,   nil,    17,    17,    17,    17,
    17,    17,    17,    17,    17,    17,    29,   nil,    29,    29,
    29,    29,    29,    29,    29,    29,    29 ]

racc_action_pointer = [
    -6,    23,   nil,   nil,   nil,    14,    -5,   nil,    11,    14,
    -3,   154,   -24,   nil,   nil,   nil,   -26,   183,   125,    -1,
   nil,    -3,     2,     3,     4,    96,   nil,   nil,   nil,   195,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,
   nil,     9,   nil,   nil,   -15,   nil,   nil,   nil,    67,   nil,
   nil,   nil,   nil,   nil,   nil,     2,   nil,   -11,    38,   nil,
   nil,   nil,   nil,    -9,   nil ]

racc_action_default = [
    -1,   -49,    -2,    -3,    -4,    -7,   -49,   -14,   -49,   -49,
    -6,   -49,   -49,   -15,    65,    -5,   -13,   -49,   -21,   -22,
   -23,   -24,   -25,   -26,   -27,   -49,   -31,   -33,   -35,   -49,
   -37,   -38,   -39,   -40,   -41,   -42,   -43,   -44,   -45,   -46,
   -48,   -49,    -8,   -12,   -13,   -16,   -17,   -18,   -49,   -20,
   -47,   -34,   -32,   -30,   -28,   -49,   -36,   -13,   -49,    -9,
   -19,   -29,   -10,   -13,   -11 ]

racc_goto_table = [
    42,    16,     4,     1,    48,    56,   nil,    44,    49,   nil,
   nil,   nil,    15,   nil,   nil,    55,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,    59,   nil,
   nil,    57,   nil,   nil,   nil,   nil,   nil,   nil,    60,   nil,
   nil,    62,   nil,   nil,   nil,   nil,   nil,    64,    63 ]

racc_goto_check = [
     6,     5,     2,     1,     7,    10,   nil,     5,     5,   nil,
   nil,   nil,     2,   nil,   nil,     5,   nil,   nil,   nil,   nil,
   nil,   nil,   nil,   nil,   nil,   nil,   nil,   nil,     6,   nil,
   nil,     5,   nil,   nil,   nil,   nil,   nil,   nil,     5,   nil,
   nil,     6,   nil,   nil,   nil,   nil,   nil,     6,     5 ]

racc_goto_pointer = [
   nil,     3,     2,   nil,   nil,   -10,   -16,   -14,   nil,   nil,
   -24,   nil,   nil,   nil,   nil,   nil ]

racc_goto_default = [
   nil,   nil,   nil,     5,     6,   nil,   nil,   nil,    18,    19,
    20,    21,    22,    23,    24,    29 ]

racc_reduce_table = [
  0, 0, :racc_error,
  0, 38, :_reduce_1,
  1, 38, :_reduce_none,
  1, 38, :_reduce_none,
  1, 38, :_reduce_4,
  3, 39, :_reduce_none,
  2, 39, :_reduce_none,
  1, 39, :_reduce_none,
  4, 40, :_reduce_8,
  5, 40, :_reduce_9,
  5, 40, :_reduce_10,
  6, 40, :_reduce_11,
  1, 43, :_reduce_12,
  0, 43, :_reduce_13,
  1, 41, :_reduce_14,
  2, 41, :_reduce_15,
  1, 44, :_reduce_none,
  1, 44, :_reduce_none,
  1, 44, :_reduce_none,
  3, 42, :_reduce_19,
  2, 42, :_reduce_20,
  1, 42, :_reduce_21,
  1, 45, :_reduce_none,
  1, 45, :_reduce_none,
  1, 45, :_reduce_none,
  1, 45, :_reduce_none,
  1, 45, :_reduce_none,
  1, 45, :_reduce_none,
  2, 51, :_reduce_28,
  3, 51, :_reduce_29,
  2, 50, :_reduce_30,
  1, 50, :_reduce_31,
  2, 49, :_reduce_32,
  1, 49, :_reduce_33,
  2, 48, :_reduce_34,
  1, 48, :_reduce_35,
  2, 47, :_reduce_36,
  1, 47, :_reduce_37,
  1, 47, :_reduce_38,
  1, 47, :_reduce_39,
  1, 47, :_reduce_40,
  1, 47, :_reduce_41,
  1, 47, :_reduce_42,
  1, 47, :_reduce_43,
  1, 47, :_reduce_44,
  1, 52, :_reduce_45,
  1, 52, :_reduce_46,
  2, 46, :_reduce_47,
  1, 46, :_reduce_48 ]

racc_reduce_n = 49

racc_shift_n = 65

racc_token_table = {
  false => 0,
  :error => 1,
  :CHARSET_SYM => 2,
  :IMPORT_SYM => 3,
  :STRING => 4,
  :SEMI => 5,
  :IDENT => 6,
  :S => 7,
  :COMMA => 8,
  :LBRACE => 9,
  :RBRACE => 10,
  :STAR => 11,
  :HASH => 12,
  :LSQUARE => 13,
  :RSQUARE => 14,
  :EQUAL => 15,
  :INCLUDES => 16,
  :DASHMATCH => 17,
  :RPAREN => 18,
  :FUNCTION => 19,
  :GREATER => 20,
  :PLUS => 21,
  :SLASH => 22,
  :NUMBER => 23,
  :MINUS => 24,
  :LENGTH => 25,
  :PERCENTAGE => 26,
  :EMS => 27,
  :EXS => 28,
  :ANGLE => 29,
  :TIME => 30,
  :FREQ => 31,
  :URI => 32,
  :IMPORTANT_SYM => 33,
  :MEDIA_SYM => 34,
  "" => 35,
  ":" => 36 }

racc_nt_base = 37

racc_use_result_var = true

Racc_arg = [
  racc_action_table,
  racc_action_check,
  racc_action_default,
  racc_action_pointer,
  racc_goto_table,
  racc_goto_check,
  racc_goto_default,
  racc_goto_pointer,
  racc_nt_base,
  racc_reduce_table,
  racc_token_table,
  racc_shift_n,
  racc_reduce_n,
  racc_use_result_var ]

Racc_token_to_s_table = [
  "$end",
  "error",
  "CHARSET_SYM",
  "IMPORT_SYM",
  "STRING",
  "SEMI",
  "IDENT",
  "S",
  "COMMA",
  "LBRACE",
  "RBRACE",
  "STAR",
  "HASH",
  "LSQUARE",
  "RSQUARE",
  "EQUAL",
  "INCLUDES",
  "DASHMATCH",
  "RPAREN",
  "FUNCTION",
  "GREATER",
  "PLUS",
  "SLASH",
  "NUMBER",
  "MINUS",
  "LENGTH",
  "PERCENTAGE",
  "EMS",
  "EXS",
  "ANGLE",
  "TIME",
  "FREQ",
  "URI",
  "IMPORTANT_SYM",
  "MEDIA_SYM",
  "\"\"",
  "\":\"",
  "$start",
  "inlineruleset",
  "declarations",
  "declaration",
  "property",
  "expr",
  "prio",
  "operator",
  "term",
  "ident",
  "numeric",
  "string",
  "uri",
  "hexcolor",
  "function",
  "unary_operator" ]

Racc_debug_parser = true

##### State transition tables end #####

# reduce 0 omitted

module_eval(<<'.,.,', 'inlineparser.y', 9)
  def _reduce_1(val, _values, result)
    
    result
  end
.,.,

# reduce 2 omitted

# reduce 3 omitted

module_eval(<<'.,.,', 'inlineparser.y', 11)
  def _reduce_4(val, _values, result)
     
    result
  end
.,.,

# reduce 5 omitted

# reduce 6 omitted

# reduce 7 omitted

module_eval(<<'.,.,', 'inlineparser.y', 21)
  def _reduce_8(val, _values, result)
     @handler.property val.first, val[2], val[3] 
    result
  end
.,.,

module_eval(<<'.,.,', 'inlineparser.y', 23)
  def _reduce_9(val, _values, result)
     @handler.property val.first, val[3], val[4] 
    result
  end
.,.,

module_eval(<<'.,.,', 'inlineparser.y', 25)
  def _reduce_10(val, _values, result)
     @handler.property val.first, val[3], val[4] 
    result
  end
.,.,

module_eval(<<'.,.,', 'inlineparser.y', 27)
  def _reduce_11(val, _values, result)
     @handler.property val.first, val[4], val[5] 
    result
  end
.,.,

module_eval(<<'.,.,', 'inlineparser.y', 30)
  def _reduce_12(val, _values, result)
     result = true 
    result
  end
.,.,

module_eval(<<'.,.,', 'inlineparser.y', 31)
  def _reduce_13(val, _values, result)
     result = false 
    result
  end
.,.,

module_eval(<<'.,.,', 'inlineparser.y', 34)
  def _reduce_14(val, _values, result)
     result = interpret_identifier val[0] 
    result
  end
.,.,

module_eval(<<'.,.,', 'inlineparser.y', 35)
  def _reduce_15(val, _values, result)
     result = interpret_identifier val.join 
    result
  end
.,.,

# reduce 16 omitted

# reduce 17 omitted

# reduce 18 omitted

module_eval(<<'.,.,', 'inlineparser.y', 44)
  def _reduce_19(val, _values, result)
            result = [val.first, val.last].flatten
        val.last.first.operator = val[1]
      
    result
  end
.,.,

module_eval(<<'.,.,', 'inlineparser.y', 47)
  def _reduce_20(val, _values, result)
     result = val.flatten 
    result
  end
.,.,

module_eval(<<'.,.,', 'inlineparser.y', 48)
  def _reduce_21(val, _values, result)
     result = val 
    result
  end
.,.,

# reduce 22 omitted

# reduce 23 omitted

# reduce 24 omitted

# reduce 25 omitted

# reduce 26 omitted

# reduce 27 omitted

module_eval(<<'.,.,', 'inlineparser.y', 59)
  def _reduce_28(val, _values, result)
     result = val.first 
    result
  end
.,.,

module_eval(<<'.,.,', 'inlineparser.y', 61)
  def _reduce_29(val, _values, result)
            name = interpret_identifier val.first.sub(/\($/, '')
        if name == 'rgb'
          result = Terms::Rgb.new(*val[1])
        else
          result = Terms::Function.new name, val[1]
        end
      
    result
  end
.,.,

module_eval(<<'.,.,', 'inlineparser.y', 70)
  def _reduce_30(val, _values, result)
     result = val.first 
    result
  end
.,.,

module_eval(<<'.,.,', 'inlineparser.y', 71)
  def _reduce_31(val, _values, result)
     result = Terms::Hash.new val.first.sub(/^#/, '') 
    result
  end
.,.,

module_eval(<<'.,.,', 'inlineparser.y', 74)
  def _reduce_32(val, _values, result)
     result = val.first 
    result
  end
.,.,

module_eval(<<'.,.,', 'inlineparser.y', 75)
  def _reduce_33(val, _values, result)
     result = Terms::URI.new interpret_uri val.first 
    result
  end
.,.,

module_eval(<<'.,.,', 'inlineparser.y', 77)
  def _reduce_34(val, _values, result)
     result = val.first 
    result
  end
.,.,

module_eval(<<'.,.,', 'inlineparser.y', 78)
  def _reduce_35(val, _values, result)
     result = Terms::String.new interpret_string val.first 
    result
  end
.,.,

module_eval(<<'.,.,', 'inlineparser.y', 82)
  def _reduce_36(val, _values, result)
            result = val[1]
        val[1].unary_operator = val.first
      
    result
  end
.,.,

module_eval(<<'.,.,', 'inlineparser.y', 86)
  def _reduce_37(val, _values, result)
            result = Terms::Number.new numeric val.first
      
    result
  end
.,.,

module_eval(<<'.,.,', 'inlineparser.y', 89)
  def _reduce_38(val, _values, result)
            result = Terms::Number.new numeric(val.first), nil, '%'
      
    result
  end
.,.,

module_eval(<<'.,.,', 'inlineparser.y', 92)
  def _reduce_39(val, _values, result)
            unit    = val.first.gsub(/[\s\d.]/, '')
        result = Terms::Number.new numeric(val.first), nil, unit
      
    result
  end
.,.,

module_eval(<<'.,.,', 'inlineparser.y', 96)
  def _reduce_40(val, _values, result)
            result = Terms::Number.new numeric(val.first), nil, 'em'
      
    result
  end
.,.,

module_eval(<<'.,.,', 'inlineparser.y', 99)
  def _reduce_41(val, _values, result)
            result = Terms::Number.new numeric(val.first), nil, 'ex'
      
    result
  end
.,.,

module_eval(<<'.,.,', 'inlineparser.y', 102)
  def _reduce_42(val, _values, result)
            unit    = val.first.gsub(/[\s\d.]/, '')
        result = Terms::Number.new numeric(val.first), nil, unit
      
    result
  end
.,.,

module_eval(<<'.,.,', 'inlineparser.y', 106)
  def _reduce_43(val, _values, result)
            unit    = val.first.gsub(/[\s\d.]/, '')
        result = Terms::Number.new numeric(val.first), nil, unit
      
    result
  end
.,.,

module_eval(<<'.,.,', 'inlineparser.y', 110)
  def _reduce_44(val, _values, result)
            unit    = val.first.gsub(/[\s\d.]/, '')
        result = Terms::Number.new numeric(val.first), nil, unit
      
    result
  end
.,.,

module_eval(<<'.,.,', 'inlineparser.y', 115)
  def _reduce_45(val, _values, result)
     result = :minus 
    result
  end
.,.,

module_eval(<<'.,.,', 'inlineparser.y', 116)
  def _reduce_46(val, _values, result)
     result = :plus 
    result
  end
.,.,

module_eval(<<'.,.,', 'inlineparser.y', 119)
  def _reduce_47(val, _values, result)
     result = val.first 
    result
  end
.,.,

module_eval(<<'.,.,', 'inlineparser.y', 120)
  def _reduce_48(val, _values, result)
     result = Terms::Ident.new interpret_identifier val.first 
    result
  end
.,.,

def _reduce_none(val, _values, result)
  val[0]
end

    end   # class InlineParserBase
    end   # module CSS
  end   # module CSSPool
