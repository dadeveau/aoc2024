#!/usr/bin/awk -f

NR == 1 {
    gsub(/ /, "", $0)
    split($0,tempTowels,",")
    for (t in tempTowels) {
        towels[tempTowels[t]] = 1
    }
    next
}

/^$/ {
    next
}

{
    ways =  canForm($0)
    if (ways > 0) {
        sumA += 1
    }
    sumB += ways
}

END {
    print "19a: " sumA
    print "19b: " sumB
}

function canForm(design,    i, j) {
    len = length(design)
    delete dp
    dp[0] = 1

    for (i = 1; i <= len; i++) {
        for (pattern in towels) {
            pattern_len = length(pattern)
            if (i >= pattern_len) {
                subs = substr(design, i - pattern_len + 1, pattern_len)
                if (subs == pattern) {
                    dp[i] += dp[i - pattern_len]
                }
            }
        }
    }
    return dp[len]
}