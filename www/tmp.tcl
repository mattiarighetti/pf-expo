# 

ad_page_contract {
    
    Programma per l'iscrizione temporanea (salvataggio eventi con session_id).
    
    @author mattia (mattia.righetti@professionefinanza.com)
    @creation-date 2015-11-27
    @cvs-id $Id$
} {
    evento_id:naturalnum
    {return_url ""}
} -properties {
} -validate {
} -errors {
}

set expo_id [db_string query "select expo_id from expo_edizioni where attivo is true"]
if {![db_0or1row query "select * from expo_eventi where evento_id = :evento_id and expo_id = :expo_id limit 1"]} {
    ad_return_complaint 1 "<b>Errore!</b> Evento non esistente.<br>Se il problema persiste, rivolgersi a <a href=\"mailto:mattia.righetti@professionefinanza.com\">webmaster</a>."
}
set session_id [ad_get_cookie session_id]
# Se c'era già cancella, se no inserisce
if {[db_0or1row query "select * from expo_tmp where session_id = :session_id and evento_id = :evento_id"]} {
    db_dml query "delete from expo_tmp where evento_id = :evento_id and session_id = :session_id"
} else {
    set start_time [db_string query "select start_time from expo_eventi where evento_id = :evento_id"]
    set end_time [db_string query "select end_time from expo_eventi where evento_id = :evento_id"]
    db_foreach query "select e.start_time as start_check, e.end_time as end_check from expo_tmp t, expo_eventi e where e.evento_id = t.evento_id and t.session_id = :session_id" {
	if {[db_string query "select (:start_time::timestamp, :end_time::timestamp) overlaps (:start_check::timestamp, :end_check::timestamp)"] == t} {
	    if {$return_url eq ""} {
		set return_url "/?msg=overlap#iscriviti"
	    } else {
		append return_url "&msg=overlap"
	    }
	    ad_returnredirect -allow_complete_url $return_url
	    ad_script_abort
	}
    }
    set tmp_id [db_string query "select coalesce(max(tmp_id)+1, 1) from expo_tmp"]
    db_dml query "insert into expo_tmp (tmp_id, session_id, evento_id) values (:tmp_id, :session_id, :evento_id)"
}
if {$return_url eq ""} {
    set return_url "/#iscriviti"
}
ad_returnredirect $return_url 
ad_script_abort
