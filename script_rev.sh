#! /bin/bash

echo "Card Type Code,Card Type Full Name,Issuing Bank,Card Number,Card Holder's Name,CVV/CVV2,Issue Date,Expiry Date,Billing Date,Card PIN,Credit Limit" >> reconstructed.csv

for dir in ~/cards/*; do
	for sdir in "$dir"/*; do
		for f in "$sdir"/*; do
			values=()
			while IFS=":" read -r key value; do
				values+=("$value")
			done < $f
			echo "${values[0]},${values[1]},${values[2]},${values[3]},${values[4]},${values[5]},${values[6]},${values[7]},${values[8]},${values[9]}, ${values[10]//[!0-9]/}" >> reconstructed.csv
		done
	done
done
