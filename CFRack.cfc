<cfcomponent output="false">

	<!--- array to hold middleware --->
	<cfset variables.MIDDLEWARE = []>

	<cffunction name="init">
		<cfreturn this>
	</cffunction>
	
	<cffunction name="use">
		<cfargument name="middleware" type="string" required="true">
		<cfset arrayAppend(variables.MIDDLEWARE, arguments)>
	</cffunction>
	
	<cffunction name="build">
		<cfset var loc = {}>
		
		<!--- reverse the order of the middleware --->
		<cfset loc.middlewares = []>
		<cfset loc.middlewareLen = arrayLen(variables.MIDDLEWARE)>
		<cfloop from="#loc.middlewareLen#" to="1" index="loc.iMiddleware" step="-1">
			<cfset arrayAppend(loc.middlewares, variables.MIDDLEWARE[loc.iMiddleware])>
		</cfloop>

		<!--- build the chain of middlewares --->
		<cfset loc.previous = "">
		<cfset loc.middlewareLen = arrayLen(variables.MIDDLEWARE)>
		<cfloop from="1" to="#loc.middlewareLen#" index="loc.iMiddleware">
			<cfset loc.args = loc.middlewares[loc.iMiddleware]>
			<cfset loc.middleware = loc.args["middleware"]>
			<cfset StructDelete(loc.args, "middleware", false)>
			<cfset loc.args["app"] = loc.previous>
			<cfset loc.middlewares[loc.iMiddleware] = createObject("component", loc.middleware).init(argumentCollection=loc.args)>
			<cfset loc.previous = loc.middlewares[loc.iMiddleware]>
		</cfloop>

		<!--- reset the stack into the original order --->		
		<cfset variables.MIDDLEWARE = []>
		<cfset loc.middlewareLen = arrayLen(loc.middlewares)>
		<cfloop from="#loc.middlewareLen#" to="1" index="loc.iMiddleware" step="-1">
			<cfset arrayAppend(variables.MIDDLEWARE, loc.middlewares[loc.iMiddleware])>
		</cfloop>
	</cffunction>
	
	<cffunction name="run">
		<cfset var loc = {}>
		
		<!--- build the environment --->
		<cfset loc.ENV = buildEnv()>
		
		<!--- execute the chain --->
		<cfset loc.ret = variables.MIDDLEWARE[1].call(loc.ENV)>
		
		<!--- break out the parts of the returning array  --->
		<cfset loc.statusCode = loc.ret[1]>
		<cfset loc.headers = loc.ret[2]>
		<cfset loc.content = ArrayToList(loc.ret[3], "")>
		
		<!--- send the status code --->
		<cfheader statuscode="#loc.statusCode#">
		
		<!--- send the headers --->
		<cfloop collection="#loc.headers#" item="loc.iHeader">
			<cfheader name="#loc.iHeader#" value="#loc.headers[loc.iHeader]#">
		</cfloop>

		<!--- return the content --->
		<cfreturn loc.content>
	</cffunction>
	
	<cffunction name="buildEnv" access="private">
		<cfset var env = {}>
		
		<!--- append cgi scope --->
		<cfset structAppend(env, cgi)>
		
		<!--- assign request scope --->
		<cfset env["request.vars"] = request>
		
		<!--- assign form scope --->
		<cfset env["request.post"] = form>
		
		<!--- assign url scope --->
		<cfset env["request.get"] = url>
		
		<!--- assign cookie scope --->
		<cfset env["cookies"] = cookie>
		
		<!--- assign server scope --->
		<cfset env["server"] = server>
		
		<!--- request method --->
		<cfset env["request.method"] = cgi.REQUEST_METHOD>
		
		<cfreturn env>
	</cffunction>

</cfcomponent>