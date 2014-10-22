<cfcomponent extends="libs.org.corfield.framework" output="false">

	<!--- set application name based on the directory path--->
	<cfset this.name = right(REReplace(getDirectoryFromPath(getCurrentTemplatePath()),'[^A-Za-z]','','all'),64) />

	<cfset this.applicationtimeout = createtimespan(0,1,0,0)>
	<cfset this.clientmanagement = false>
	<cfset this.invokeimplicitaccessor = true>
	<cfset this.loginstorage = "session">
	<cfset this.scriptProtect = false>
	<cfset this.sessionmanagement = true>
	<cfset this.sessiontimeout = createtimespan(0,0,20,0)>

	<!--- START: FW1 Settings --->
	<cfset variables.framework.reload = "reload">
	<cfset variables.framework.password = "true">
	<cfset variables.framework.suppressImplicitService = true>
	<cfset variables.framework.defaultSection = 'main'>
	<cfset variables.framework.usingSubsystems = false>
	<cfset variables.framework.enableGlobalRC=true>

	<!--- END: FW1 Settings --->

	<cffunction name="setupApplication" output="false">
		<cfset application.startTime = now()>
		<cfset application.appDir = getDirectoryFromPath(getCurrentTemplatePath()) />
		<cfset application.appPath = "/" />

	 	<!--- Execute the bean factory --->
		<cfset runFactory()>
	</cffunction>


	<cffunction name="setupSession" output="false">
	</cffunction>


	<cffunction name="setupRequest" output="false">
	</cffunction>


	<cffunction name="before" output="false">
	</cffunction>


	<cffunction name="onMissingView" output="false">
		<cfargument name="rc" type="struct">

		<!--- If a data key exists assume this is for ajax and render as json --->
		<cfif structKeyExists(rc,"data")>
			<cfset request.layout = false><!--- Turn off default layout --->
			<cfsetting showDebugOutput="No"><!--- Suppress debugging output on dev machines --->
			<cfreturn serializeJSON( rc.data )><!--- Convert data to json --->

		<!--- If stored in rc.json then assume its already in json format and just output it --->
		<cfelseif structKeyExists(rc,"json")>
			<cfset request.layout = false><!--- Turn off default layout --->
			<cfsetting showDebugOutput="No"><!--- Suppress debugging output on dev machines --->
			<cfreturn rc.json>

		<cfelse>
			<cfreturn view( 'main/pagenotfound' )><!--- Set view to the missing page message --->
		</cfif>
	</cffunction>


	<cffunction name="onError" output="true" returntype="void">
		<cfargument name="exception" required="true" type="any">
		<cfargument name="event" required="true" type="string">

		<!--- Log all errors in an application-specific log file. --->
		<cflog file="#This.Name#" type="error" text="Event Name: #event#" >
		<cflog file="#This.Name#" type="error" text="Message: #exception.cause.message#">

		<!--- Continue on to FW/1 error handling --->
		<cfset super.onError(exception,event)>
	</cffunction>


	<cffunction name="runFactory" access="public" output="false" returntype="void">
		<cfset var bf = "">
		<cfset var config = structnew()>

		<cfset config.constants.dsn = "dev_project">
		<cfset bf = createObject("component","libs.ioc").init("model",config)>

		<cfset setBeanFactory(bf)>
	</cffunction>

</cfcomponent>