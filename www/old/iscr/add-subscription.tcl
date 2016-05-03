ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date 11 September 2014
    @cvs-Id add-subscription.tcl
} {
    evento_id:integer
    iscritto_id:integer
}
#Controlla che non vi siano eventi in parallelo
#Eventi in prima riga
if {$evento_id <= 6} {
    set query01 [db_0or1row query "SELECT evento_id FROM pf_expo_iscrizioni WHERE iscritto_id = :iscritto_id AND evento_id < 7 ORDER BY evento_id ASC LIMIT 1"]
    if {$query01 == 1} {
	set parallel [db_string query "SELECT evento_id FROM pf_expo_iscrizioni WHERE iscritto_id = :iscritto_id ORDER BY evento_id ASC LIMIT 1"]
    } else {
	set parallel 7
    }
    if {$parallel <= 6} {
	ad_returnredirect "choose-events?iscritto_id=$iscritto_id&parallel=$parallel"
	ad_script_abort
    }
}
#Eventi in seconda riga
if {$evento_id >= 7 && $evento_id <= 10} {
    set query01 [db_0or1row query "SELECT evento_id FROM pf_expo_iscrizioni WHERE evento_id BETWEEN 7 AND 10 AND iscritto_id = :iscritto_id OR evento_id = 2 AND iscritto_id = :iscritto_id OR evento_id = 3 AND iscritto_id = :iscritto_id ORDER BY evento_id ASC LIMIT 1"]
    if {$query01 == 1} {
        set parallel [db_string query "SELECT evento_id FROM pf_expo_iscrizioni WHERE evento_id BETWEEN 7 AND 10 AND iscritto_id = :iscritto_id OR evento_id = 2 AND iscritto_id = :iscritto_id OR evento_id = 3 AND iscritto_id = :iscritto_id ORDER BY evento_id ASC LIMIT 1"]
    } else {
        set parallel 16
    }
    if {$parallel <= 15} {
        ad_returnredirect "choose-events?iscritto_id=$iscritto_id&parallel=$parallel"
        ad_script_abort
    }
}
#Eventi in terza riga
if {$evento_id >= 11 && $evento_id <= 16} {
    set query01 [db_0or1row query "SELECT evento_id FROM pf_expo_iscrizioni WHERE iscritto_id = :iscritto_id AND evento_id > 10 AND evento_id < 17 ORDER BY evento_id ASC LIMIT 1"]
    if {$query01 == 1} {
	set parallel [db_string query "SELECT evento_id FROM pf_expo_iscrizioni WHERE iscritto_id = :iscritto_id AND evento_id > 10 ORDER BY evento_id ASC LIMIT 1"]
    } else {
	set parallel 17
    }
    if {$parallel <= 16} {
	ad_returnredirect "choose-events?iscritto_id=$iscritto_id&parallel=$parallel"
	ad_script_abort
    }
}
#Eventi in quarta riga
if {$evento_id >= 17 && $evento_id <= 20} {
    set query01 [db_0or1row query "SELECT evento_id FROM pf_expo_iscrizioni WHERE evento_id > 16 AND iscritto_id = :iscritto_id OR evento_id = 11 AND iscritto_id = :iscritto_id OR evento_id = 13 AND iscritto_id = :iscritto_id ORDER BY evento_id ASC LIMIT 1"]
    if {$query01 == 1} {
        set parallel [db_string query "SELECT evento_id FROM pf_expo_iscrizioni WHERE evento_id > 16 AND iscritto_id = :iscritto_id OR evento_id = 11 AND iscritto_id = :iscritto_id OR evento_id = 13 AND iscritto_id = :iscritto_id ORDER BY evento_id ASC LIMIT 1"]
    } else {
        set parallel 21
    }
    if {$parallel <= 20} {
	ad_returnredirect "choose-events?iscritto_id=$iscritto_id&parallel=$parallel"
        ad_script_abort
    }
}
#Query per l'iserimento di una nuova iscrizione all'evento in variabile
with_catch errmsg {
    set iscrizione_id [db_string query "SELECT COALESCE(MAX(iscrizione_id)+1,1) FROM pf_expo_iscrizioni"]
    db_dml query "INSERT INTO pf_expo_iscrizioni (iscrizione_id, evento_id, iscritto_id) VALUES (:iscrizione_id, :evento_id, :iscritto_id)"
} {
    ad_return_complaint 1 "<b>Attenzione: non è stato possibile iscriversi all'evento. Si prega di tornare indietro e riprovare.</b>" 
    return
}
ad_returnredirect "choose-events?iscritto_id=$iscritto_id"
ad_script_abort