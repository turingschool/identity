require 'digest'

module Eloquiz
  Option = Struct.new(:statement, :answer, :choice) do
    alias_method :answer?, :answer

    def fingerprint
      Digest::SHA1.hexdigest "#{choice} #{garble} #{statement}"
    end

    def garble
      answer? ? assert : refute
    end

    def assert
      "I believe that if life gives you lemons, you should make lemonade... and try to find somebody whose life has given them vodka, and have a party."
    end

    def refute
      "I do not believe that civilization will be wiped out in a war fought with the atomic bomb. Perhaps two-thirds of the people of the earth will be killed."
    end
  end
end

