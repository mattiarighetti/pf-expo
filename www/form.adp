<!DOCTYPE html>
<!--[if IE 9]>
<html class="ie ie9" lang="en-US">
<![endif]-->
<html lang="en-US">
<head>
	<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
	
	<title>Iscriviti - PFEXPO</title>

	<link rel="shortcut icon" href="/assets/img/favicon.ico">
	<link rel="stylesheet" href="/assets/css/all.css">
	<link rel="stylesheet" href="/assets/css/font-awesome.min.css">
	<link rel="stylesheet" href="/assets/css/simple-line-icons.css">
	<link rel="stylesheet" href="/assets/css/bootstrap.min.css">
	<link rel="stylesheet" href="/assets/css/animate.css">
	<link rel="stylesheet" href="/assets/css/jquery.bxslider.css">
	<link rel="stylesheet" href="/assets/css/owl.carousel.css">
	<link rel="stylesheet" href="/assets/css/slidebars.css">
	<link rel="stylesheet" href="/assets/rs-plugin/css/settings.css">
	<link rel="stylesheet" href="/style.css">
	
  </head>
<body class="inner-pages">
  
  <!-- Page Preloader-->
  <div class="loader-wrap">
    <div class="spinner"></div>
	  </div>
  <div id="top" class="page-top">
    <header id="header" class="fixed-header navbar-fixed-top sb-slide">
      <div class="container">
	<div class="logo local-scroll">
	  <a href="/#top" class="site-brand"><img src="http://images.professionefinanza.com/pfexpo/logos/pfexpo.png" height="80"></a>
				       </div> <!-- .logo -->
	<div class="sb-toggle-right pull-right visible-xs visible-sm">
	  <i class="fa fa-bars"></i>
				  </div>
	<nav class="site-nav hidden-xs hidden-sm">
	  <ul class="main-menu local-scroll">
	    <li><a href="/#top">Home</a></li>
          <li><a href="/#iscriviti" class="active">Iscriviti</a></li>
          <li><a href="/#programma">Programma</a></li>
          <li><a href="/#speakers">Speakers</a></li>
          <li><a href="/#partners">Partners</a></li>
            <li><a href="/#edizioni">Edizioni</a></li>
            <li><a href="/#contatti">Contatti</a></li>
	    <li><a href="http://www.facebook.com/ProfessioneFinanza" target="_blank">News</a></li>
					    </ul> <!-- .main-menu -->
				       </nav> <!-- .site-nav -->
			       </div> <!-- .container -->
			  </header> <!-- #header -->
    
	       </div> <!-- #top -->
  
  <div id="sb-site">
    
    <div class="page-intro">
      
      <div class="header-space" style="height: 72px;"></div>
      
      <div id="page-sample" class="page-top page-section parallax-section">
	<div style="background-color:#000" class="parallax-bg" data-bottom-top="background-position: 50% 0px;" data-top-bottom="background-position: 50% -100px;" data-anchor-target="#page-sample">
	  <div class="container">
	    <div class="row">
	      <div class="col-md-12 text-center">
		<h2 class="title">Completa la tua iscrizione al PFEXPO</h2>
									     </div> <!-- .col-md-12 -->
								     </div> <!-- .row -->
							     </div> <!-- .container -->
					      </div> <!-- .parallax-bg -->
				      </div> <!-- .page-top -->
      
		       </div> <!-- .page-intro -->
    
    <div class="wrapper">      
      <div class="container">
	<br>
	<h4>Eventi a cui sei iscritto:</h4>
	@event_list_html;noquote@
	    </br>
	    <formtemplate id="iscritto">
	      <fieldset>
		<legend>Conferma i tuoi dati e iscriviti</legend>
		<div data-row-span="2">
	  <div data-field-span="1" class="" style="height: 59px;">
	    <label>Nome *</label>
	    <font color="red">
	      <formerror id="nome"></formerror>
    </font>
	    <input type="text" autofocus="" name="nome" maxlenght="100" id="nome" style="text-transform:capitalize;">
	      </div>
	  <div data-field-span="1" style="height: 59px;">
	    <label>Cognome *</label>
	    <font color="red">
	      <formerror id="cognome"></formerror>
  </font>
	    <input type="text" name="cognome" maxlenght="100" id="cognome" style="text-transform:capitalize;">
					</div>
			    </div>
	        <div data-row-span="2">
		  <div data-field-span="1" class="" style="height: 59px;">
		    <label>Email *</label>
		    <font color="red">
		      <formerror id="email"></formerror>
  </font>
            <input type="text" autofocus="" name="email" maxlenght="100" id="email" style="text-transform:lowercase;">
                                    </div>
          <div data-field-span="1" style="height: 59px;">
            <label>Società *</label>
	    <font color="red">
	      <formerror id="societa"></formerror>
  </font>
            <input type="text" name="societa" maxlenght="50" id="societa" style="text-transform:capitalize;">
                                      </div>
                            </div>
		        <div data-row-span="2">
          <div data-field-span="1" class="" style="height: 59px;">
            <label>Provincia *</label>
	    <font color="red">
	      <formerror id="provincia"></formerror>
  </font>
            <input type="text" autofocus="" name="provincia" maxlenght="100" id="provincia" style="text-transform:capitalize;">
                                    </div>
          <div data-field-span="1" style="height: 59px;">
            <label>Numero di cellulare *</label>
	    <font color="red">
	      <formerror id="telefono"></formerror>
  </font>
            <input type="text" name="telefono" maxlenght="100" id="telefono">
                                      </div>
                              </div>
			<div data-row-span="2">
			  <div data-field-span="1">
			  <blockquote>
			  <p>Hai scelto dei corsi a pagamento?<p>
				</blockquote>
			    </div>
			  <div data-field-span="1">
			    		      <label>Voucher (Non inserire nulla se non si è ricevuto un Voucher)</label>
			      <font color="red">
				<formerror id="voucher"></formerror>
				      </font>
			      <input type="text" name="voucher" maxlenght="15" id="voucher">
    </div>
			    </div>
			<div data-row-span="1">
			  <blockquote>
			    <p>Se vuoi, indicaci dei dati aggiuntivi e cercheremo per te una società interessata a coprire i costi al posto tuo.</p>
			    </blockquote>
    </div>
			  <div data-row-span="3">
          <div data-field-span="1" class="" style="height: 59px;">
            <label>Ammontare portafoglio</label>
	    <font color="red">
	      <formerror id="portafoglio"></formerror>
  </font>
            <input type="text" autofocus="" name="portafoglio" maxlenght="100" id="portafoglio">
                                    </div>
          <div data-field-span="1" style="height: 59px;">
            <label>Numero clienti</label>
	    <font color="red">
	      <formerror id="clienti"></formerror>
  </font>
            <input type="text" name="clienti" maxlenght="100" id="clienti">
					</div>
          <div data-field-span="1" class="" style="height: 59px;">
            <label>Anni di attività</label>
	    <font color="red">
	      <formerror id="attivita"></formerror>
  </font>
            <input type="text" autofocus="" name="attivita" maxlenght="100" id="attivita">
                                      </div>
					    </div>
			  <div data-row-span="1">
			    <div data-field-span="1">
			      <label>Accetto i termini e condizioni * <a href="http://professionefinanza.com/pagina.php?id=8" class="iubenda-white iubenda-embed" title="Privacy Policy" target="_blank">Privacy Policy</a></label>
			      <font color="red">
				<formerror id="privacy"></formerror>
  </font>
			      <input type="checkbox" id="iscritto:privacy:element:t" value="true" name="privacy">
			      </div>
	    </div>
			  <div data-row-span="1">
			    <div data-field-span="1">
			      <center><input align="center" name="formbutton:ok" class="t-btn t-btn-primary t-btn-rounded" type="submit"></input></center>
				</div>
	    </div>
		      </fieldset><br>
<p><small>Tutti i campi contrassegnati da asterisco sono da considerarsi obbligatori.</small></p>
		  </formtemplate>
	    		</div>
      					    </div> <!-- .wrapper -->


<footer class="site-footer">
    <div class="footer-widgets">
      <div class="container">
        <div class="col-md-6 col-sm-6 widget">
          <div class="widget-title">
            <h2>Su di noi</h2>
          </div>
          <p>ProfessioneFinanza è il portale di riferimento per chi desidera approcciarsi in modo professionale alla gestione del proprio patrimonio finanziario e non solo. Alla scuola di formazione FinanzaAcademy, che ha formato oltre ventimila fra Promotori Finanziari, Consulenti Indipendenti e Private Banker. Fra corsi dedicati, interaziendali e grandi eventi come i PFLAB e il PFEXPO, il più importante evento in Italia dedicato al Professionista della Finanza, abbiamo affiancato la testata giornalistica di formazione e informazione finanziaria MyAdvice.</p>
          <br>
          <p class="mb-half"><i class="fa fa-phone icon-left"></i> Telefono: +39 02 39 56 57 25</p>
          <p class="mb-half"><i class="fa fa-map-marker icon-left"></i> Viale Vittorio Veneto, 28 - 20124 Milano</p>
          <p class="mb-half"><i class="fa fa-desktop icon-left"></i> www.professionefinanza.com</p>
        </div>
        <!-- .col-md-6 -->
        <div id="contact" class="col-md-6 col-sm-6 widget">
          <div class="widget-title">
            <h2>Contattaci</h2>
          </div>
          <div class="contact-form">
            <table>
	      <tr>
		<td>
		  Per richieste di informazioni varie
		</td>
		<td>
		  <a href="mailto:info@pfexpo.it">info@pfexpo.it</a>
		</td>
	      </tr>
	      <tr>
		<td>
		  Per diventare partner
		</td>
		<td>
		  <a href="mailto:partners@pfexpo.it">partners@pfexpo.it</a>
		</td>
	      </tr>
	      <tr>
		<td>
		  Per problemi col portale
		</td>
		<td>
		  <a href="mailto:webmaster@pfexpo.it">webmaster@pfexpo.it</a>
		  </td>
	      </tr>
	      </table>
          </div>
          <!-- .contact-form --> 
        </div>
        <!-- #contact --> 
      </div>
      <!-- .container --> 
    </div>
    <!-- footer-widget -->
    <div class="footer-bottom text-center">
      <div class="container">
        <div class="social-icons mb-2"> <a href="http://www.facebook.com/professionefinanza" target="_blank" class="fa fa-facebook"></a> <a href="http://www.instagram.com/professionefinanza" target="_blank" class="fa fa-instagram"></a> <a href="http://www.twitter.com/PFHolding" target="_blank" class="fa fa-twitter"></a> <!--<a href="#" target="_blank" class="fa fa-google-plus"></a>--> </div>
        <!-- .social-icons -->
        <div class="footer-copyright">
          <div class="copyright-text">&copy; 2015 | PF Holding S.r.l. Tutti i diritti riservati. Creato con <i class="fa fa-heart"></i> da <a href="http://www.mattiarighetti.it/">Mattia Righetti</a>.</div>
        </div>
      </div>
      <!-- .container --> 
    </div>
    <!-- .footer-bottom --> 
  </footer>
  <!-- .site-footer --> 
  
</div>
<!-- #sb-site -->

<div class="sb-slidebar sb-right">
  <nav class="slidebar-menu">
    <ul class="local-scroll">
<li><a href="/#top">Home</a></li>
          <li><a class="active" href="/#iscriviti">Iscriviti</a></li>
          <li><a href="/#programma">Programma</a></li>
          <li><a href="/#speakers">Speakers</a></li>
          <li><a href="/#partners">Partners</a></li>
            <li><a href="/#edizioni">Edizioni</a></li>
            <li><a href="/#contatti">Contatti</a></li>
	    <li><a href="http://www.facebook.com/ProfessioneFinanza" target="_blank">News</a></li>
  </ul>
  </nav>
</div>
<!-- .sb-slidebar -->

<div class="go-top"> <a href="#"><i class="fa fa-angle-up"></i></a> </div>
<script type="text/javascript" src="/assets/js/base.js"></script>
<script type="text/javascript" src="/assets/js/jquery-1.11.2.min.js"></script> 
<script type="text/javascript" src="/assets/js/jquery.easing.1.3.js"></script> 
<script type="text/javascript" src="/assets/js/bootstrap.min.js"></script> 
<script type="text/javascript" src="/assets/js/appear.min.js"></script> 
<script type="text/javascript" src="/assets/js/jquery.countTo.js"></script> 
<script type="text/javascript" src="/assets/js/jquery.scrollTo.min.js"></script> 
<script type="text/javascript" src="/assets/js/jquery.localScroll.min.js"></script> 
<script type="text/javascript" src="/assets/js/jquery.viewport.mini.js"></script> 
<script type="text/javascript" src="/assets/js/skrollr.js"></script> 
<script type="text/javascript" src="/assets/js/smoothscroll.min.js"></script> 
<script type="text/javascript" src="/assets/js/imagesloaded.pkgd.min.js"></script> 
<script type="text/javascript" src="/assets/js/isotope.pkgd.min.js"></script> 
<script type="text/javascript" src="/assets/js/jquery.bxslider.min.js"></script> 
<script type="text/javascript" src="/assets/js/owl.carousel.min.js"></script> 
<script type="text/javascript" src="/assets/js/slidebars.min.js"></script> 
<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script> 
<script type="text/javascript" src="/assets/js/map-custom.js"></script> 
<script type="text/javascript" src="/assets/rs-plugin/js/jquery.themepunch.tools.min.js"></script> 
<script type="text/javascript" src="/assets/rs-plugin/js/jquery.themepunch.revolution.min.js"></script> 
<script type="text/javascript" src="/assets/js/theme.min.js"></script>
</body>
</html>
