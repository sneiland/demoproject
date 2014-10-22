<cfcomponent extends="controller" output="false">

	<cffunction name="default" access="public" output="false">
		<cfargument name="rc" required="true" type="struct">

		<cfset rc.filters = getService("servers").getFilters()>
	</cffunction>


	<cffunction name="grid" access="public" output="false">
		<cfargument name="rc" required="true" type="struct">

		<cfset var orderColIndex = 0>

		<cfparam name="rc.draw" default="1">
		<cfparam name="rc.start" default="0"><!--- Zero indexed start of grid page --->
		<cfparam name="rc.length" default="10"><!--- Number of records to display per page --->
		<cfparam name="rc.sortCol" default="">
		<cfparam name="rc.sortDir" default="asc">
		<cfparam name="rc.textSearch" default="">

		<cftry>
			<cfset orderColIndex = form["order[0][column]"]>
			<cfset rc.sortDir = form["order[0][dir]"]>
			<cfset rc.sortCol = form["columns[#orderColIndex#][data]"]>
			<cfcatch></cfcatch>
		</cftry>

		<cfset rc.json = getService("servers").getServersForGrid(
			  draw 			= rc.draw
			, start 		= rc.start
			, length 		= rc.length
			, sortcol 		= rc.sortcol
			, sortdir 		= rc.sortdir
			, textSearch	= rc.textSearch
		)>
	</cffunction>


	<cffunction name="server" access="public" output="false">
		<cfargument name="rc" required="true" type="struct">

		<cfset var optionStruct = structNew()>

		<cfparam name="rc.serverId" default="0">

		<cfset rc.server = getService("servers").getServerById(rc.serverId)>

		<cfset optionStruct = getService("servers").getServerOptions(rc.serverId)>
		<cfset rc.optionsTotal = optionStruct.total>
		<cfset rc.options = optionStruct.data>
	</cffunction>


	<cffunction name="printServer" access="public" output="false">
		<cfargument name="rc" required="true" type="struct">

		<cfset var optionStruct = structNew()>

		<cfparam name="rc.serverId" default="0">

		<cfset rc.server = getService("servers").getServerById(rc.serverId)>

		<cfset optionStruct = getService("servers").getServerOptions(rc.serverId)>
		<cfset rc.optionsTotal = optionStruct.total>
		<cfset rc.options = optionStruct.data>

		<cfset variables.fw.setLayout('pdf')>
	</cffunction>

</cfcomponent>