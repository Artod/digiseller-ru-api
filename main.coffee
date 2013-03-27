###
DigiSeller-ru-api
22.03.2013 (c) http://artod.ru
###

((window, document) ->
	off if window.DigiSeller?

	DS = {}

	DS.el =
		head: null
		body: null
		widget: null
		
	DS.opts =		
		host: '//plati.ru'
		widgetId: 'plati-ru'
		css: '/test/css/default/main.css'
		tmpl: '/test/tmpl/default.js'
		loader: '/test/img/loader.gif'
		hashPrefix: '#!digiseller'

	DS.util =
		extend:	(target, source, overwrite) ->
			for key of source
				continue	unless source.hasOwnProperty(key)
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


	DS.dom =
		$: (selector, context, tagName) ->
			return unless selector

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
			return unless el

			if el.attachEvent
				el.attachEvent('on' + event, callback)
			else if el.addEventListener
				el.addEventListener(event, callback, false)

		removeEvent: (el, event, callback) ->
			return unless el

			if el.detachEvent
				el.detachEvent("on#{type}", callback)
			else if el.removeEventListener
				el.removeEventListener(event, callback, false)
			
		addClass: (els, c) ->
			return unless els
			
			if not els.length
				els = [els]
			
			re = new RegExp('(^|\\s)' + c + '(\\s|$)', 'g')
			
			for el in els
				continue if re.test(el.className)
				el.className = (el.className + ' ' + c).replace(/\s+/g, ' ').replace(/(^ | $)/g, '')
			
			return els
		
		removeClass: (els, c) ->
			return unless els
			
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

			DS.el.head.appendChild(link)
			
			return
		
		# jQuery.getScript
		getScript: (url, onLoad, onError) ->			
			script = document.createElement('script')
			script.type = 'text/javascript'
			script.src = url
			script.setAttribute('encoding', 'UTF-8')
			
			done = no			
			onComplite = (e) ->
				done = yes
				script.onload = script.onreadystatechange = null;					
				DS.el.head.removeChild(script) if DS.el.head and script.parentNode
				
				return
			
			script.onload = script.onreadystatechange = (e) ->
				if ( not done and (not this.readyState or this.readyState is 'loaded' or this.readyState is 'complete') )
					onComplite()					
					onLoad() if onLoad?
					
				return
				
			script.onerror = (e) ->				
				onComplite()
				onError if onError?
					
				return			

			DS.el.head.appendChild(script)
			
			return
			
	DS.widget =
		main:
			el: null
		search:
			el: null
			input: null
			init: (el) ->
				@el = el
				
				@input = DS.dom.$('.digiseller-search-input', @el, 'input')[0]
				go = DS.dom.$('.digiseller-search-go', @el, 'a')[0]
				
				self = @
				DS.dom.addEvent(go, 'click', (e) ->
					if e.preventDefault then e.preventDefault() else e.returnValue = false
					
					window.location.hash = "#{DS.opts.hashPrefix}/search?s=" + self.input.value
					
					return
				)
				
				return
				
		category:
			el: null
			init: (el) ->
				@el = el
				self = @
				DS.JSONP.get('http://shop.digiseller.ru/xml/shop_sections.asp',
					id_seller: DS.opts.id_seller
					format: 'json'
				, (data) ->
					off unless data || data.category
					
					self.el.innerHTML = self.render(data.category)
					self.mark()
					
					return
				)
				
				return
				
			mark: (cid) ->
				cats = DS.dom.$('.digiseller-category', @el, 'ul')
				
				return unless cats.length
				
				subs = DS.dom.$('.digiseller-categories', @el, 'ul')				
				for sub in subs
					sub.style.display = 'none'
				
				subs[0].style.display = ''				
				
				DS.dom.removeClass(cats, 'digiseller-category-choosed')
				
				return unless cid
				
				cat = DS.dom.$("#digiseller-category-#{cid}")
				
				return unless cat
				
				DS.dom.addClass(cat, 'digiseller-category-choosed')
				
				parent = cat
				while parent.id isnt 'digiseller-category'
					parent.style.display = ''
					parent = parent.parentNode					
				
				DS.dom.$("#digiseller-category-sub-#{cid}")?.style.display = ''
					
				return
				
			render: (categories, parent_cid) ->
				return '' if not categories
			
				out = ''
				for category in categories
					category.url = "#{DS.opts.hashPrefix}/articles/#{category.id}"
					category.sub = @render(category.sub, category.id)
					category.id = "digiseller-category-#{category.id}"
					
					out += DS.tmpl(DS.tmpls.category, category)
					
				DS.tmpl(DS.tmpls.categories,
					id: if parent_cid then "digiseller-category-sub-#{parent_cid}" else ''
					out: out
				)
		
	DS.route =
		home:
			url: '/home'
			action: (params) ->	
				DS.widget.category.mark()
				DS.widget.main.el.innerHTML = 'Выберите категорию'
				DS.widget.category.el.style.display = ''
				
				return
				
		search:
			url: '/search\\?s=(.*)'
			action: (params) ->
				search = params[1]
				
				DS.widget.search.input.value = search				
				DS.widget.category.mark()
				
				DS.widget.main.el.innerHTML = '<h2>Результутаты поиска по запросу "' + search + '"</h2>'
				
				return

		articles:
			url: '/articles/([0-9]*)(?:/([0-9]*))?'			
			action: (params) ->
				cid = params[1]
				page = parseInt(params[2]) or 1

				DS.widget.category.mark(cid)

				self = @
				DS.JSONP.get('http://shop.digiseller.ru/xml/shop_products.asp',
					id_seller: DS.opts.id_seller
					format: 'json'
					category_id: cid
					page: page
					rows: 5
					order: '' # name, nameDESC, price, priceDESC
					currency: 'RUR'
				, (data) ->
					off unless data
					
					self.render(data, cid, page)
					
					self.pagerMark(cid, page)
					
					return
				)
				
				return
				
			render: (data, cid, page) ->
				out = ''
				
				articles = data.product
				
				unless articles
					DS.widget.main.el.innerHTML = 'Nothing found'
					return
				
				for article in articles
					article.url = "#{DS.opts.hashPrefix}/detail/#{article.id}"
					
					out += DS.tmpl(DS.tmpls.article, article)
				
				container = DS.dom.$("#digiseller-articles-#{cid}")
				
				if container
					container.innerHTML = out
				else
					DS.widget.main.el.innerHTML = DS.tmpl(DS.tmpls.articles,
						id: "digiseller-articles-#{cid}"
						idPages: "digiseller-pager-#{cid}"
						out: out
					)
					
					@pagerRender(cid, page, data.totalPages)
				
				return
				
			pagerMark: (cid, curPage) ->
				pager = DS.dom.$("#digiseller-pager-#{cid}")				
				pages = DS.dom.$('a', pager)				
				
				for page, index in pages
					DS.dom[if curPage is index + 1 then 'addClass' else 'removeClass'](page, 'digiseller-page-choosed')
			
				return
				
			pagerRender: (cid, curPage, total) ->
				out = ''
				page = 1
				
				pager = DS.dom.$("#digiseller-pager-#{cid}")
				
				unless total
					pager.display = 'none'
					return
				
				while page <= total
					out += DS.tmpl(DS.tmpls.page,
						page: page
						url: "#{DS.opts.hashPrefix}/articles/#{cid}/#{page}"
					)
					
					page++
					
				pager.innerHTML = DS.tmpl(DS.tmpls.pages,
					out: out
				)
				
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
				
				DS.dom.addEvent(DS.dom.$('.digiseller-article-buy', DS.widget.main.el, 'a')[0], 'click', (e) ->
					if e.preventDefault then e.preventDefault() else e.returnValue = false
					
					window.open('//plati.ru', 'digiseller', DS.util.getPopupParams(670, 500))
					
					return
				)
				
				DS.widget.category.mark(62)
				
				return
				
			render: (article) ->
				out = ''

				DS.widget.main.el.innerHTML = DS.tmpl(DS.tmpls.articleDetail, article)
				
				return
	inited = no
	DS.init = ->
		off if inited
		inited = yes
		
		DS.el.head = DS.dom.$('head')[0] || document.documentElement
		DS.el.body = DS.dom.$('body')[0] || document.documentElement
		DS.el.shop = DS.dom.$("##{DS.opts.widgetId}")
		
		DS.el.shop.innerHTML = '<img src="' + DS.opts.host + DS.opts.loader + '" style="digiseller-loader" alt="" />'
		
		DS.dom.getStyle(DS.opts.host + DS.opts.css + '?' + Math.random())
		DS.dom.getScript(DS.opts.host + DS.opts.tmpl + '?' + Math.random(), ->			
			DS.el.shop.innerHTML = DS.tmpl(DS.tmpls.main, {})
			
			DS.widget.main.el = DS.dom.$('#digiseller-main')
			DS.widget.category.init(DS.dom.$('#digiseller-category'))
			DS.widget.search.init(DS.dom.$('#digiseller-search'))

			for name, route of DS.route				
				continue unless DS.route.hasOwnProperty(name) or route.url or route.action
				
				((route) ->					
					DS.historyClick.addRoute(DS.opts.hashPrefix + route.url, (params) ->
						route.action(params)
					)
					
					return
				)(route)
			
			DS.historyClick.rootAlias(DS.opts.hashPrefix + '/home');
			DS.historyClick.start()
			
			if window.location.hash is ''		
                DS.historyClick.reload()

			return
		)

		return
		

	# https://github.com/mtrpcic/pathjs
	`Path={version:"0.8.4",map:function(a){if(Path.routes.defined.hasOwnProperty(a)){return Path.routes.defined[a]}else{return new Path.core.route(a)}},root:function(a){Path.routes.root=a},rescue:function(a){Path.routes.rescue=a},history:{initial:{},pushState:function(a,b,c){if(Path.history.supported){if(Path.dispatch(c)){history.pushState(a,b,c)}}else{if(Path.history.fallback){window.location.hash="#"+c}}},popState:function(a){var b=!Path.history.initial.popped&&location.href==Path.history.initial.URL;Path.history.initial.popped=true;if(b)return;Path.dispatch(document.location.pathname)},listen:function(a){Path.history.supported=!!(window.history&&window.history.pushState);Path.history.fallback=a;if(Path.history.supported){Path.history.initial.popped="state"in window.history,Path.history.initial.URL=location.href;window.onpopstate=Path.history.popState}else{if(Path.history.fallback){for(route in Path.routes.defined){if(route.charAt(0)!="#"){Path.routes.defined["#"+route]=Path.routes.defined[route];Path.routes.defined["#"+route].path="#"+route}}Path.listen()}}}},match:function(a,b){var c={},d=null,e,f,g,h,i;for(d in Path.routes.defined){if(d!==null&&d!==undefined){d=Path.routes.defined[d];e=d.partition();for(h=0;h<e.length;h++){f=e[h];i=a;if(f.search(/:/)>0){for(g=0;g<f.split("/").length;g++){if(g<i.split("/").length&&f.split("/")[g].charAt(0)===":"){c[f.split("/")[g].replace(/:/,"")]=i.split("/")[g];i=i.replace(i.split("/")[g],f.split("/")[g])}}}if(f===i){if(b){d.params=c}return d}}}}return null},dispatch:function(a){var b,c;if(Path.routes.current!==a){Path.routes.previous=Path.routes.current;Path.routes.current=a;c=Path.match(a,true);if(Path.routes.previous){b=Path.match(Path.routes.previous);if(b!==null&&b.do_exit!==null){b.do_exit()}}if(c!==null){c.run();return true}else{if(Path.routes.rescue!==null){Path.routes.rescue()}}}},listen:function(){var a=function(){Path.dispatch(location.hash)};if(location.hash===""){if(Path.routes.root!==null){location.hash=Path.routes.root}}if("onhashchange"in window&&(!document.documentMode||document.documentMode>=8)){window.onhashchange=a}else{setInterval(a,50)}if(location.hash!==""){Path.dispatch(location.hash)}},core:{route:function(a){this.path=a;this.action=null;this.do_enter=[];this.do_exit=null;this.params={};Path.routes.defined[a]=this}},routes:{current:null,root:null,rescue:null,previous:null,defined:{}}};Path.core.route.prototype={to:function(a){this.action=a;return this},enter:function(a){if(a instanceof Array){this.do_enter=this.do_enter.concat(a)}else{this.do_enter.push(a)}return this},exit:function(a){this.do_exit=a;return this},partition:function(){var a=[],b=[],c=/\(([^}]+?)\)/g,d,e;while(d=c.exec(this.path)){a.push(d[1])}b.push(this.path.split("(")[0]);for(e=0;e<a.length;e++){b.push(b[b.length-1]+a[e])}return b},run:function(){var a=false,b,c,d;if(Path.routes.defined[this.path].hasOwnProperty("do_enter")){if(Path.routes.defined[this.path].do_enter.length>0){for(b=0;b<Path.routes.defined[this.path].do_enter.length;b++){c=Path.routes.defined[this.path].do_enter[b]();if(c===false){a=true;break}}}}if(!a){Path.routes.defined[this.path].action()}}}`

	DS.Path = Path
	
	DS.historyClick = `(function() {
		var _rootAlias = '',
			_needReload = false,
			_routes = [],
			_revRoutes = [];

		function init() {
			if (!historyClick.interval) {
				historyClick.interval = setInterval(urlHashCheck, 100);
			}
		}

		function urlHashCheck() {
			var mayChangeReload = false; // _needReload может обнулиться так как urlHashCheck может еще не закончиться а _needReload уже поставили true
			
			if (_needReload) {
				mayChangeReload = true;
			}

			if (window.location.hash !== historyClick.currentHash || _needReload) {
				historyClick.prevHash = ( _needReload ? historyClick.prevHash : historyClick.currentHash );
				historyClick.currentHash = window.location.hash.toString();

				go(historyClick.currentHash && historyClick.currentHash != '#' ? historyClick.currentHash : _rootAlias);

				if (mayChangeReload) {
					_needReload = false;
				}
			}
		}
		
		function go(hash) {
			if (!hash) {
				return;
			}
			
			var pattern,
				callback;

			for (var i = 0, len = _revRoutes.length; i < len; i++) {
				pattern = _revRoutes[i][0];
				callback = _revRoutes[i][1];
				
				if (pattern.test(hash) && typeof callback === 'function') {
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
					_rootAlias = hash;
				} else {
					return _rootAlias;
				}
			},
			addRoute: function(pattern, callback) {
				if (typeof pattern === 'string') {
					pattern = [pattern];
				}
				
				for (var i = 0; i < pattern.length; i++) {
					_routes.push([new RegExp(pattern[i], 'i'), callback]);
				}

				_revRoutes = _routes.slice().reverse(); // клонируем и реверсируем
			},
			reload: function() {
				_needReload = true;
			},
			changeHashSilent: function(hash) {
				historyClick.prevHash = historyClick.currentHash;
				historyClick.currentHash = window.location.hash = hash;
			}
		};
		
		return historyClick;
	})();`
	
	
	#https://github.com/ssteynfaardt/Xhr
	

	# https://github.com/IntoMethod/Lightweight-JSONP
	# Lightweight JSONP fetcher
	# Copyright 2010-2012 Erik Karlsson. All rights reserved.
	# BSD licensed	
	DS.JSONP = `(function(){
		var _uid = 0, head, config = {}, _callbacks = [];
		
		/*function load(url, pfnError) {
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
		}*/
		
		function encode(str) {
			return encodeURIComponent(str);
		}
		
		function jsonp(url, params, callback) {			
			var query = (url || '').indexOf('?') === -1 ? '?' : '&', key;
			
			params = params || {};
			_uid++;
			params.queryId = _uid;
			
			for (key in params) {
				if ( !params.hasOwnProperty(key) ) {
					continue;
				}
				
				query += encode(key) + '=' + encode(params[key]) + '&'			
			}			

			_callbacks[_uid] = callback;	 
		
			DS.dom.getScript( url + query + '_' + Math.random() );
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
	DS.tmpl = `function(text, data) {
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
	window.DigiSeller = DS
	
	DS.dom.addEvent(window, 'load', DS.init);

	return

) window, document

DigiSeller.opts.id_seller = 18728


### @render([
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
], cid, page) ###


# alert('sdsd')
# categories = [
	# id: 1
	# name: '1 category'
# ,
	# id: 2
	# name: '2 category'
	# sub: [
		# id: 4
		# name: '4 category'
		# sub: [
			# id: 6
			# name: '6 category'
		# ,
			# id: 7
			# name: '7 category'
		# ]
	# ]
# ,
	# id: 3
	# name: '3 category'
	# sub: [
		# id: 5
		# name: '5 category'
	# ]
# ]