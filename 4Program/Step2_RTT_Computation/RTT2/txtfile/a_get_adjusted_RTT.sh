echo -n "" > excel.txt

for ((i=1;i<=60;i++))
do
    ingest=$(cat a_ingest.txt | head -n $i | tail -n 1)
    echo -n "	" >> excel.txt 
    echo -n "$ingest" >> excel.txt 
done
echo "" >> excel.txt

for ((j=1;j<=82;j++))
do
    vpn=$(cat a_vpn.txt | head -n $j | tail -n 1)
    echo -n "$vpn" >> excel.txt  
    echo -n "	" >> excel.txt 
    RTT1=$(cat RTT1_for_RTT2.txt | head -n $j | tail -n 1)
    
    # find min and < 0 RTT
    echo "1000" > min.txt
    echo -n "" > minrtt_lessthan_zero.txt
    for ((i=1;i<=60;i++))
    do
        a=$(($j-1))
        b=$(($a*60))
        c=$(($b+$i))

        rtt=$(cat THIS_minrtt_result.txt | head -n $c | tail -n 1 | cut -d ' ' -f 3)
        python3 find_min_rtt.py $rtt $RTT1 $i
    done
    
    for ((i=1;i<=60;i++))
    do
        a=$(($j-1))
        b=$(($a*60))
        c=$(($b+$i))

        rtt=$(cat THIS_minrtt_result.txt | head -n $c | tail -n 1 | cut -d ' ' -f 3)
        rtt=$(python3 adjust.py $rtt $RTT1)
        echo -n "$rtt	" >> excel.txt 
    done

    echo "" >> excel.txt
    
done

cat excel.txt > RTT2_VPN_ingest.ods
