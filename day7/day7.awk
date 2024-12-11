

{
    split($0,row,":")
    rows[row[1]] = row[2]
 }

 END {
    for (i in rows) {
        target = i
        split(rows[i], numbers," ")
        print target
    }
    #print sum
 }