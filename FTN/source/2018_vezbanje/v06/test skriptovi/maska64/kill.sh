#!/bin/bash
# skript za ubijanje procesa ako se nije završio na vreme
# $1 - PID
# $2 - fajl u koji se upisuje izveštaj
# $3 - vreme koje se čeka (sekunde)
# $4 - tekst koji se upisuje u fajl u slučaju da je proces ubijen

vreme=0 #proteklo vreme
korak=1 #korak za koji se uvećava vreme
size=0  #veličina izlaznog fajla (outterm.txt)

# čekanje na zavrsetak posla
while [ $vreme -le $3 ]; do
    #provera da li je izlaz programa prevelik
    if [ -f outterm.txt ]; then
        size=$(du -k outterm.txt | cut -f1)
        if [ "$size" == "" ]; then
            size=0
        fi
        if [ $size -gt 10 ]; then   #ograničeno na 10k
            break
        fi
    fi
    #provera da li se proces završio
    if [ $(ps -p $1 | grep -c $1) = 0 ]; then
        exit
    #čekaj sledeću iteraciju
    else
        sleep $korak
        vreme=$((vreme+korak))
    fi
done

#ubijanje procesa, ako se nije sam završio
kill -9 $1 2>/dev/null 1>/dev/null

#ako je proces ubijen, upiši u izveštaj
if [ $? -eq 0 ]
then
    echo "$4" >$2
fi

