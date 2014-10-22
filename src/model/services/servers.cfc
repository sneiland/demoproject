<cfcomponent output="false">

	<cfset variables.serversGateway = "">

	<!--- *** Initialization *** --->

	<cffunction name="init" access="public" output="false">
		<cfreturn this>
	</cffunction>

	<!--- *** Accessors / Mutators *** --->

	<cffunction name="getServersGateway" access="public" output="false">
		<cfreturn variables.serversGateway>
	</cffunction>


	<cffunction name="setServersGateway" access="public" output="false">
		<cfargument name="serversGateway">
		<cfset variables.serversGateway = arguments.serversGateway>
	</cffunction>


	<!--- *** Private Functions *** --->

	<cffunction name="queryToArray" access="private" output="false"  returntype="array">
		<cfargument name="q" type="query" required="yes" />
		<cfscript>
			var local = {};
			if (structKeyExists(server, "railo")) {
				local.Columns = listToArray(arguments.q.getColumnList(false));
			}
			else {
				local.Columns = arguments.q.getMetaData().getColumnLabels();
			}
			local.QueryArray = ArrayNew(1);
			for (local.RowIndex = 1; local.RowIndex <= arguments.q.RecordCount; local.RowIndex++){
				local.Row = {};
				local.numCols = ArrayLen( local.Columns );
				for (local.ColumnIndex = 1; local.ColumnIndex <= local.numCols; local.ColumnIndex++){
					local.ColumnName = local.Columns[ local.ColumnIndex ];
					local.Row[ local.ColumnName ] = arguments.q[ local.ColumnName ][ local.RowIndex ];
				}
				ArrayAppend( local.QueryArray, local.Row );
			}
			return( local.QueryArray );
		</cfscript>
	</cffunction>


	<cffunction name="serializeJsonNoPrefix" access="private" output="false" returntype="string">
		<cfargument name="data">

		<cfset var jsonString = "">
		<cfset var ctx = getPageContext().getFusionContext()>
		<cfset var isSecure = ctx.isSecureJSON()>

		<cfset ctx.setSecureJSON(false)>
		<cfset jsonString = serializeJson(data)>
		<cfset ctx.setSecureJSON(isSecure)>

		<cfreturn jsonString>
	</cffunction>

	<!--- *** Public Functions *** --->

	<cffunction name="getFilters" access="public" output="false">
		<cfparam name="session.servers.filters.textSearch" default="">

		<cfreturn session.servers.filters>
	</cffunction>


	<cffunction name="getServerById" access="public" output="false">
		<cfreturn getServersGateway().getServerById(argumentCollection=arguments)>
	</cffunction>


	<cffunction name="getServerOptions" access="public" output="false">
		<cfset var data = getServersGateway().getServerOptions(argumentCollection=arguments)>
		<cfset var returnStruct = structNew()>
		<cfset var subTotal = 0>
		<cfset var unitPrice = 0>

		<cfset returnStruct.total = 0>
		<cfset returnStruct.data = "">

		<cfset queryAddColumn(data, "subTotal", ArrayNew(1)) />
		<cfset queryAddColumn(data, "unitPrice", ArrayNew(1)) />

		<!--- Generate computed columns --->
		<cfloop query="data">
			<cfset subTotal = data.optionPrice * data.quantity>

			<cfset querySetCell(
				data
				,"subTotal"
				,subTotal
				,data.CurrentRow
			)/>

			<cfset returnStruct.total = returnStruct.total + subTotal>
		</cfloop>

		<cfset returnStruct.data = data>

		<cfreturn returnStruct>
	</cffunction>


	<cffunction name="getServersForGrid" access="public" output="false" returntype="string" hint="Returns a json string for return to the datatables grid">
		<cfargument name="draw" 				required="true" type="string" hint="Echo this back to the grid for syncing">
		<cfargument name="start" 				required="true" type="numeric" hint="First row to display">
		<cfargument name="length" 				required="true" type="numeric">
		<cfargument name="sortcol" 				required="true" type="string">
		<cfargument name="sortdir" 				required="true" type="string">
		<cfargument name="textSearch" 			required="false" type="string" default="">

		<cfset var jsonString = "">
		<cfset var returnStruct = structNew()>
		<cfset var startRow = arguments.start + 1>
		<cfset var endRow = startRow + arguments.length - 1>

		<cfset var data = getServersGateway().getServers_paged(
			  startRow			= startRow
			, endRow			= endRow
			, sortCol			= arguments.sortCol
			, sortDir			= arguments.sortDir
			, getCount 			= 0
			, textSearch		= arguments.textSearch
		)>

		<cfset var totalUnfiltered = getServersGateway().getServers_paged(
			  getCount 			= 1
		)>

		<cfset var totalFiltered = getServersGateway().getServers_paged(
			getCount 			= 1
			, textSearch		= arguments.textSearch
		)>

		<!--- Update filters session --->
		<cfset session.servers.filters.textSearch = arguments.textsearch>

		<cfset returnStruct["draw"] = arguments.draw>
		<cfset returnStruct["recordsTotal"] = totalUnfiltered.totalrows>
		<cfset returnStruct["recordsFiltered"] = totalFiltered.totalrows>
		<cfset returnStruct["data"] = queryToArray(data)>

		<cfif structKeyExists(server, "railo")>
			<cfreturn serializeJson( returnStruct )>
		<cfelse>
			<cfreturn serializeJsonNoPrefix( returnStruct )>
		</cfif>
	</cffunction>

</cfcomponent>