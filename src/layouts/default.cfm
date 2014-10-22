<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

	<title>Steven Neiland Demo Project</title>

	<!-- Bootstrap css -->
	<link rel="stylesheet" href="libs/bootstrap/css/bootstrap.min.css">
	<link rel="stylesheet" href="libs/bootstrap/css/bootstrap-theme.min.css">

	<!-- Our core css file -->
	<link rel="stylesheet" href="assets/css/main.css">

	<!-- Font awesome -->
	<link href="//maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" rel="stylesheet">

	<!-- JQuery -->
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script>

	<!-- Datatables -->
	<link rel="stylesheet" type="text/css" href="libs/datatables/media/css/jquery.dataTables.css"/>
	<script type="text/javascript" src="libs/datatables/media/js/jquery.dataTables.js"></script>
	<script type="text/javascript" src="libs/datatables/extensions/TableTools/js/dataTables.tableTools.js"></script>

	<!-- JQueryUI -->
	<link rel="stylesheet" type="text/css" href="libs/jquery-ui-1.11.2.custom/jquery-ui.css">
	<link rel="stylesheet" type="text/css" href="libs/jquery-ui-1.11.2.custom/jquery-ui.structure.css">
	<link rel="stylesheet" type="text/css" href="libs/jquery-ui-1.11.2.custom/jquery-ui.theme.css">

	<!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="libs/respondjs/dest/respond.src.js"></script>
    <![endif]-->
</head>
<body>
	<div class="navbar navbar-inverse navbar-fixed-top" role="navigation">
      <div class="container-fluid">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="#">Demo Project</a>
        </div>

        <div class="navbar-collapse collapse">
          <ul class="nav navbar-nav navbar-right">
            <cfoutput>
				<li><a href="#buildUrl(action='help.default',querystring='helpaction=#rc.action#')#" class="openDialog">Help</a></li>
			</cfoutput>
          </ul>
        </div>
      </div>
    </div>

	<div class="container-fluid">
		<div class="row">
			<div class="col-sm-3 col-md-2 sidebar">
				<ul class="nav nav-sidebar">
				<cfoutput>
					<li <cfif rc.action EQ "main.default">class="active"</cfif>><a href="#buildUrl('main.default')#">Server List</a></li>
					<li><a href="#buildUrl('main.other')#">An empty link</a></li>
				</cfoutput>
				</ul>
			</div>

			<div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
				<cfoutput>#body#</cfoutput>
			</div>
		</div>
	</div>

	<!-- Help dialog container -->
	<div id="dialog-help"></div>

	<script>
		// Help click listener
		$(".openDialog").on("click", function (e) {
			e.preventDefault();
			e.stopPropagation();
			var url = $(this).attr("href");
			showHelpDialog(url);
		});

		function showHelpDialog(url){
			$.ajax({
				url: url,
				success: function(data) {
					$("#dialog-help").dialog({
						height: "600",
						width: "650",
						modal:true,
						buttons: {
			            	Close: function(){
			            		$(this).dialog("close");
			            	}
			        	},
			        	create: function (){
				            $(this).html(data);
				        },
			        	title: 'Help'
					}).dialog('open');
				}
			});
		}
	</script>

	<!-- Bootstrap -->
	<script src="libs/bootstrap/js/bootstrap.min.js"></script>

	<!-- JQueryUI -->
	<script src="libs/jquery-ui-1.11.2.custom/jquery-ui.js"></script>

	<!-- Common javascript functions -->
    <script src="assets/js/main.js"></script>
</body>
</html>