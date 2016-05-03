ad_page_contract {  
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
    @creation-date Thursday 12 February 2015
} 
set page_title "Registrazione PFEXPO 2015 Roma"
set table_html ""
db_foreach query "select iscritto_id, initcap(lower(nome)) as nome, initcap(lower(cognome)) as cognome, email, telefono, barcode, case when pagato is true then 1 else 0 end as paid from expo_iscritti where expo_id = 4" {
    #Calcolo checksum
    
    #Estrazione corsi da passare a DYMO LABEL
    set courses ""
    db_foreach query "select e.short_title, s.denominazione as sala, to_char(e.start_time, 'HH24:MI') as start_time, i.iscrizione_id, i.soldout from expo_eventi e, expo_iscrizioni i, expo_sale s where e.evento_id = i.evento_id and i.iscritto_id = :iscritto_id and s.sala_id = e.sala_id" {
	append courses "- " $short_title" (" $sala ", " $start_time ")"
	if {$paid == 1 || [db_0or1row query "select * from expo_iscrizioni where voucher_id is not null and iscrizione_id = :iscrizione_id limit 1"]} {
	    append courses "-(€)"
	}
	if {$soldout ne ""} {
	    append courses "-(*)"
	}
	append courses "&quot;,&quot;"
    }
    #Toglie ultimo br, inutile
    #set courses [string trimright $courses "<br />"]
    append table_html "&quot;" $barcode "&quot;,&quot;" [string map {' &rsquo;} $nome] "&quot;,&quot;" [string map {' &rsquo;} $cognome] "&quot;,&quot;" [string map {' &rsquo; "\"" ""} $courses] "&quot;<br>"
}


ad_return_complaint 1 $table_html
