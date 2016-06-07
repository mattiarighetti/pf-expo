ad_page_contract {
    Ciclo per la cancellazione degli eventuali doppioni.
    
    @author mattia (mattia.righetti@professionefinanza.com)
    @creation-date 2016-01-11
    @cvs-id $Id$
} {
    
} -properties {
} -validate {
} -errors {
}
set count 0
db_foreach query "select email from expo_iscritti where expo_id = 5" {
    if {[db_string query "select count(*) from expo_iscritti where email ilike :email and expo_id = 5"] > 1} {
	set max_id [db_string query "select iscritto_id from expo_iscritti where email ilike :email and expo_id = 5 order by iscritto_id desc limit 1"]
	db_foreach query "select iscritto_id from expo_iscritti where email ilike :email and expo_id = 5 and iscritto_id <> :max_id" {
	    db_dml query "delete from expo_iscrizioni where iscritto_id = :iscritto_id"
	    db_dml query "delete from expo_iscritti where iscritto_id = :iscritto_id"
	}
	incr count
    }
}
ad_return_complaint 1 "Conta: $count"
