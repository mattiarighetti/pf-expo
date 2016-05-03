ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @cvs-id processing-delete.tcl
    @param genere_id The id to delete
} {
    evento_id:integer
    {return_url "iscrizione-two"}
}
#Controllo cookie
set iscritto_id [ad_get_cookie iscritto_id]
#Cancella evento se c'era gia col cookie
if {[db_0or1row query "select * from expo_iscrizioni where iscritto_id = :iscritto_id and evento_id = :evento_id limit 1"]} {
    with_catch error_message {
	db_dml query "delete from expo_iscrizioni where iscritto_id = :iscritto_id and evento_id = :evento_id"
    } {
	ad_return_complaint 1 "<b>Attenzione!</b> Non è stato possibile eseguire l'operazione desiderata. Si prega di tornare indietro e riprovare ad eseguirla di nuovo. In caso di persistenza, contattare il webmaster a <a href=\"mailto:webmaster@professionefinanza.com\">webmaster@professionefinanza.com</a>.<br>L'errore riportato dal sistema è il seguente.<br><code>$error_message</code>"
    }
    ad_returnredirect -allow_complete_url $return_url
    ad_script_abort
}
#Estrae id expo.
set expo_id [db_string query "select expo_id from expo_edizioni where data > current_date"]
#Controllo eventi in parallelo.

#Imposta id iscrizione
set iscrizione_id [db_string query "select max(iscrizione_id) + trunc(random() *99+1) from expo_iscrizioni"]
with_catch error_message {
    db_dml query "insert into expo_iscrizioni (iscrizione_id, iscritto_id, evento_id, data) values (:iscrizione_id, :iscritto_id, :evento_id, current_date)"
} {
    ad_return_complaint 1 "<b>Attenzione!</b> Non è stato possibile eseguire l'operazione desiderata. Si prega di tornare indietro e riprovare ad eseguirla di nuovo. In caso di persistenza, contattare il webmaster a <a href=\"mailto:webmaster@professionefinanza.com\">webmaster@professionefinanza.com</a>.<br>L'errore riportato dal sistema è il seguente.<br><code>$error_message</code>"
    return
}
ad_returnredirect -allow_complete_url $return_url
ad_script_abort
