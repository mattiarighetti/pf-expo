ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
} {
    iscrizione_id:integer
    iscritto_id:integer
}
#Query per la cancellazione di un'iscrizione da un evento in variabile
with_catch errmsg {
    db_dml query "DELETE FROM pf_expo_iscrizioni WHERE iscrizione_id = :iscrizione_id"
} {
    ad_return_complaint 1 "<b>Attenzione: non è stato possibile cancellare l'iscrizione. Si prega di tornare indietro e riprovare <a href=\"choose-events?iscritto_id=$iscritto_id\">cliccando qua</a>.</b>" 
    return
}
ad_returnredirect "choose-events?iscritto_id=$iscritto_id"
ad_script_abort