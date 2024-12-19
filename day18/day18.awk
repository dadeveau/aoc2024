#!/usr/bin/awk -f

BEGIN {
    FS = ","
    MAX_INDEX = 70
}

{
    corruptions[$1, $2] = 1
}

# Starting with 1024, save the corruption state at every line
NR >= 1024 {
    for (coord in corruptions) {
        corruptionState[NR,coord] = 1
    }
    bytes[NR] = $0
}

NR == 1024 {
    traverse(0,0,0,NR)
    #print "18a: " min_steps[MAX_INDEX, MAX_INDEX]
}

END {
    print "18b: " bytes[binaryTraverse(1025, NR)]
}

function traverse(x, y, steps, row) {
    if (x < 0 || x > MAX_INDEX || y < 0 || y > MAX_INDEX || corruptionState[row, x, y]) {
        return
    }
    if (min_steps[x, y] != "" && steps >= min_steps[x, y]) {
        return
    }
    min_steps[x, y] = steps
    if (x == MAX_INDEX && y == MAX_INDEX) {
        return
    }
    traverse(x + 1, y, steps + 1, row)
    traverse(x - 1, y, steps + 1, row)
    traverse(x, y + 1, steps + 1, row)
    traverse(x, y - 1, steps + 1, row)
}

function binaryTraverse(lo, hi) {
    while (lo < hi) {
        delete min_steps
        mid = lo + int((hi - lo) / 2)
        traverse(0,0,0,mid)
        if ((MAX_INDEX, MAX_INDEX) in min_steps) {
            lo = mid + 1  
        } else {
            hi = mid
        }
    }
    return lo
}