#! /usr/bin/ruby

if not defined? $loaded_miku
  $loaded_miku = true

  Dir.chdir(File.dirname(__FILE__)){
    require 'array'
    require 'hash'
    require 'symbol'
    require 'symboltable'
    require 'nil'
    require 'parser'
  }

  def miku(node, scope=MIKU::SymbolTable.new)
    if(node.is_a? MIKU::Node) then
      node.miku_eval(scope)
    else
      node end end

  def miku_stream(stream, scope)
    begin
      while(not stream.eof?) do
        miku(MIKU.parse(stream), scope) end
    rescue MIKU::MikuException => e
      warn e end end

  if(__FILE__ == $0) then
    scope = MIKU::SymbolTable.new.run_init_script
    if ARGV.last
      miku_stream(open(ARGV.last, 'r'), scope)
    else
      require 'readline'
      while buf = Readline.readline('>>> ', true)
        begin
          puts MIKU.unparse(miku(MIKU.parse(buf), scope))
        rescue MIKU::MikuException => e
          puts e.to_s end end end end end
