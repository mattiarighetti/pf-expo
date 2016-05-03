# 

ad_page_contract {
    
    Programma con ciclo per fare merging della tabella temporanea di MailChimp con CRM.
    
    @author mattia (mattia.righetti@professionefinanza.com)
    @creation-date 2015-11-25
    @cvs-id $Id$
} {
    
} -properties {
} -validate {
} -errors {
}

db_foreach query "select email, first, last, address, cap, comune, provincia, regione from mailchimp_tmp" {
    # Se indirizzo email registrato, controlla l'indirizzo e lo inserisce
    if{[db_0or1row query "select * from crm_contatti where valore ilike :email limit 1"]} {
	#Estrae ID persona crm
	set persona_id [db_0or1row query "select persona_id from crm_contatti where valore ilike :email limit 1"]
	#Se indirizzo non inserito, non inserisce
	if{![db_0or1row query "select * from crm_indirizzi where persona_id = :persona_id"] && $regione ne ""} {
	    #Estrae max ID indirizzo
	    
	    db_dml query "insert into crm_persone (persona_id
