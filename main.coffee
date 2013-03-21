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
				
		getPopupParams: (width, height) ->
			screenX = if typeof window.screenX isnt 'undefined' then window.screenX else window.screenLeft
			screenY = if typeof window.screenY isnt 'undefined' then window.screenY else window.screenTop
			outerWidth = if typeof window.outerWidth isnt 'undefined' then window.outerWidth else document.body.clientWidth
			outerHeight = if typeof window.outerHeight isnt 'undefined' then window.outerHeight else (document.body.clientHeight - 22)
			left = parseInt(screenX + ((outerWidth - width) / 2), 10)
			top = parseInt(screenY + ((outerHeight - height) / 2.5), 10)

			return "scrollbars=1, resizable=1, menubar=0, left=#{left}, top=#{top}, width=#{width}, height=#{height}, toolbar=0, status=0";


	P.dom =
		$: (selector, context, tagName) ->
			off if not selector?

			type = selector.substring(0, 1)
			name = selector.substring(1)

			switch type
				when '#'
					document.getElementById(name)
				when '.'
					tagName = tagName ? tagName : '*'
					
					`if ('function' !== typeof document.getElementsByClassName) {
						for (
							var i = -1,
								results = [ ],
								finder = new RegExp('(?:^|\\s)' + name + '(?:\\s|$)'),
								a = context && context.getElementsByTagName && context.getElementsByTagName(tagName) || document.all || document.getElementsByTagName(tagName),
								l = a.length;
							++i < l;
							finder.test(a[i].className) && results.push(a[i])
						);

						a = null;

						return results;
					} else {
						return (context || document).getElementsByClassName(name);
					}`
					
					return					
				else
					(context || document).getElementsByTagName(selector)
			
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
			
		addClass: (els, c) ->
			if not els.length
				els = [els]
			
			re = new RegExp('(^|\\s)' + c + '(\\s|$)', 'g')
			
			for el in els
				continue if re.test(el.className)
				el.className = (el.className + ' ' + c).replace(/\s+/g, ' ').replace(/(^ | $)/g, '')
			
			return els
		
		removeClass: (els, c) ->
			if not els.length
				els = [els]
			
			re = new RegExp("(^|\\s)" + c + "(\\s|$)", "g")
			for el in els
				el.className = el.className.replace(re, "$1").replace(/\s+/g, " ").replace(/(^ | $)/g, "")
			
			return els
		  
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
			
	P.widget =
		main:
			el: null
		search:
			el: null
			init: (el) ->
				@el = el
				
				input = P.dom.$('.plati-search-input', @el, 'input')[0]
				go = P.dom.$('.plati-search-go', @el, 'a')[0]
				
				P.dom.addEvent(go, 'click', (e) ->
					if e.preventDefault then e.preventDefault() else e.returnValue = false
					
					window.location.hash = "#{P.opts.hashPrefix}/search?s=" + input.value
					
					return
				)
				
				return
		category:
			el: null
			init: (el) ->
				@el = el
				
				P.JSONP.init(
					callbackName: 'P.jsonpCallback'
				)
				
				# P.jsonpCallback = ->					
				
				P.JSONP.get('http://shop.digiseller.ru/xml/test_JSON_shop_sections.asp',
					param1: 'a'
					param2: 'b'
				, (response) ->
					console.log(response);
				)
				# /* , "overrideCallbackName" */
				
				categories = [
					id: 1
					name: '1 category'
				,
					id: 2
					name: '2 category'
					sub: [
						id: 4
						name: '4 category'
						sub: [
							id: 6
							name: '6 category'
						,
							id: 7
							name: '7 category'
						]
					]
				,
					id: 3
					name: '3 category'
					sub: [
						id: 5
						name: '5 category'
					]
				]				

				@el.innerHTML = @render(categories)
				@mark()
				
				return
			mark: (cid) ->				
				subs = P.dom.$('.plati-categories', @el, 'ul')				
				for sub in subs
					sub.style.display = 'none'
				
				subs[0].style.display = ''
				
				cats = P.dom.$('.plati-category', @el, 'ul')
				P.dom.removeClass(cats, 'plati-category-choosed')
				
				return unless cid
				
				cat = P.dom.$("#plati-category-#{cid}")
				P.dom.addClass(cat, 'plati-category-choosed')
				
				parent = cat
				while parent.id isnt 'plati-category'
					parent.style.display = ''
					parent = parent.parentNode					
				
				P.dom.$("#plati-category-sub-#{cid}")?.style.display = ''
					
				return
				
			render: (categories, parent_cid) ->
				return '' if not categories
			
				out = ''
				for category in categories
					category.url = "#{P.opts.hashPrefix}/articles/#{category.id}"
					category.sub = @render(category.sub, category.id)
					category.id = "plati-category-#{category.id}"
					
					out += P.tmpl(P.tmpls.category, category)
					
				P.tmpl(P.tmpls.categories,
					id: if parent_cid then "plati-category-sub-#{parent_cid}" else ''
					out: out
				)
		
	P.route =
		home:
			url: '/home'
			action: (params) ->	
				P.widget.category.mark()
				P.widget.main.el.innerHTML = 'Выберите категорию'
				P.widget.category.el.style.display = ''
				
				return
				
		search:
			url: '/search\\?s=(.*)'
			action: (params) ->
				search = params[1]
				
				P.widget.category.mark()
				
				P.widget.main.el.innerHTML = '<h2>Резльтутаты поиска по запросу "' + search + '"</h2>'
				
				return

		articles:
			url: '/articles/([0-9]*)(?:/([0-9]*))?'			
			action: (params) ->
				cid = params[1]
				page = parseInt(params[2]) or 0
				
				P.widget.category.mark(cid)
				
				@render([
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
				], cid, page)
				
				@pagerMark(cid, page)
				
				return
				
			pagerMark: (cid, curPage) ->
				pager = P.dom.$("#plati-pager-#{cid}")				
				pages = P.dom.$('a', pager)				
				
				for page, index in pages
					P.dom[if curPage is index then 'addClass' else 'removeClass'](page, 'plati-page-choosed')
			
				return
				
			pagerRender: (cid, curPage, total) ->
				out = ''
				page = 0
				
				pager = P.dom.$("#plati-pager-#{cid}")
				
				unless total
					pager.display = 'none'
					return
				
				while page <= total
					out += P.tmpl(P.tmpls.page,
						page: page + 1
						url: "#{P.opts.hashPrefix}/articles/#{cid}/#{page}"
					)
					
					page++
					
				pager.innerHTML = P.tmpl(P.tmpls.pages,
					out: out
				)
				
				return
				
			render: (articles, cid, page) ->
				out = ''
				for article in articles
					article.title = cid + ' - ' + page + ' - ' + article.title
					article.url = "#{P.opts.hashPrefix}/detail/#{article.id}"
					out += P.tmpl(P.tmpls.article, article)
				
				container = P.dom.$("#plati-articles-#{cid}")
				
				if container
					container.innerHTML = out
				else
					P.widget.main.el.innerHTML = P.tmpl(P.tmpls.articles,
						id: "plati-articles-#{cid}"
						idPages: "plati-pager-#{cid}"
						out: out
					)
					
					@pagerRender(cid, page, 10)
				
				return

		article:
			url: '/detail(?:/([0-9]*))'
			action: (params) ->
				id = params[1] or 0
				
				@render(
					id: id
					currency: 'WMZ'
					header: 'Номер ICQ 121413515'
					description: 'Описалово крутого товара'
					cost: 1500
				)
				
				P.dom.addEvent(P.dom.$('.plati-article-buy', P.widget.main.el, 'a')[0], 'click', (e) ->
					if e.preventDefault then e.preventDefault() else e.returnValue = false
					
					window.open('//plati.ru', 'plati', P.util.getPopupParams(670, 500))
					
					return
				)
				
				P.widget.category.mark(7)
				
				return
				
			render: (article) ->
				out = ''

				P.widget.main.el.innerHTML = P.tmpl(P.tmpls.articleDetail, article)
				
				return
	inited = no
	P.init = ->
		off if inited
		inited = yes
		
		P.el.head = P.dom.$('head')[0] || document.documentElement
		P.el.body = P.dom.$('body')[0] || document.documentElement
		P.el.shop = P.dom.$("##{P.opts.widgetId}")
		
		P.el.shop.innerHTML = '<img src="' + P.opts.host + P.opts.loader + '" style="plati-loader" alt="" />'
		
		P.dom.getStyle(P.opts.host + P.opts.css + '?' + Math.random())
		P.dom.getScript(P.opts.host + P.opts.tmpl + '?' + Math.random(), ->			
			P.el.shop.innerHTML = P.tmpl(P.tmpls.main, {})
			
			P.widget.main.el = P.dom.$('#plati-main')
			P.widget.category.init(P.dom.$('#plati-category'))
			P.widget.search.init(P.dom.$('#plati-search'))

			for name, route of P.route
				continue unless route.url or route.action				
				((route) ->					
					P.historyClick.addRoute(P.opts.hashPrefix + route.url, (params) ->
						route.action(params)
					)
				)(route)
			
			P.historyClick.rootAlias(P.opts.hashPrefix + '/home');			
			P.historyClick.start()
			
			if window.location.hash is ''		
                P.historyClick.reload()            

			return
		)

		return
		

	# https://github.com/mtrpcic/pathjs
	`Path={version:"0.8.4",map:function(a){if(Path.routes.defined.hasOwnProperty(a)){return Path.routes.defined[a]}else{return new Path.core.route(a)}},root:function(a){Path.routes.root=a},rescue:function(a){Path.routes.rescue=a},history:{initial:{},pushState:function(a,b,c){if(Path.history.supported){if(Path.dispatch(c)){history.pushState(a,b,c)}}else{if(Path.history.fallback){window.location.hash="#"+c}}},popState:function(a){var b=!Path.history.initial.popped&&location.href==Path.history.initial.URL;Path.history.initial.popped=true;if(b)return;Path.dispatch(document.location.pathname)},listen:function(a){Path.history.supported=!!(window.history&&window.history.pushState);Path.history.fallback=a;if(Path.history.supported){Path.history.initial.popped="state"in window.history,Path.history.initial.URL=location.href;window.onpopstate=Path.history.popState}else{if(Path.history.fallback){for(route in Path.routes.defined){if(route.charAt(0)!="#"){Path.routes.defined["#"+route]=Path.routes.defined[route];Path.routes.defined["#"+route].path="#"+route}}Path.listen()}}}},match:function(a,b){var c={},d=null,e,f,g,h,i;for(d in Path.routes.defined){if(d!==null&&d!==undefined){d=Path.routes.defined[d];e=d.partition();for(h=0;h<e.length;h++){f=e[h];i=a;if(f.search(/:/)>0){for(g=0;g<f.split("/").length;g++){if(g<i.split("/").length&&f.split("/")[g].charAt(0)===":"){c[f.split("/")[g].replace(/:/,"")]=i.split("/")[g];i=i.replace(i.split("/")[g],f.split("/")[g])}}}if(f===i){if(b){d.params=c}return d}}}}return null},dispatch:function(a){var b,c;if(Path.routes.current!==a){Path.routes.previous=Path.routes.current;Path.routes.current=a;c=Path.match(a,true);if(Path.routes.previous){b=Path.match(Path.routes.previous);if(b!==null&&b.do_exit!==null){b.do_exit()}}if(c!==null){c.run();return true}else{if(Path.routes.rescue!==null){Path.routes.rescue()}}}},listen:function(){var a=function(){Path.dispatch(location.hash)};if(location.hash===""){if(Path.routes.root!==null){location.hash=Path.routes.root}}if("onhashchange"in window&&(!document.documentMode||document.documentMode>=8)){window.onhashchange=a}else{setInterval(a,50)}if(location.hash!==""){Path.dispatch(location.hash)}},core:{route:function(a){this.path=a;this.action=null;this.do_enter=[];this.do_exit=null;this.params={};Path.routes.defined[a]=this}},routes:{current:null,root:null,rescue:null,previous:null,defined:{}}};Path.core.route.prototype={to:function(a){this.action=a;return this},enter:function(a){if(a instanceof Array){this.do_enter=this.do_enter.concat(a)}else{this.do_enter.push(a)}return this},exit:function(a){this.do_exit=a;return this},partition:function(){var a=[],b=[],c=/\(([^}]+?)\)/g,d,e;while(d=c.exec(this.path)){a.push(d[1])}b.push(this.path.split("(")[0]);for(e=0;e<a.length;e++){b.push(b[b.length-1]+a[e])}return b},run:function(){var a=false,b,c,d;if(Path.routes.defined[this.path].hasOwnProperty("do_enter")){if(Path.routes.defined[this.path].do_enter.length>0){for(b=0;b<Path.routes.defined[this.path].do_enter.length;b++){c=Path.routes.defined[this.path].do_enter[b]();if(c===false){a=true;break}}}}if(!a){Path.routes.defined[this.path].action()}}}`

	P.Path = Path
	
	
	
	P.historyClick = `(function() {
		var queueLinks = [],
			virtualLinks = {},
			counter = 0,
			rootAlias = '',
			needReload = false,
			routes = [],
			revRoutes = [],
			opts;

		function init() {
			if (!historyClick.interval) {
				historyClick.interval = setInterval(urlHashCheck, 100);
			}
		}

		function urlHashCheck() {
			var mayChangeReload = false; // needReload может обнулиться так как urlHashCheck может еще не закончиться а needReload уже поставили true
			
			if (needReload) {
				mayChangeReload = true;
			}

			if (window.location.hash !== historyClick.currentHash || needReload) {
				historyClick.prevHash = ( needReload ? historyClick.prevHash : historyClick.currentHash );
				historyClick.currentHash = window.location.hash.toString();

				go(historyClick.currentHash && historyClick.currentHash != '#' ? historyClick.currentHash : rootAlias);

				if (mayChangeReload) {
					needReload = false;
				}
			}
		}
		
		function go(hash) {
			if (!hash) {
				return;
			}
			
			var pattern,
				callback;

			for (var i = 0, len = revRoutes.length; i < len; i++) {
				pattern = revRoutes[i][0];
				callback = revRoutes[i][1];
				console.log('pattern = ' + pattern);
				console.log('hash = ' + hash);
				if (pattern.test(hash) && typeof callback === 'function') {
					console.log('true')
					callback(hash.match(pattern));
					
					return;
				}
			}
		}

		var historyClick = {
			interval: null,
			currentHash: '',
			prevHash: '',
			start: function() {
				init();
			},
			rootAlias: function(hash) {
				if (hash) {
					rootAlias = hash;
				} else {
					return rootAlias;
				}
			},
			addRoute: function(pattern, callback) {
				if (typeof pattern === 'string') {
					pattern = [pattern];
				}

				for (var i = 0; i < pattern.length; i++) {
					routes.push([new RegExp(pattern[i], 'i'), callback]);
				}

				revRoutes = routes.slice().reverse(); // клонируем и реверсируем
			},
			reload: function() {
				needReload = true;
			},
			changeHashSilent: function(hash) {
				historyClick.prevHash = historyClick.currentHash;
				historyClick.currentHash = window.location.hash = hash;
			}
		};
		
		return historyClick;
	})();`
	
	
	#https://github.com/ssteynfaardt/Xhr
	class Xhr
		#class methods
		@readyState =	0
		@status = null
		#jsonp callback function

		_parseUrl = (->
			a = document.createElement("a")
			(url) ->
				a.href = url
				host: a.host
				hostname: a.hostname
				pathname: a.pathname
				port: a.port
				protocol: a.protocol
				search: a.search
				hash: a.hash
		)()

		_isObject = (obj) ->
			(obj.ownerDocument not instanceof Object) and (obj not instanceof Date) and (obj not instanceof RegExp) and (obj not instanceof Function) and (obj not instanceof String) and (obj not instanceof Boolean) and (obj not instanceof Number) and obj instanceof Object

		_doJsonP = (url) ->
			script = document.createElement("script")
			script.type = 'text/javascript';
			script.src = url
			document.body.appendChild script

		jpcb: ->
		#public methods
		constructor: () ->
			
			_callbackFunctions = {}
			_setCallbackFor = (callbackFor, callbackFunction) ->
				if(typeof callbackFor is 'string' and typeof callbackFunction is 'function')
					_callbackFunctions[callbackFor] = callbackFunction

			_doCallbackFor = (callbackFor) ->
				if(typeof _callbackFunctions[callbackFor] is 'function')
					_callbackFunctions[callbackFor](arguments[1],arguments[2],arguments[3])
			#Instance varialbes, to access it @_.cors
			@_ =
				xhr: null
				cors:	null
				xhrType: 'form'
				doCallbackFor: _doCallbackFor
				setCallbackFor: _setCallbackFor

		createXhrObject: ->
			_validStatus = [200,201,204,304]
			@_.cors = false
			if window.XDomainRequest
				@_.xhr = new XDomainRequest()
				@_.cors = true
			else if window.XMLHttpRequest
				@_.xhr = new XMLHttpRequest()
				@_.cors = true	if "withCredentials" of @_.xhr
			else if window.ActiveXObject
				try
					@_.xhr = new ActiveXObject("MSXML2.XMLHTTP.3.0")
				catch error
					@_.xhr = null
					throw Error(error);

			_this = @
			@_.xhr.onreadystatechange = ->
				_this.readyState = _this._.xhr.readyState
				_this._.doCallbackFor('readystatechange',_this._.xhr)
				switch _this._.xhr.readyState
					when 0, 1
						_this._.doCallbackFor('loadstart',_this._.xhr)
					when 2
						_this._.doCallbackFor('progress',_this._.xhr)
					when 3
						_this._.doCallbackFor('onload',_this._.xhr)
					when 4
						try
							if _this._.xhr.status in _validStatus
								_this._.doCallbackFor('success',_this._.xhr.responseText,_this._.xhr.status,_this._.xhr)
							else
								_this._.doCallbackFor('error',_this._.xhr.responseText,_this._.xhr.status,_this._.xhr)
						catch error
							throw Error(error)

						_this._.doCallbackFor('loadend',_this._.xhr.responseText, _this._.xhr.status,_this._.xhr)
						_this._.xhr = null
					else
						throw Error("Unsupported readystate (#{_this._.xhr.readyState}) received.")

			@_.xhr.ontimeout = ->
				_this._.doCallbackFor('timeout',_this._.xhr)
			@_.xhr.onabort = ->
				_this._.doCallbackFor('abort',_this._.xhr)	

			@_.xhr

		_doAjaxCall: (url,method = "GET",data = null)->
			if (url is undefined)
				throw Error("URL required");
			currentUrl = window.location

			urlObj = _parseUrl(url);
			xhrObj = @createXhrObject()

			getContentType = (type = "form") ->
				contentType = 'application/x-www-form-urlencoded'
				switch type.toLowerCase()
					when 'html'
						contentType = 'text/html'
					when 'json'
						contentType = 'application/json'
					when 'jsonp'
						contentType = 'application/javascript'
					when 'xml'
						contentType = 'application/xml'
					else
						contentType = 'application/x-www-form-urlencoded'
				contentType
			
			#check if we are making a CORS call
			if (urlObj.host is currentUrl.host and urlObj.protocol is currentUrl.protocol and urlObj.port is currentUrl.port) then crossDomain = false else crossDomain = true
			if crossDomain is false or @_.cors is true
				xhrObj.open(method,url,true)
				if(@_.cors)
					xhrObj.setRequestHeader('X-Requested-With', 'XMLHttpRequest')
				if (data)
					if(typeof data is 'string' and window.JSON)
						try
							data = JSON.parse(data)
							@setType('json');						
						catch e
						

					if(@_.xhrType is 'json' and typeof data is "object" and window.JSON)
						data = JSON.stringify(data)
						@setType('json');
					else if(typeof data != "string")
						xhrObj.setRequestHeader('Content-Type', getContentType('form'))
						data = @serialize(data)
						@setType('form');
				xhrObj.setRequestHeader('Content-Type', getContentType(@_.xhrType))
				xhrObj.send(data)
			else
				data = @serialize(data)
				_doJsonP("#{data}&callback=")
				throw Error "crossDomain Error"

		serialize: (obj, keyed, prefix = '') ->
			return prefix + encodeURIComponent(obj)	unless _isObject(obj)
			result = ""
			temp = ""
			for index of obj
				continue	unless obj.hasOwnProperty(index)
				temp = (if keyed then keyed + "[" + encodeURIComponent(index) + "]" else encodeURIComponent(index))
				result += @serialize(obj[index], temp, "&" + temp + "=")
			result.substring(1)

		setType: (type)->
			_validTypes = ['form','html','json','jsonp','xml']
			type = type.toLowerCase()
			throw Error("Unsupported type (#{type})") if type not in _validTypes
			@_.xhrType = type


		cors: ->
			if @_.cors is null
				@createXhrObject()
			@_.cors

		abort: ->
			try
				@_.xhr.abort();
				@_.xhr.onreadystatechange = ->
				@readyState = 0
			catch error
				#throw Error(error)
			@ononabort()
			@

		call: (url,method,data) ->
			@_doAjaxCall(url,method,data)
			@
		head:(url) ->
			@_doAjaxCall(url,"HEAD")
			@
		options:(url) ->
			@_doAjaxCall(url,"OPTIONS")
			@
		get:(url) ->
			@_doAjaxCall(url,"GET")
			@
		put: ( url, data) ->
			@_doAjaxCall(url,"PUT",data)
			@
		post: ( url, data) ->
			@_doAjaxCall(url,"POST",data)
			@
		delete: (url) ->
			@_doAjaxCall(url,"DELETE")
			@
		jsonp:(url) ->
			_doJsonP(url)
			@

		onreadystatechange: (callback) ->
			@_.setCallbackFor('readystatechange',callback)
			@
		onloadstart: (callback) ->
			@_.setCallbackFor('loadstart',callback)
			@
		onprogress: (callback) ->
			@_.setCallbackFor('progress',callback)
			@
		onload: (callback) ->
			@_.setCallbackFor('load',callback)
			@
		onerror: (callback) ->
			@_.setCallbackFor('error',callback)
			@
		onsuccess: (callback) ->
			@_.setCallbackFor('success',callback)
			@
		onloadend: (callback) ->
			@_.setCallbackFor('loadend',callback)
			@
		ontimeout: (callback) ->
			@_.setCallbackFor('timeout',callback)
			@
		onabort: (callback) ->
			@_.setCallbackFor('abort',callback)
			@
	#Set some variables that will be available in the to use
	P.Xhr = Xhr	
	

	# https://github.com/IntoMethod/Lightweight-JSONP
	# Lightweight JSONP fetcher
	# Copyright 2010-2012 Erik Karlsson. All rights reserved.
	# BSD licensed	
	P.JSONP = `(function(){
		var _uid = 1, head, config = {}, _callbacks = [];
		
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
		
		function jsonp(url, params, callback) {			
			var query = (url || '').indexOf('?') === -1 ? '?' : '&', key;
			
			params = params || {};
			params.queryId = _uid++;
			
			for ( key in params ) {
				if ( params.hasOwnProperty(key) ) {
					query += encode(key) + '=' + encode(params[key]) + '&';
				}
			}
			
			_callbacks[_uid] = callback;
	 
			load(url + query);
		}
		
		function setDefaults(obj){
			config = obj;
		}
		
		return {
			get: jsonp,			
			callback: function(data) {
				if (!data || !data.queryId || !_callbacks[data.queryId]) {
					return;
				}
				
				_callbacks[data.queryId](data);
				
				try {
					delete _callbacks[data.queryId];
				} catch (e) {}
				
				_callbacks[data.queryId] = null;
			}
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