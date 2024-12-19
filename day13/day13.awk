#!/usr/bin/awk -f

BEGIN {
    OFMT="%f"
}

{
    yNumIndex = index($0,"Y")+2
}

/^Button A/{
    aX = substr($0, 13, index($0,",")-13)
    aY = substr($0, yNumIndex)
    next;
}

/^Button B/{
    bX = substr($0, 13, index($0,",")-13)
    bY = substr($0, yNumIndex)
    next;
}

/^Prize/{
    pX = substr($0, 10, index($0,",")-10)
    pY = substr($0, yNumIndex)
    totalCostA += cramersCost(aX, aY, bX, bY, pX, pY)
    partBOffset = 10000000000000
    totalCostB += cramersCost(aX, aY, bX, bY, pX+partBOffset, pY+partBOffset)
}

END {
    print totalCostA
    print totalCostB
}

function calculateMinCost(aX, aY, bX, bY, pX, pY) {
    minCost = 400
    isPossible = 0
    for(i=0; i<100; i++) {
        for(j=0; j<100; j++) {
            if((aX*i + bX*j == pX) && (aY*i + bY*j == pY)) {
                isPossible = 1
                cost = 3*i + j
                if (cost < minCost) {
                    minCost = cost
                }
            }
        }
    }
    if (isPossible) {
        return minCost
    }
}

function cramersCost(aX, aY, bX, bY, pX, pY) {
    determinant = aX*bY - aY*bX
    a = (pX*bY - pY*bX) / determinant
    b = (pY*aX - pX*aY) / determinant
    if((aX*a + bX*b == pX) && (aY*a + bY*b == pY) && (a == int(a)) && (b == int(b))) {
        return 3*a + b
    }
    return 0
}

