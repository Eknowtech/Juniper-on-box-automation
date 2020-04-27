#!/bin/csh

cli -c "show interfaces extensive" >extensive.txt

cat extensive.txt | egrep -A40 "Physical interface: ge-|Physical interface: xe-|Physical interface: et-" >physical.txt

cat physical.txt | egrep ': ge-|: xe-|: et-'| awk '{print $8}' >a1.txt
cat physical.txt | egrep ': ge-|: xe-|: et-'| awk '{print $3}' >a2.txt
cat physical.txt | egrep 'BPDU' | awk -F'MTU: ' '{print $2}'| awk '{print $1}' >a3.txt
cat physical.txt | egrep 'BPDU' | awk -F'Speed: ' '{print $2}' | awk '{print $1 $2}' | awk -F',' '{print $1}' >a4.txt
cat physical.txt | egrep 'Framing' | awk '{print $1,$2,$3,$4}' >a5.txt
cat physical.txt | egrep 'transitions' | awk '{print $4,$5,$6,$7}' >a6.txt
cat physical.txt | egrep 'Current' | awk '{print $3}' >a7.txt
cat physical.txt | awk '/^--/ { print desc; desc = ""; } /^  Description/ { gsub("Description: ",""); desc=$1 } END { print desc; }' >a8.txt


t1="State"
t2="Interfaces"
t3="MTU"
t4="Speed"
t5="Input_Error_Count"
t6="Output_Error_Count"
t7="Hardware_Address"
t8="Description"

arr1=$(echo $t1 |cat - a1.txt | sed 's/,//g')
arr2=$(echo $t2 |cat - a2.txt | sed 's/,//g')
arr3=$(echo $t3 |cat - a3.txt | sed 's/,//g')
arr4=$(echo $t4 |cat - a4.txt | sed 's/,//g'| sed 's/1000[mM]bps/1Gbps/g')
arr5=$(echo $t5 |cat - a5.txt | sed 's/,//g')
arr6=$(echo $t6 |cat - a6.txt | sed 's/,//g')
arr7=$(echo $t7 |cat - a7.txt | sed 's/,//g')
arr8=$(echo $t8 |cat - a8.txt | sed 's/,//g')

lineTotal=$(echo -n "$arr1" | grep -c '^')
line=1

while [ $line -le $lineTotal ]

do
tmp1=$(echo "$arr2" | sed -n "$line"P)
tmp2=$(echo "$arr1" | sed -n "$line"P)
tmp3=$(echo "$arr3" | sed -n "$line"P)
tmp4=$(echo "$arr4" | sed -n "$line"P)
tmp5=$(echo "$arr5" | sed -n "$line"P)
tmp6=$(echo "$arr6" | sed -n "$line"P)
tmp7=$(echo "$arr7" | sed -n "$line"P)
tmp8=$(echo "$arr8" | sed -n "$line"P)

echo -e "$tmp1\t$tmp2\t$tmp7\t$tmp5\t$tmp6\t$tmp3\t$tmp4\t$tmp8"

line=`expr $line + 1`
done

rm a1.txt a2.txt a3.txt a4.txt a5.txt a6.txt a7.txt a8.txt extensive.txt physical.txt
