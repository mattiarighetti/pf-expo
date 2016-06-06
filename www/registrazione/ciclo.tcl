# 
ddddd
ad_page_contract {
    
    
    
    @author mattia (mattia.righetti@professionefinanza.com)
    @creation-date 2016-05-31
    @cvs-id $Id$
} {
    
} -properties {
} -validate {
} -errors {
}
db_foreach query "select * from expo_temporanea" {
    if {[db_0or1row query "select * from expo_investitori where email ilike :email limit 1"]} {
	set investitore_id [db_string query "select investitore_id from expo_investitori where email ilike :email"]
    } else {
	set investitore_id [db_string query "select coalesce(max(investitore_id)+trunc(random()*99), trunc(random()*99)) from expo_investitori"]
	db_dml query "insert into expo_investitori (investitore_id, nome, cognome, email) values (:investitore_id, :nome, :cognome, :email)"
    }
    if {![db_0or1row query "select * from expo_eventi_investitori where investitore_id = :investitore_id and evento_id = :evento_id"]} {
	db_dml query "insert into expo_eventi_investitori (investitore_id, evento_id) values (:investitore_id, :evento_id)"
    }
}
ad_returnredirect index
ad_script_abort
