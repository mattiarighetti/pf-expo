ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Monday 7 November, 2014
} {
    iscritto_id:integer
    {parallel 0}
}
set page_title "Scegli gli eventi - PFexpo"
set user_id [ad_conn user_id]
#Se ritorna da una negazione per evento parallelo, mostra popup
if {$parallel > 0} {
    set onload "onload=\"parallel()\""
} else {
    set onload ""
}
#Imposta colore sfondo cella se evento già selezionato
set max_rows [db_string query "SELECT COUNT(*) FROM pf_expo_eventi"]
for {set counter 1} {$counter <= $max_rows} {incr counter} {
    set event$counter [db_string query "SELECT descrizione FROM pf_expo_eventi WHERE evento_id = :counter LIMIT 1"]
    set query01 [db_0or1row query "SELECT * FROM pf_expo_iscrizioni WHERE evento_id = :counter AND iscritto_id = :iscritto_id LIMIT 1"]
    if {$query01 == 1} {
	set color_$counter "background=\"../images/selected.jpg\" style=\"font-weight:bold;\""
    } else {
	set color_$counter " "
    }
}
#Imposta lista di eventi a cui l'utente si è iscritto
set list_name "events"
template::list::create -name $list_name \
    -multirow $list_name \
    -row_pretty_plural "eventi selezionati" \
    -no_data "Ancora nessun evento selezionato." \
    -class "table table-hover table-condensed table-striped" \
    -html {width 50%} \
    -caption "Eventi a cui partecipi." \
    -elements {
	descrizione {
	    label "Eventi"
	}
	pagamento {
	}
	delete {
	    label "Cancella"
	    display_template {<img src="delete.gif" width="20px" height="20px" border="0">}
	    link_url_col delete_url
	    link_html { title "Cancella evento." }
	}
    } 
db_multirow \
    -extend {
	delete_url
    } $list_name query "SELECT i.iscrizione_id, e.descrizione, CASE WHEN e.pagamento = true THEN 'A pagamento' ELSE 'Gratis' END AS pagamento FROM pf_expo_eventi e, pf_expo_iscrizioni i WHERE i.iscritto_id = :iscritto_id AND e.evento_id = i.evento_id" {
	set delete_url [export_vars -base "delete-subscription" {iscrizione_id iscritto_id}]
    }
set query01 [db_0or1row query "SELECT e.pagamento FROM pf_expo_eventi e, pf_expo_iscrizioni i WHERE i.evento_id = e.evento_id AND i.iscritto_id = :iscritto_id AND e.pagamento LIMIT 1"]
if {$query01 == 1} {
    set pagamento 1
} else {
    set pagamento 0
}