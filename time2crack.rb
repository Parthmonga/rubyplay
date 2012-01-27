#!/usr/bin/env ruby


pass_len = 8

lc = Array.new

for i in 97..122 do
  lc << i.chr
end

for i in 65..90 do
  lc << i.chr
end

for i in 48..57 do
  lc << i.chr
end

for i in 0..lc.size-1
  for j in 0..lc.size-1
    for k in 0..lc.size-1
      for l in 0..lc.size-1
        for m in 0..lc.size-1
          for n in 0..lc.size-1
            for o in 0..lc.size-1
              for p in 0..lc.size-1
                lc[i] + lc[j] + lc[k] + lc[l] + lc[m] + lc[n] + lc[o] + lc[p] 
              end
            end
          end
        end
      end
    end
  end    
end
