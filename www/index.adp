<!DOCTYPE html>
<html dir="ltr" lang="en-US">
<head>

	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<meta name="author" content="PF Holding" />

	<!-- Stylesheets
	============================================= -->
	<link href="http://fonts.googleapis.com/css?family=Lato:300,400,400italic,600,700|Raleway:300,400,500,600,700|Crete+Round:400italic" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" href="css/bootstrap.css" type="text/css" />
	<link rel="stylesheet" href="style.css" type="text/css" />
	<link rel="stylesheet" href="css/dark.css" type="text/css" />

	<!-- Agency Demo Specific Stylesheet -->
	<link rel="stylesheet" href="demos/agency/agency.css" type="text/css" />
	<!-- / -->

	<link rel="stylesheet" href="css/font-icons.css" type="text/css" />
	<link rel="stylesheet" href="css/animate.css" type="text/css" />
	<link rel="stylesheet" href="css/magnific-popup.css" type="text/css" />
	<link rel="stylesheet" href="timetable.css" type="text/css" />
	<link rel="stylesheet" href="css/responsive.css" type="text/css" />
	<meta name="viewport" content="width=device-width, initial-scale=1" />
	<!--[if lt IE 9]>
		<script src="http://css3-mediaqueries-js.googlecode.com/svn/trunk/css3-mediaqueries.js"></script>
	<![endif]-->

	<link rel="stylesheet" href="css/colors.php?color=c0bb62" type="text/css" />

	<!-- Document Title
	============================================= -->
	<title>PFEXPO</title>

</head>
<body class="stretched">

	<!-- Document Wrapper
	============================================= -->
	<div id="wrapper" class="clearfix">

		<!-- Header
		============================================= -->
		<header id="header" class="sticky-style-2">

			<div class="container clearfix">

				<!-- Logo
				============================================= -->
				<div id="logo" class="divcenter">
				  <a href="index" class="standard-logo"><img class="divcenter" src="@logo_url@" alt="Canvas Logo"></a>
					<a href="index" class="retina-logo"><img class="divcenter" src="@logo_url@" alt="Canvas Logo"></a>
				</div><!-- #logo end -->

			</div>

			<div id="header-wrap">

				<!-- Primary Navigation
				============================================= -->
				<nav id="primary-menu" class="style-2 center">

					<div class="container clearfix">

						<div id="primary-menu-trigger"><i class="icon-reorder"></i></div>

						<ul>
									<li><a href="index"><div>Home</div></a></li>
									<li><a href="iscriviti"><div>Iscriviti</div></a></li>
									<li><a href="programma"><div>Programma</div></a></li>
									<li><a href="speakers"><div>Speaker</div></a></li>
									<li><a href="partners"><div>Partner</div></a></li>
									<li><a href="edizioni"><div>Edizioni</div></a></li>
									<li><a href="contatti"><div>Contatti</div></a></li>
						</ul>

					</div>

				</nav><!-- #primary-menu end -->

			</div>

		</header><!-- #header end -->

		<section id="slider" class="boxed-slider">

			<div class="container clearfix">

				<div id="oc-slider" class="owl-carousel carousel-widget" data-items="1" data-loop="true" data-nav="true" data-autoplay="5000" data-animate-in="fadeIn" data-animate-out="fadeOut" data-speed="800">

					<a href="#"><img src="http://images.professionefinanza.com/pfexpo/slide1.jpg" alt="Slider"></a>
					<a href="#"><img src="http://images.professionefinanza.com/pfexpo/slide2.jpg" alt="Slider"></a>
					<a href="#"><img src="http://images.professionefinanza.com/pfexpo/slide3.jpg" alt="Slider"></a>

				</div>


			</div>

		</section>

		<!-- Content
		============================================= -->
		<section id="content">

			<div class="content-wrap">

				<div class="container clearfix">
<div class="widget-title">
		      <div class="row">
			<div class="col-sm-12">
			 <center><h2>Special guest</h2></center>
						    </div>
			<!-- .col-sm-12 -->
					      </div>
		      <!-- .row -->
				    </div>
					<div class="row clearfix">
					  @speaker_list_html;noquote@
				<!--		<div class="col-md-4 center bottommargin">
          <img class="img-circle" src="http://images.professionefinanza.com/pfawards/icons/consulenti.png" alt="PFEXPO 2016 a Roma" width="140" height="140">
            <p>Special Guest 1</p>
        </div><!-- /.col-lg-4 --
        <div class="col-md-4 center bottommargin">
          <img class="img-circle" src="http://images.professionefinanza.com/pfawards/icons/incontri.png" alt="Percrsi formativi tematiche finanziarie" width="140" he\
ight="140">
            <p>Special guest 2</p>
        </div><!-- /.col-lg-4 --
        <div class="col-md-4 center bottommargin">
          <img class="img-circle" src="http://images.professionefinanza.com/pfawards/icons/visibilita.png" alt="" width="140" height="140">
          <p>Special guest 3</p>
        </div><!-- /.col-lg-4 -->

      </div>


						</div>

					</div>
</section>

<div class="line"></div>
					<!-- timetable
		============================================= -->
		<section id="timetable">

			<div class="content-wrap">

				<div class="container clearfix">
<div class="widget-title">
		      <div class="row">
			<div class="col-sm-12">
			  <center><h2>Gli eventi in programma</h2></center>
						  </div>
			<!-- .col-sm-12 --> 
					  </div>
		      <!-- .row --> 
				    </div>

		<div class="table-responsive">
					@events_table;noquote@
				</div>
				<br>
				<div class="container">
				  <img class="img-responsive" src="http://images.professionefinanza.com/pfexpo/sito-legenda-padova.jpg"
				</div>
				<!-- fine tabella-->

						</div>

					</div>
</section>
<div class="line"></div>
			<section id="luogo">
			<div class="container">
				<div class="widget-title">
		      <div class="row">
			<div class="col-sm-12">
			<center><h2>Location</h2></center>
						  </div>
			<!-- .col-sm-12 --> 
					  </div>
		      <!-- .row --> 
				    </div>
<div class="panel panel-default">
  <div class="panel-body">
    @location@
  </div>
</div>
				<iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2798.780138372284!2d11.854519215850464!3d45.45408644213868!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x477ed74b59ad1f5b%3A0x28263c964d7a04f7!2sCrowne+Plaza+Padova!5e0!3m2!1sit!2sit!4v1476194677447" width="100%" height="350" frameborder="0" style="border:0" allowfullscreen></iframe>
		</div>
		<!-- .contact-google-map --> 
			</section>		
					


<!-- Footer
		============================================= -->
		<footer id="footer">

			<!-- Copyrights
			============================================= -->
			<div id="copyrights">

				<div class="container clearfix">

					<div class="col_half">
						<img class="footer-logo" src="http://images.professionefinanza.com/logos/professionefinanza.png" width="250px"><br>
						<!--<div class="copyright-links"><a href="#">Terms of Use</a> / <a href="#">Privacy Policy</a></div>-->
					</div>

					<div class="col_half col_last tright">
						<div class="fright clearfix">
							<a href="https://www.facebook.com/ProfessioneFinanza" class="social-icon si-small si-light si-rounded si-facebook">
								<i class="icon-facebook"></i>
								<i class="icon-facebook"></i>
							</a>

							<a href="https://twitter.com/PFHolding" class="social-icon si-small si-light si-rounded si-twitter">
								<i class="icon-twitter"></i>
								<i class="icon-twitter"></i>
							</a>

						</div>

						<div class="clear"></div>

					</div>

				</div>

			</div><!-- #copyrights end -->

		</footer><!-- #footer end -->

	</div><!-- #wrapper end -->

	<!-- Go To Top
	============================================= -->
	<div id="gotoTop" class="icon-angle-up"></div>

	<!-- External JavaScripts
	============================================= -->
	<script type="text/javascript" src="js/jquery.js"></script>
	<script type="text/javascript" src="js/plugins.js"></script>

	<!-- Footer Scripts
	============================================= -->
	<script type="text/javascript" src="js/functions.js"></script>

</body>
</html>
