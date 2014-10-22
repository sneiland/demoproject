<cfcomponent accessors="true" displayname="Servers Gateway" extends="gateway" output="false">

	<!--- *** Private Functions *** --->

	<!--- *** Public Functions *** --->

	<cffunction name="getServerById" access="public" output="false" returntype="query" hint="Gets a single server">
		<cfargument name="serverId"	required="true" type="numeric">

		<cfset var qryGetServerById = "">

		<cfquery name="qryGetServerById" datasource="#getDSN()#">
			SELECT
				  s1.Id
				  , s1.serverName
				  , s1.clientName
				  , s1.serverType
				  , s1.billable
				  , s1.price
			FROM
				dbo.server AS s1
			WHERE
				s1.id = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.serverId#">
		</cfquery>

		<cfreturn qryGetServerById>
	</cffunction>


	<cffunction name="getServerOptions" access="public" output="false" returntype="query" hint="Gets the currently selected options for a server">
		<cfargument name="serverId"	required="true" type="numeric">

		<cfset var qryGetServerOptions = "">

		<cfquery name="qryGetServerOptions" datasource="#getDSN()#">
			SELECT
				 o1.quantity
				 , o2.optionName
				 , o2.optionPrice
			FROM
				dbo.server_option AS o1
			INNER JOIN
				dbo.[option] AS o2 ON
					o1.optionId = o2.id
			WHERE
				o1.serverId = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.serverId#">
		</cfquery>

		<cfreturn qryGetServerOptions>
	</cffunction>


	<cffunction name="getServers_paged" access="public" output="false" returntype="query" hint="Gets servers in a paged form">
		<cfargument name="startRow" 		required="false" type="numeric" default="1">
		<cfargument name="endRow" 			required="false" type="numeric" default="15">
		<cfargument name="sortCol" 			required="false" type="string" default="priority">
		<cfargument name="sortDir" 			required="false" type="string" default="ASC">
		<cfargument name="getCount" 		required="true" type="boolean">
		<cfargument name="textSearch" 		required="false" type="string" default="">

		<cfset var qryGetServersPaged = "">

		<cfquery name="qryGetServersPaged" datasource="#getDSN()#">
			<cfif arguments.getcount>
				SELECT
					COUNT(*) as totalRows

			<cfelse>
				SELECT
					x2.*
				FROM (
					SELECT
						x1.*
						,ROW_NUMBER() OVER(
							ORDER BY
								<cfswitch expression="#arguments.sortCol#">
									<cfcase value="serverName">serverName</cfcase>
									<cfcase value="clientName">clientName</cfcase>
									<cfcase value="serverType">serverType</cfcase>
									<cfcase value="billable">billable</cfcase>
									<cfcase value="basePrice">basePrice</cfcase>
									<cfcase value="totalPrice">totalPrice</cfcase>
									<cfdefaultcase>Id</cfdefaultcase>
								</cfswitch>

								<cfif arguments.sortDir EQ "DESC">DESC<cfelse>ASC</cfif>
						) AS rowNumber
					FROM (
						SELECT
							x0.Id
							, x0.serverName
							, x0.clientName
							, x0.serverType
							, x0.billable
							, x0.basePrice
							, CASE
								WHEN x0.optionsTotal IS NOT NULL THEN x0.optionsTotal
								ELSE 0
							  END AS optionsTotal
							, CASE
								WHEN x0.optionsTotal IS NOT NULL THEN x0.optionsTotal + x0.basePrice
								ELSE x0.basePrice
							  END AS totalPrice
						FROM (
							SELECT
								  s1.Id
								  , s1.serverName
								  , s1.clientName
								  , s1.serverType
								  , s1.billable
								  , s1.price AS basePrice
								  ,(
									SELECT
										 sum(o1.quantity * o2.optionPrice) as optionsTotal
									FROM
										dbo.server_option AS o1
									INNER JOIN
										dbo.[option] AS o2 ON
											o1.optionId = o2.id
									WHERE
										o1.serverId = s1.id
								)  as optionsTotal
				</cfif>

						FROM
							dbo.server AS s1

						<cfif len(trim(arguments.textSearch))>
							WHERE
								serverName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.textSearch#%">
								OR clientName LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.textSearch#%">
								OR serverType LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#arguments.textSearch#%">
						</cfif>
			<cfif NOT arguments.getcount>
						) AS x0
					) AS x1
				) AS x2
				WHERE
					rowNumber BETWEEN <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.startRow#"> AND <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.endRow#">
			</cfif>
		</cfquery>

		<cfreturn qryGetServersPaged>
	</cffunction>

</cfcomponent>