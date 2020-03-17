echo "Import case..."
stardog-admin virtual import covid19kr case.sms.ttl case.csv 
echo "Import patient..."
stardog-admin virtual import covid19kr patient.sms.ttl patient.csv 
echo "Import route..."
stardog-admin virtual import covid19kr route.sms.ttl route.csv 
echo "Import time..."
stardog-admin virtual import covid19kr time.sms.ttl <(sed -e 's/-/_/' time.csv)
echo "Import trend..."
stardog-admin virtual import covid19kr trend.sms.ttl trend.csv 
