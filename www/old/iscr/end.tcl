ad_page_contract {
    @author Mattia Righetti (mattia.righetti@professionefinanza.com)
} {
    iscritto_id:integer
}
set to_mail [db_string query "SELECT email FROM pf_expo_iscr WHERE iscritto_id = :iscritto_id"]
set from_mail "mattia.righetti@professionefinanza.com"
set reply_to "info@pfexpo.it"
set subject "Riepilogo iscrizione PFEXPO '15 - Milano, Palazzo delle Stelline"
set body "Gentile Professionista della Finanza,\n\nLa tua registrazione al PFEXPO di Milano del 29 gennaio 2015 è andata a buon fine.\nEcco quà un riepilogo dei corsi a cui ti sei iscritto:\n"
set max_events [db_string query "SELECT COUNT(*) FROM pf_expo_iscrizioni WHERE iscritto_id = :iscritto_id"]
set counter 0
while {$counter < $max_events} {
    set event_descr [db_string query "SELECT e.descrizione FROM pf_expo_eventi e, pf_expo_iscrizioni i WHERE e.evento_id = i.evento_id AND i.iscritto_id = :iscritto_id ORDER BY e.evento_id OFFSET $counter LIMIT 1"]
    append body " - "
    append body $event_descr
    append body "\n"
    incr counter
    ns_log notice "$counter sono qua11"
}
set pagamento [db_string query "SELECT COUNT(e.pagamento) FROM pf_expo_eventi e, pf_expo_iscrizioni i WHERE e.evento_id = i.evento_id AND i.iscritto_id = :iscritto_id AND e.pagamento"]
if {$pagamento > 0} {
    if {$pagamento == 1} {
	append body "\nCi risulta iscrizione per un corso a pagamento. Il costo del singolo corso a pagamento è di 60€ + IVA. Di seguito le riportiamo i dati per effettuare il bonifico:\nPF Holding srl\nIBAN\tIT59W0316501600000701004852\n"
    } else {
	append body "\nCi risulta iscrizione per corsi a pagamento. Grazie alla promozione puoi frequentare tutti i corsi a pagamento ai quali sei interessato con soli 90€ + IVA. Di seguito le riportiamo i dati per effettuare il bonifico:\nPF Holding srl\nIBAN\tIT59W0316501600000701004852\n"
    }
}
append body "\nIn caso volessi modificare o cancellare degli eventi a cui ti sei iscritto, basta collegarsi alla pagina di iscrizione e inserire la stessa email ($to_mail) e ti verrà ripresentata la tabella con gli eventi a cui partecipi.\nInoltre, ti chiediamo cortesemente, data l'alta affluenza di partecipanti, di presentarti con qualche minuto di anticipo per non perdere la tua priorità d'ingresso.\n\nTi ringraziamo e ti aspettiamo a Milano il prossimo 29 gennaio.\n\nLo staff di ProfessioneFinanza"
ns_log notice "sono anche qua"
acs_mail_lite::send -to_addr $to_mail \
    -from_addr $from_mail \
    -subject $subject \
    -body $body \
    -reply_to "info@pfexpo.it"
ad_return_template