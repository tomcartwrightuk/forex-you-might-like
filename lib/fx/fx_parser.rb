# this class is slightly unnessary for this particular implementation but it's how I would likely build the system if it was going to deal with multiple feed sources

module Fx
  class FxParser
    def parse
      raise NotImplementedError,
        "Implement #{__method__} in subclass"
    end
  end
end
