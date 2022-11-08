#! /bin/bash

commafy ()
{
	printf %s "${1%%[0-9]*}"
	printf '%s' "${1##*[!0-9]}" |
	rev |
	sed -E 's/[0-9]{3}/&,/g; s/,$//' |
	rev
}

now=$(date --utc +"%Y%m")
sed 1d $1 | while IFS="," read -r type_code type_name bank card_no holder_name cvv issue_d expiry_d billing_d pin limit ; do
	dir=$(printf "./cards/$type_name/$bank/" | tr -c [:graph:] "_")
	mkdir -p "$dir"

	exp=$(awk -F'/' '{printf("%4d%2d",$2,$1)}' <<< $expiry_d)
	if [[ "$now" > "$exp" ]]
	then
		fname="$dir$card_no.expired"
	else
		fname="$dir$card_no.active"
	fi

	formatted_limit=$(commafy "${limit//[$'\t\r\n']}")

	echo "Card Type Code: $type_code" > "$fname"
	echo "Card Type Full Name: $type_name" >> "$fname"
	echo "Issuing Bank: $bank" >> "$fname"
	echo "Card Number: $card_no" >> "$fname"
	echo "Card Holder's Name: $holder_name" >> "$fname"
	echo "CVV/CVV2: $cvv" >> "$fname"
	echo "Issue Date: $issue_d" >> "$fname"
	echo "Expiry Date: $expiry_d" >> "$fname"
	echo "Billing Date: $billing_d" >> "$fname"
	echo "Card PIN: $pin" >> "$fname"
	echo "Credit Limit: \$$formatted_limit USD" >> "$fname"
done
