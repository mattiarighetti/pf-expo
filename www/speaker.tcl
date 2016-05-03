ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Tuesday 26 May 2015
} {
    speaker_id:integer
}
db_transaction {
    set intestazione [db_string query "select nome||' '||cognome from expo_speakers where speaker_id = :speaker_id"]
    set page_title $intestazione
    set logo_url "http://images.professionefinanza.com/pfexpo/logos/"
    append logo_url [db_string query "select immagine from expo_edizioni where attivo is true"]
    set citazione [db_string query "select citazione from expo_speakers where speaker_id = :speaker_id"]
    set posizione [db_string query "select posizione from expo_speakers where speaker_id = :speaker_id"] 
    set immagine [db_string query "select immagine from expo_speakers where speaker_id = :speaker_id"]
    set short_cv [db_string query "select short_cv from expo_speakers where speaker_id = :speaker_id"]
}
set events_table "<table class=\"table table-hover\"><tr><th>Evento</th><th>Ore</th><th>Sala</th><th>&nbsp;</th></tr>"
db_foreach query "select e.evento_id, e.permalink, e.denominazione, to_char(e.start_time, 'HH24:MI') as start_time, s.denominazione as sala from expo_eventi e, expo_sale s, expo_eventi_speakers r, expo_edizioni l where r.speaker_id = :speaker_id and e.evento_id = r.evento_id and e.sala_id = s.sala_id and e.expo_id = l.expo_id and l.attivo is true" {
    append events_table "<tr><td>$denominazione</td><td>$start_time</td><td>$sala</td><td><a class=\"btn btn-success\" href=\"http://pfexpo.professionefinanza.com/programma/$permalink\" role=\"button\">Dettagli</a></td></tr>"
}
append events_table "</table>"
ad_return_template
