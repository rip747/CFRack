<!--- 
This middleware demostrates injecting header values
 --->
<cfcomponent output="false">

	<cffunction name="init">
		<cfargument name="app" type="any" required="true">
		<cfargument name="author" type="string" required="true">
		<cfargument name="poweredby" type="string" required="true">
		<cfset variables.app = arguments.app>
		<cfset variables.author = arguments.author>
		<cfset variables.poweredby = arguments.poweredby>
		<cfreturn this>
	</cffunction>
	
	<cffunction name="call">
		<cfargument name="env" type="struct" required="true">
		<cfset var loc = {}>

		<cfset loc.ret = variables.app.call(arguments.env)>
		
		<cfset loc.ret[2]["Author"] = variables.author>
		<cfset loc.ret[2]["X-Powered-By"] = variables.poweredby>
		
		<cfreturn loc.ret>
	</cffunction>

</cfcomponent>