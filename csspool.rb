require_relative 'csspool/node'
require_relative 'csspool/selectors'
require_relative 'csspool/terms'
require_relative 'csspool/selector'
old = $-w
$-w = false
require_relative 'csspool/css/parser'
$-w = old
require_relative 'csspool/css/tokenizer'
require_relative 'csspool/sac'
require_relative 'csspool/css'
require_relative 'csspool/visitors'
require_relative 'csspool/collection'

module CSSPool
  VERSION = "3.0.2"

  def self.CSS doc
    CSSPool::CSS::Document.parse doc
  end
end
