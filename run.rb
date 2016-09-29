# Example how to write own weird proc function inside own enumerable method

require 'concurrent'
require 'open-uri'

module Enumerable
  def own_map(&block)
    # so now, our own_map method act like an array on which we use it
    #
    # self is not necessary here, it can looks like: futures = self.map { ... }
    # firstly we are mapping rows here, and by using block.call(each_row)
    # we are calling provided proc object so executed was everything from it.
    # But remember it's not another mapping there, we just execute code on that one row in own_map context

    futures = map { |each_row|  Concurrent::Future.execute{ block.call(each_row) } }

    #here we are waiting for data from Concurrent job
    futures.map { |future|  future.value }
  end
end


array = [
    "http://google.pl",
    "https://github.com",
    "http://onet.pl",
    "http://wp.pl"
]
# In context of that proc functon we are working on untouched array
puts array.own_map { |url| open(url).length }