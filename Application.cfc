<cfcomponent output="false">
	
	<cfset this.name = "CFRack">
	
	<cffunction name="onApplicationStart" returnType="boolean" output="false">
		<cfset application.CFRack = createObject("component", "CFRack").init()>
		<cfset application.CFRack.use("middleware.RequestTimer")>
		<cfset application.CFRack.use("middleware.ParamsScope")>
		<cfset application.CFRack.use(middleware="middleware.HeaderInjection", author="Tony Petruzzi", poweredby="CFWheels 1.1.3")>
		<cfset application.CFRack.use("middleware.RequestHandler")>
		<cfset application.CFRack.build()>
		<cfreturn true>
	</cffunction>
	
	<!--- Run before the request is processed --->
	<cffunction name="onRequestStart" returnType="boolean" output="false">
		<cfargument name="thePage" type="string" required="true">
		<cfif StructKeyExists(url, "reinit")>
			<cfset onApplicationStart()>
		</cfif>
		<cfreturn true>
	</cffunction>

	<cffunction name="onRequest" returnType="void">
		<cfargument name="thePage" type="string" required="true">
		<cfoutput>#application.CFRack.run()#</cfoutput>
	</cffunction>

</cfcomponent>