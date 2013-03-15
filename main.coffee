((window, document) ->
	off if window.Plati?

	P = {}

	P.el =
		head: null
		body: null
		widget: null
		
	P.opts =
		ids: 42590
		host: '//plati.ru'
		widgetId: 'plati-ru'
		css: '/test/css/default/main.css'
		tmpl: '/test/tmpl/default.js'
		loader: '/test/img/loader.gif'
		hashPrefix: '#!plati'

	P.util =
		extend:	(target, source, overwrite) ->
			for key of source
				target[key] = source[key] if overwrite or typeof target[key] is 'object'
				
			target

		getUID: ->
			id = 1
			() ->
				id++

	P.dom =
		$: (selector) ->
			off if not selector?

			type = selector.substring(0, 1)
			name = selector.substring(1)

			switch type
				when '#'
					document.getElementById(name)
				when '.'
					document.getElementsByClassName(name)
				else
					document.getElementsByTagName(selector)
			
		addEvent: (el, event, callback) ->
			return off if not el?

			if el.attachEvent
				el.attachEvent('on' + event, callback)
			else if el.addEventListener
				el.addEventListener(event, callback, false)

		removeEvent: (el, event, callback) ->
			return off if not el?

			if el.detachEvent
				el.detachEvent("on#{type}", callback)
			else if el.removeEventListener
				el.removeEventListener(event, callback, false)

		waitFor: (prop, func, self, count) ->
			if prop
				func.apply(self)
			else
				count = count or 0

			if count < 1000
				setTimeout(->
					waitFor(prop, func, self, count + 1)
				, 0)
				
		getStyle: (url) ->
			link = document.createElement('link')
			link.type = 'text/css'
			link.rel = 'stylesheet'
			link.href = url			

			P.el.head.appendChild(link)
			
			return
		
		# jQuery.getScript
		getScript: (url, onLoad) ->			
			script = document.createElement('script')
			script.type = 'text/javascript'
			script.src = url
			script.setAttribute('encoding', 'UTF-8')
			
			done = no
			script.onload = script.onreadystatechange = () ->
				if ( not done and (not this.readyState or this.readyState is 'loaded' or this.readyState is 'complete') )
					done = yes

					# Handle memory leak in IE
					script.onload = script.onreadystatechange = null;
					
					P.el.head.removeChild(script) if P.el.head and script.parentNode
					
					onLoad() if onLoad?
				return

			P.el.head.appendChild(script)
			
			return
			
	P.pages =
		articles:
			route: "#{P.opts.hashPrefix}/articles(/:page)"
			enter: ->
				alert(1)
			to: () ->
				alert(0)
				page = this.params['page'] or 0
			render: ->
				articles = [
					id: 980859
					codepage: 0
					currency: 'WMZ'
					title: 'Номер ICQ 121413515'
					cost: 1500
				,
					id: 980859
					codepage: 0
					currency: 'WMZ'
					title: 'Номер ICQ 121413515'
					cost: 2000
				]
				for article in articles
					article.url = "#{P.opts.hashPrefix}/detail?id=#{article.id}&codepage=#{article.codepage}&currency=#{article.currency}"
					out += P.tmpl(P.tmpls.article, article)
					
				P.el.widget.innerHTML = P.tmpl(P.tmpls.articles,
					out: out
				)
				
				return
				
		article: ->
			route: "#{P.opts.hashPrefix}/:(/:page)"
			to: ->
				page = this.params['page'] or 0
			
	P.init = ->		
		P.el.head = P.dom.$('head')[0] || document.documentElement
		P.el.body = P.dom.$('body')[0] || document.documentElement
		P.el.widget = P.dom.$("##{P.opts.widgetId}")
		
		P.el.widget.innerHTML = '<img src="' + P.opts.host + P.opts.loader + '" style="plati-ru-loader" alt="" />'
		
		P.dom.getStyle(P.opts.host + P.opts.css + '?' + Math.random())
		P.dom.getScript(P.opts.host + P.opts.tmpl + '?' + Math.random(), ->
			for name, page of P.pages
				continue unless page.route
				
				ref = P.path.map(page.route)
				ref.to(page.to) if page.to
				ref.enter(page.enter) if page.enter
				
				ref.enter(->
					alert(2)
				)
				

			P.path.listen()	

			return
		)
		
		
		return
		

	# https://github.com/mtrpcic/pathjs
	P.path = ( ->
		`Path={version:"0.8.4",map:function(a){if(Path.routes.defined.hasOwnProperty(a)){return Path.routes.defined[a]}else{return new Path.core.route(a)}},root:function(a){Path.routes.root=a},rescue:function(a){Path.routes.rescue=a},history:{initial:{},pushState:function(a,b,c){if(Path.history.supported){if(Path.dispatch(c)){history.pushState(a,b,c)}}else{if(Path.history.fallback){window.location.hash="#"+c}}},popState:function(a){var b=!Path.history.initial.popped&&location.href==Path.history.initial.URL;Path.history.initial.popped=true;if(b)return;Path.dispatch(document.location.pathname)},listen:function(a){Path.history.supported=!!(window.history&&window.history.pushState);Path.history.fallback=a;if(Path.history.supported){Path.history.initial.popped="state"in window.history,Path.history.initial.URL=location.href;window.onpopstate=Path.history.popState}else{if(Path.history.fallback){for(route in Path.routes.defined){if(route.charAt(0)!="#"){Path.routes.defined["#"+route]=Path.routes.defined[route];Path.routes.defined["#"+route].path="#"+route}}Path.listen()}}}},match:function(a,b){var c={},d=null,e,f,g,h,i;for(d in Path.routes.defined){if(d!==null&&d!==undefined){d=Path.routes.defined[d];e=d.partition();for(h=0;h<e.length;h++){f=e[h];i=a;if(f.search(/:/)>0){for(g=0;g<f.split("/").length;g++){if(g<i.split("/").length&&f.split("/")[g].charAt(0)===":"){c[f.split("/")[g].replace(/:/,"")]=i.split("/")[g];i=i.replace(i.split("/")[g],f.split("/")[g])}}}if(f===i){if(b){d.params=c}return d}}}}return null},dispatch:function(a){var b,c;if(Path.routes.current!==a){Path.routes.previous=Path.routes.current;Path.routes.current=a;c=Path.match(a,true);if(Path.routes.previous){b=Path.match(Path.routes.previous);if(b!==null&&b.do_exit!==null){b.do_exit()}}if(c!==null){c.run();return true}else{if(Path.routes.rescue!==null){Path.routes.rescue()}}}},listen:function(){var a=function(){Path.dispatch(location.hash)};if(location.hash===""){if(Path.routes.root!==null){location.hash=Path.routes.root}}if("onhashchange"in window&&(!document.documentMode||document.documentMode>=8)){window.onhashchange=a}else{setInterval(a,50)}if(location.hash!==""){Path.dispatch(location.hash)}},core:{route:function(a){this.path=a;this.action=null;this.do_enter=[];this.do_exit=null;this.params={};Path.routes.defined[a]=this}},routes:{current:null,root:null,rescue:null,previous:null,defined:{}}};Path.core.route.prototype={to:function(a){this.action=a;return this},enter:function(a){if(a instanceof Array){this.do_enter=this.do_enter.concat(a)}else{this.do_enter.push(a)}return this},exit:function(a){this.do_exit=a;return this},partition:function(){var a=[],b=[],c=/\(([^}]+?)\)/g,d,e;while(d=c.exec(this.path)){a.push(d[1])}b.push(this.path.split("(")[0]);for(e=0;e<a.length;e++){b.push(b[b.length-1]+a[e])}return b},run:function(){var a=false,b,c,d;if(Path.routes.defined[this.path].hasOwnProperty("do_enter")){if(Path.routes.defined[this.path].do_enter.length>0){for(b=0;b<Path.routes.defined[this.path].do_enter.length;b++){c=Path.routes.defined[this.path].do_enter[b]();if(c===false){a=true;break}}}}if(!a){Path.routes.defined[this.path].action()}}}`

		Path
	)()


	# https://github.com/IntoMethod/Lightweight-JSONP
	# Lightweight JSONP fetcher
	# Copyright 2010-2012 Erik Karlsson. All rights reserved.
	# BSD licensed
	P.JSONP = `(function(){
		var counter = 0, head, window = this, config = {};
		function load(url, pfnError) {
			var script = document.createElement('script'),
				done = false;
			script.src = url;
			script.async = true;
	 
			var errorHandler = pfnError || config.error;
			if ( typeof errorHandler === 'function' ) {
				script.onerror = function(ex){
					errorHandler({url: url, event: ex});
				};
			}
			
			script.onload = script.onreadystatechange = function() {
				if ( !done && (!this.readyState || this.readyState === "loaded" || this.readyState === "complete") ) {
					done = true;
					script.onload = script.onreadystatechange = null;
					if ( script && script.parentNode ) {
						script.parentNode.removeChild( script );
					}
				}
			};
			
			if ( !head ) {
				head = document.getElementsByTagName('head')[0];
			}
			head.appendChild( script );
		}
		function encode(str) {
			return encodeURIComponent(str);
		}
		function jsonp(url, params, callback, callbackName) {
			var query = (url||'').indexOf('?') === -1 ? '?' : '&', key;
					
			callbackName = (callbackName||config['callbackName']||'callback');
			var uniqueName = callbackName + "_json" + (++counter);
			
			params = params || {};
			for ( key in params ) {
				if ( params.hasOwnProperty(key) ) {
					query += encode(key) + "=" + encode(params[key]) + "&";
				}
			}	
			
			window[ uniqueName ] = function(data){
				callback(data);
				try {
					delete window[ uniqueName ];
				} catch (e) {}
				window[ uniqueName ] = null;
			};
	 
			load(url + query + callbackName + '=' + uniqueName);
			return uniqueName;
		}
		function setDefaults(obj){
			config = obj;
		}
		return {
			get:jsonp,
			init:setDefaults
		};
	})();`


	# http://documentcloud.github.com/underscore/
	P.tmpl = `function(text, data) {
		settings = {
			evaluate		: /<\?([\s\S]+?)\?>/g,
			interpolate : /<\?=([\s\S]+?)\?>/g,
			escape			: /<\?-([\s\S]+?)\?>/g
		};

		// Combine delimiters into one regular expression via alternation.
		var noMatch = /(.)^/;
		var matcher = new RegExp([
			(settings.escape || noMatch).source,
			(settings.interpolate || noMatch).source,
			(settings.evaluate || noMatch).source
		].join('|') + '|$', 'g');

		// Compile the template source, escaping string literals appropriately.
		var index = 0,
			source = "__p+='",
			escaper = /\\|'|\r|\n|\t|\u2028|\u2029/g,
			escapes = {
				"'":			"'",
				'\\':		 '\\',
				'\r':		 'r',
				'\n':		 'n',
				'\t':		 't',
				'\u2028': 'u2028',
				'\u2029': 'u2029'
			};

		text.replace(matcher, function(match, escape, interpolate, evaluate, offset) {
			source += text.slice(index, offset)
				.replace(escaper, function(match) {
					return '\\' + escapes[match];
				});

			/* todo: _.escape переделать */
			source +=
				escape ? "'+\n((__t=(" + escape + "))==null?'':_.escape(__t))+\n'" :
				interpolate ? "'+\n((__t=(" + interpolate + "))==null?'':__t)+\n'" :
				evaluate ? "';\n" + evaluate + "\n__p+='" : '';

			index = offset + match.length;
		});

		source += "';\n";

		// If a variable is not specified, place data values in local scope.
		if (!settings.variable) {
			source = 'with(obj||{}){\n' + source + '}\n';
		}

		source = "var __t,__p='',__j=Array.prototype.join," +
			"print=function(){__p+=__j.call(arguments,'');};\n" +
			source + "return __p;\n";

		try {
			var render = new Function(settings.variable || 'obj', /*'_', */source);
		} catch (e) {
			e.source = source;
			throw e;
		}

		if (data) {
			return render(data/*, _*/);
		}

		var template = function(data) {
			return render.call(this, data/*, _*/);
		};

		// Provide the compiled function source as a convenience for precompilation.
		template.source = 'function(' + (settings.variable || 'obj') + '){\n' + source + '}';

		return template;
	};`
	
	# alias
	window.Plati = P
	
	P.dom.addEvent(window, 'load', P.init);

	return

) window, document