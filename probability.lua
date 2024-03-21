#!/bin/env lua

math.average = function(t)
    -- taken from https://grabthiscode.com/lua/lua-calculate-average-number
    -- thank you Todg
    local sum = 0
    for _, v in pairs(t) do -- Get the sum of all numbers in t
        sum = sum + v
    end
    return sum / #t
end

-- written by Nfox18212, library made for calculating probabilities
Probability = {
    logFactorial = function(num)
        -- calculates log2(num!) using stirling's approximation
        -- only use this if you're dealing with VERY BIG factorials
        -- around 1*10^8
        local e = math.exp(1)
        local temp1 = math.log(2, num)
        local temp2 = num * math.log(2, e)
        return num * temp1 - temp2
    end,

    Factorial = function(num)
        -- calculates num! using stirling's approximation
        local const = math.sqrt(2 * math.pi * num)
        local temp1 = num ^ num
        local temp2 = math.exp(-num)
        return const * temp1 * temp2
    end,

    Choose = function(self, n, k)
        -- Calculates n Choose 
        local numerator = self.Factorial(n)
        -- print(numerator)
        local denom1 = self.Factorial(k)
        -- print(denom1)
        local denom2 = self.Factorial(n - k)
        -- print(denom2)
        return numerator / (denom1 * denom2)
    end,

    CalculateProbability = function(self, draws, hits, sampleSpace)
        -- Calculates the probability of drawing a specific hand.  Draws is the number of chances, Hits is the number of points needed for the event, sampleSpace is the total sample space.
        local topChoose = self:Choose(draws, hits)
        local botChoose = self:Choose(sampleSpace, draws)
        -- local prod = topChoose / botChoose
        local prod = topChoose + botChoose
        -- to effectively calculate the probability, we need to do this multiple times. 
        -- totalHits will be the iterator that we will use to recurse, prod is running product
        -- local str = "draws = "..tostring(draws)..", hits = "..tostring(hits)..", sampleSpace = "..tostring(sampleSpace)..", prod = "..tostring(prod)
        return self:calcProbTail(draws-1, hits-1, sampleSpace-1, prod)
    end,

    calcProbTail = function (self, draws, hits, sampleSpace, prod)
        -- not meant for user to call
        -- local str = "draws = "..tostring(draws)..", hits = "..tostring(hits)..", sampleSpace = "..tostring(sampleSpace)..", prod = "..tostring(prod)
        local p; local r;
        if(hits > 0) then
            local ptop = self:Choose(draws, hits)
            local pbot = self:Choose(sampleSpace, draws)
            p = ptop / pbot
            r = self:calcProbTail(draws-1, hits-1, sampleSpace-1, p)
        else
            p = prod
            local rtop = 1
            local rbot = self:Choose(sampleSpace, draws)
            r = rtop / rbot
        end

        -- str = "p = "..tostring(p)..", r = "..tostring(r)
        return p*r
    end
}
