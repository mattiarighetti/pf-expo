ad_page_contract {}
set count 0
set count2 0
db_foreach query "select barcode, evento_id from expo_badge_tmp" {
    if {[string length $barcode] > 12} {
	set barcode [string range $barcode 0 11]
    }
    set barcode [expr $barcode - 803000000000]
    set iscritto_id [db_string query "select iscritto_id from expo_iscritti where iscritto_id = :barcode" -default "-1"]
    if {$iscritto_id ne "-1"} {
	if {![db_0or1row query "select * from expo_presenze where evento_id = :evento_id and iscritto_id = :iscritto_id limit 1"]} {
	    with_catch errmsg {
		db_dml query "insert into expo_presenze (evento_id, iscritto_id) values (:evento_id, :iscritto_id)"
	    } {
		ad_return_complaint 1 "<b>ERRORE<b><br><code>$errmsg</code>"
		return
	    }
	}
	incr count
    } else {
	incr count2 
    }
}
ad_return_complaint 1 "Conta $count non $count2"
ad_script_abort
