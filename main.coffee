###*
DigiSeller shop widget v. 1.4.01
16.12.2014 (c) http://artod.ru
###

off if window.DigiSeller?

_cssIsLoaded = true

DS = {}

DS.el =
	head: null
	body: null

DS.opts =
	seller_id: null
	cart_uid: ''
	host: '//shop.digiseller.ru/xml/new/'
	hashPrefix: '#!digiseller'
	currency: 'RUR'
	currentLang: ''
	sort: 'name' # name, nameDESC, price, priceDESC
	rows: 10
	view: 'list'
	main_view: 'tile'
	logo_img: ''
	menu_purchases: true
	menu_reviews: true
	menu_contacts: true
	imgsize_firstpage: 160
	imgsize_listpage: 162
	imgsize_infopage: 163
	imgsize_category: 200

DS.cookie =
	get: (name) ->
		`var matches = document.cookie.match(new RegExp(
		  "(?:^|; )" + name.replace(/([\.$?*|{}\(\)\[\]\\\/\+^])/g, '\\$1') + "=([^;]*)"
		));

		return matches ? decodeURIComponent(matches[1]) : undefined`

		return

	set: (name, value, props) ->
		`props = props || {};

		var exp = props.expires;
		if (typeof exp === 'number' && exp) {
			var d = new Date();
			d.setTime(d.getTime() + exp * 1000);
			exp = props.expires = d;
		}

		if (exp && exp.toUTCString) {
			props.expires = exp.toUTCString();
		}

		value = DS.util.enc(value);

		var updatedCookie = name + '=' + value;
		for (var propName in props) {
			if ( !DS.util.hasOwnProp(props, propName) ) continue;

			updatedCookie += '; ' + propName;
			var propValue = props[propName];
			if (propValue !== true) {
				updatedCookie += '=' + propValue;
			}
		}

		document.cookie = updatedCookie`

		return

	del: (name) ->
		@set(name, null, {expires: -1})

		return

DS.util =
	getUID: (() ->
		id = 1
		return () -> id++
	)()

	enc: (t) ->
		return encodeURIComponent(t)

	prevent: (e) ->
		if e.preventDefault then e.preventDefault() else e.returnValue = false

		return
	hasOwnProp: (source, prop) ->
		return Object.prototype.hasOwnProperty.call(source, prop)
	# extend: (target, source, overwrite) ->
	extend: (obj) ->
		# for key of source
			# continue unless Object.prototype.hasOwnProperty.call(source, key)
			# target[key] = source[key] if overwrite or typeof target[key] is 'object'

		# return target
		
		`var type = typeof obj;
		if (! (type === 'function' || type === 'object' && !!obj) ) return obj;
		
		var /*source, */prop;
		//for (var i = 1, length = arguments.length; i < length; i++) {
		DS.util.each(arguments, function(source) {
			//source = arguments[i];
			for (prop in source)
				if ( DS.util.hasOwnProp(source, prop) )
					obj[prop] = source[prop];
			
		})
		//}
		return obj`
		return

	each: (els, cb) ->
		for el, i in els
			cb(el, i)
		
		return
		
	getPopupParams: (width, height) ->
		screenX = if typeof window.screenX isnt 'undefined' then window.screenX else window.screenLeft
		screenY = if typeof window.screenY isnt 'undefined' then window.screenY else window.screenTop
		outerWidth = if typeof window.outerWidth isnt 'undefined' then window.outerWidth else document.body.clientWidth
		outerHeight = if typeof window.outerHeight isnt 'undefined' then window.outerHeight else (document.body.clientHeight - 22)
		left = parseInt(screenX + ((outerWidth - width) / 2), 10)
		top = parseInt(screenY + ((outerHeight - height) / 2.5), 10)

		return "scrollbars=1, resizable=1, menubar=0, left=#{left}, top=#{top}, width=#{width}, height=#{height}, toolbar=0, status=0"

	getAbsPos: (a) ->
		`var b = {
			x: 0,
			y: 0
		};
		if (a.offsetParent) do b.x += a.offsetLeft, b.y += a.offsetTop, a = a.offsetParent;
		while (a);
		return b`

		return

	scrollUp: () ->
		doc = document.documentElement
		body = document.body
		scrollTop = (doc && doc.scrollTop  || body && body.scrollTop  || 0)
		posY = DS.util.getAbsPos(DS.widget.main.$el).y

		if scrollTop > posY
			window.scroll(null, DS.util.getAbsPos(DS.widget.main.$el).y)

		return

	debounce: (cb, delay) ->
		timeout = null
	
		return () ->
			context = this
			args = arguments

			clearTimeout(timeout)			
			timeout = setTimeout(() ->
				cb.apply(context, args)
				context = args = null
			, delay || 200)
			
			return


# NanoJQuery
DS.$ = (() ->
	# events = {}
	
	_klass = (action, el, cl) ->
		re = new RegExp('(^|\\s)' + ( if action is 'add' then cl else cl.replace(' ', '|') ) + '(\\s|$)', 'g')

		return if action is 'add' and re.test(el.className)
			
		if action is 'add'
			el.className = (el.className + ' ' + cl).replace(/\s+/g, ' ').replace(/(^ | $)/g, '')
		else
			el.className = el.className.replace(re, "$1").replace(/\s+/g, ' ').replace(/(^ | $)/g, '')

		return

	_getVal = (el) ->
		return null if not el or not el.nodeName
	
		switch el.nodeName
			when 'SELECT'
				option = el.querySelectorAll('option')[el.selectedIndex]
				
				return if option then option.value else null
			else
				return el.value

		return
		
	_setVal = (el, val) ->
		return off if not el or not el.nodeName
		
		switch el.nodeName
			when 'SELECT'
				options = el.querySelectorAll('option')
				# for option, i in options
				DS.util.each(options, (option, i) ->
					if option.value is val + ''
						el.selectedIndex = i
						
						return
				)
			else
				el.value = val
				
				return

		return
		
	return (selector, $context) ->
		_els = []

		if typeof selector is 'string'
			context = $context and $context.get and $context.get(0)
			
			if typeof $context is 'undefined' or context
				DS.util.each( (context or document).querySelectorAll(selector), (el) ->
					_els.push(el)
				)
		else if Object.prototype.toString.call(selector) is '[object Array]'
			_els = selector
		else if selector and (selector.nodeType or selector is window)
			_els = [selector]

		out =
			each: (cb) ->
				DS.util.each(_els, cb)

				return @
				
			addClass: (cl) ->
				@each (el) ->
					_klass('add', el, cl)
					
					return
					
				@			
				
			removeClass: (cl) ->
				@each (el) ->
					_klass('remove', el, cl)
					
					return
					
				@
				
			on: (type, handler) ->
				@each (el, i) ->
					# events = {}
					# events[el] = events[el] or {}
					# events[el][type] = events[el][type] or []

					el.DigiSeller = {} if not el.DigiSeller
					el.DigiSeller.events = {} if not el.DigiSeller.events
					el.DigiSeller.events[type] = [] if not el.DigiSeller.events[type]
					
					events = (el and el.DigiSeller and el.DigiSeller.events) or {}
					# console.log(events)
					# events[type] = events[type] or []					

					if el.attachEvent
						ieHandler = (type) ->
							handler.call(el, type)

						el.attachEvent('on' + type, ieHandler)					

						# events[el][type].push(ieHandler)
						el.DigiSeller.events[type].push(ieHandler)

					else if el.addEventListener
						el.addEventListener(type, handler, false)
						# events[el][type].push(handler)
						el.DigiSeller.events[type].push(handler)
					
					return
				
				@
				
			off: (type, handler) ->
				@each (el, i) ->					
					handlers = (el and el.DigiSeller and el.DigiSeller.events and el.DigiSeller.events[type]) or []
					j = handlers.length
					
					while j--
						handler = handlers[j]
						
						if el.detachEvent
							el.detachEvent("on#{type}", handler)
						else if el.removeEventListener
							el.removeEventListener(type, handler, false)
						
						handlers.splice(j, 1)
						
					return
				
				@
				
			show: () ->
				@.removeClass('digiseller-hidden')
				
			hide: () ->
				@.addClass('digiseller-hidden')				
					
			get: (i) ->
				_els[i]

			attr: (attr, val) ->
				if typeof val is 'undefined'
					try
						return _els[0] and _els[0].getAttribute(attr)
					catch e
						return null
				else
					@each (el) ->
						# console.log('val', val)
						# console.log('attr', attr)
						
						el.setAttribute(attr, val)
						
						return

				@
				
			html: (html) ->			
				if typeof html is 'undefined'
					return _els[0] and _els[0].innerHTML
				else
					@each (el) ->
						el.innerHTML = html
						
						return
						
				@
				
			val: (val) ->
				if typeof val is 'undefined'
					return _els[0] and _getVal(_els[0])
				else
					@each (el) ->
						_setVal(el, val)
						
						return
						
				@
				
			css: (prop, val) ->
				if typeof val is 'undefined'
					return _els[0] && _els[0].style[prop]
				else
					@each (el) ->
						el.style[prop] = val
						
						return
						
				@
				
			remove: () ->
				@each (el) ->
					el.parentNode.removeChild(el)
					
					return

				@
				
			parent: () ->
				els = []
				@each (el) ->
					els.push(el.parentNode)
					
					return
					
				return DS.$(els)
				
			next: () ->
				els = []
				@each (el) ->
					els.push(el.nextSibling)
					
					return
					
				return DS.$(els)
				
			prev: () ->
				els = []
				@each (el) ->
					els.push(el.prevSibling)
					
					return
					
				return DS.$(els)
				
			children: () ->
				els = []
				@each (el) ->
					DS.util.each(el.children, (child) ->
						els.push(child)
						
						return
					)
					
					return
					
				return DS.$(els)
				
			eq: (i) ->
				return DS.$(_els[i])
					
		out.length = _els.length
		
		return out
)()


DS.dom =
	# $: (selector, context, tagName) ->
		# return unless selector
		
		 
		# type = selector.substring(0, 1)
		# name = selector.substring(1)

		# switch type
			# when '#'
				# document.getElementById(name)
			# when '.'
				# tagName = if tagName then tagName else '*'

				# `if ( typeof document.getElementsByClassName !== 'function' ) {
					# for (
						# var i = -1,
							# results = [ ],
							# finder = new RegExp('(?:^|\\s)' + name + '(?:\\s|$)'),
							# a = context && context.getElementsByTagName && context.getElementsByTagName(tagName) || document.all || document.getElementsByTagName(tagName),
							# l = a.length;
						# ++i < l;
						# finder.test(a[i].className) && results.push(a[i])
					# );

					# a = null;

					# return results;
				# } else {
					# return (context || document).getElementsByClassName(name);
				# }`

				# return
			# else
				# (context || document).getElementsByTagName(selector)

	# attr: ($el, attr, val) ->
		# if not $el or typeof attr is 'undefined'
			# return false

		# if typeof val isnt 'undefined'
			# $el.setAttribute(attr, val)
		# else
			# try
				# return $el.getAttribute(attr)
			# catch e
				# return null

		# return

	# addEvent: ($el, e, callback) ->
		# if $el.attachEvent
			# ieCallback = (e) -> callback.call($el, e)
			# $el.attachEvent('on' + e, ieCallback)

			# return ieCallback

		# else if $el.addEventListener
			# $el.addEventListener(e, callback, false)

			# return callback

		# return

	# removeEvent: ($el, e, callback) ->
		# if $el.detachEvent
			# $el.detachEvent("on#{e}", callback)
		# else if $el.removeEventListener
			# $el.removeEventListener(e, callback, false)

		# return

	# klass: (action, els, c, multy) ->
		# `if (!els || !action) {
			# return;
		# }

		# if (!multy) {
			# els = [els];
		# }

		# var $el, _i, _len,
			# re = new RegExp('(^|\\s)' + ( action === 'add' ? c : c.replace(' ', '|') ) + '(\\s|$)', 'g');

		# for (_len = els.length, _i = _len-1; _i >= 0; _i--) {
			# $el = els[_i];
			# if ( action === 'add' && re.test($el.className) ) {
				# continue;
			# }

			# $el.className = action === 'add' ? ($el.className + ' ' + c).replace(/\s+/g, ' ').replace(/(^ | $)/g, '') : $el.className.replace(re, "$1").replace(/\s+/g, " ").replace(/(^ | $)/g, "");
		# }

		# return els`

		# return

	# select: ($select, val) ->
		# if typeof val is 'undefined'
			# return DS.dom.$('option', $select)[$select.selectedIndex].value
		# else
			# $options = DS.dom.$('option', $select)
			# for $option, i in $options
				# if $option.value is val + ''
					# $select.selectedIndex = i
					# return

		# return
	
	getStyle: (url, onLoad) ->
		link = document.createElement('link')
		link.type = 'text/css'
		link.rel = 'stylesheet'
		link.href = url

		DS.el.head.appendChild(link)

		return
	
# https://gist.githubusercontent.com/bullgare/5336154/raw/e907dd47330d2af59e0a68f6fa272b4fdaa069ba/services.js
DS.serialize = (form, onEach) ->
	`if (!form || form.nodeName !== "FORM") {
		return;
	}

	var i, j,
		obj = {};

	//for (i = form.elements.length - 1; i >= 0; i = i - 1) {
	DS.util.each(form.elements, function(element) {
		if (element.name === "") {
			//continue;
			return;
		}
		
		switch (element.nodeName) {
			case 'INPUT':
				switch (element.type) {
					case 'text':
					case 'hidden':
					case 'password':
					case 'number':
						obj[element.name] = DS.util.enc(element.value);
						break;
					case 'checkbox':
					case 'radio':
						if (element.checked) {
							obj[element.name] = DS.util.enc(element.value);
						}
						break;
					case 'file':
						break;
				}
				break;
			case 'TEXTAREA':
				obj[element.name] = DS.util.enc(element.value);
				break;
			case 'SELECT':
				switch (element.type) {
					case 'select-one':
						obj[element.name] = DS.util.enc(element.value);
						break;
					case 'select-multiple':
						//for (j = element.options.length - 1; j >= 0; j = j - 1) {
						DS.util.each(element.options, function(option) {
							if (option.selected) {
								obj[element.name] = DS.util.enc(option.value);
							}
						});
						break;
				}
				break;
		}
		
		if (typeof onEach === 'function') {
			onEach(element);
		}
	});

	return obj`

	return

DS.historyClick = `(function() {
	var _rootAlias = '',
		_needReload = false,
		_routes = [],
		_revRoutes = [];

	function init() {
		if (historyClick.interval) {
			return;
		}

		DS.$(window).on('hashchange', urlHashCheck);
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
		
		historyClick.onGo()

		var pattern,
			callback;

		for (var i = 0, len = _revRoutes.length; i < len; i++) {
			pattern = _revRoutes[i][0];
			callback = _revRoutes[i][1];

			if (pattern.test(hash) && typeof callback === 'function') {
				historyClick.params = hash.match(pattern);
				callback(historyClick.params);

				return;
			}
		}
	}

	var historyClick = {
		interval: null,
		currentHash: '',
		prevHash: '',
		params: [],
		start: function() {
			init();
			urlHashCheck();
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
			urlHashCheck();
		},
		changeHashSilent: function(hash) {
			historyClick.prevHash = historyClick.currentHash;
			historyClick.currentHash = window.location.hash = hash;
		},
		onGo: function() {
		
		}
	};

	return historyClick;
})()`

DS.ajax = (() -> 
	`var _isXdr = false,
		createCORSRequest = function() {
			return null;
		};	
	
	if ( 'withCredentials' in new XMLHttpRequest() ) {
		createCORSRequest = function(method, url) {
			var xhr = new XMLHttpRequest();
			xhr.open(method, url, true);
			if (method === 'POST') xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded; charset=UTF-8');
			return xhr;
		}
	} else if (typeof XDomainRequest !== 'undefined') {
		_isXdr = true;
		createCORSRequest = function(method, url) {
			var xdr = new XDomainRequest();
			xdr.open(method, url);
			
			return xdr;
		}
	}
	
	/*function createCORSRequest(method, url) {
		var xhr = new XMLHttpRequest();
		if ('withCredentials' in xhr) {
			xhr.open(method, url, true);
		} else if (typeof XDomainRequest !== 'undefined') {
			xhr = new XDomainRequest();
			xhr.open(method, url);
		} else {
			xhr = null;
		}
		
		if (xhr && xhr.setRequestHeader && method === 'POST')
			xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded; charset=UTF-8');
		
		return xhr;
	}*/
	
	function toQueryString(params) {
		var key,
			queryString = [];

		for (key in params) {
			if ( !DS.util.hasOwnProp(params, key) ) continue;
			
			queryString.push( ( DS.util.enc(key) + '=' + DS.util.enc(params[key]) ) );
		}

		return queryString.join('&');
	}`

	return (method, url, opts) ->
		opts = DS.util.extend(
			$el: null
			data: {}
			onLoad: () ->
			onFail: () ->
			onComplete: () ->
		, opts)

		if _isXdr and method is 'POST'
			method = 'GET';
			opts.data && opts.data.xdr = 1		
		
		sign = (if /\?/.test(url) then '&' else '?')

		queryString = toQueryString(opts.data)
		
		xhr = createCORSRequest( method, url + sign + 'transp=cors&format=json&lang=' + DS.opts.currentLang + (if method is 'GET' then '&_=' + Math.random() + (if queryString then '&' + queryString else '') else '') )

		uid = DS.util.getUID()

		DS.widget.loader.show(uid)
		
		_onComplete = (xhr) ->
			# console.log('Ответ:', xhr.responseText) if xhr
			opts.onComplete(xhr)
			DS.widget.loader.hide(uid)

		if not xhr
			# DS.JSONP.get(url + sign + 'transp=jsonp', opts.$el, opts.data, opts.onLoad, opts.onFail, _onComplete)

			return

		needCheck = if opts.$el then yes else no
		
		if needCheck
			opts.$el.attr('data-qid', uid)
		
		# xhr.onreadystatechange = () ->
			# if (xhr.readyState is 4) 
				# console.log(xhr.status)			
			
		xhr.onload = () ->
			_onComplete(xhr)
			
			if needCheck and parseInt( opts.$el.attr('data-qid') ) isnt uid
				return

			opts.onLoad(JSON.parse(xhr.responseText), xhr)

		xhr.onerror = () ->			
			_onComplete(xhr)			
			opts.onFail(xhr)
			
		xhr.onabort = () ->
			console.log('abort')
			_onComplete(xhr)
			
		# http://cypressnorth.com/programming/internet-explorer-aborting-ajax-requests-fixed/
		if _isXdr
			setTimeout(() ->
				xhr.send(queryString)
				return
			, 0)
		else
			xhr.send(queryString)

		xhr
)()
###
DS.JSONP = `(function() {
	var _callbacks = [];

	function jsonp(url, $el, params, onLoad, onFail, onComplete) {
		var query = (url || '').indexOf('?') === -1 ? '?' : '&',
			key;

		params = params || {};

		var _uid = DS.util.getUID();
		params.queryId = _uid;

		for (key in params) {
			if ( !DS.util.hasOwnProp(params, key) ) continue;

			query += DS.util.enc(key) + '=' + DS.util.enc(params[key]) + '&'
		}

		var needCheck = $el ? true : false;

		if (needCheck) {
			$el.attr('data-qid', _uid);
		}

		_callbacks[_uid] = function(data) {
			if ( needCheck && ( !$el || data.queryId != $el.attr('data-qid') ) ) {
				return;
			}

			onLoad(data);
		};

		DS.dom.getScript(url + query + '_' + Math.random(), null, onFail, onComplete);

		return _uid;
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
})()`
###
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
		var render = new Function(settings.variable || 'obj', 'DS', source);
	} catch (e) {
		e.source = source;
		throw e;
	}

	if (data) {
		return render(data, DS);
	}

	var template = function(data) {
		return render.call(this, data, DS);
	};

	// Provide the compiled function source as a convenience for precompilation.
	template.source = 'function(' + (settings.variable || 'obj') + '){\n' + source + '}';

	return template;
}` #"

DS.popup = (() ->
	setup = {}
	img = null
	prefix = 'digiseller-popup-'
	isCompV = document.compatMode is 'CSS1Compat'
	# wrCallback = null
	# leftCallback = null
	# rightCallback = null
	isClosed = true

	show = (onResize) ->		
		setup.$loader.hide()
		setup.$container.show()

		# wrCallback = DS.dom.addEvent(window, 'resize', onResize)
		DS.$(window).on('resize', onResize)		
		
		# as = () ->
			# console.log('empt')
		# as2 = () ->
			# console.log('empt2')			

		# DS.$(window).on('click', as	)
		# DS.$(window).on('click', as2	)

		onResize()

		return

	close = (e) ->
		return if isClosed
	
		DS.util.prevent(e) if e
		setup.$img.html('')
		setup.$main.hide()
		# DS.dom.removeEvent(window, 'resize', wrCallback)
		DS.$(window).off('resize')	
		
		isClosed = true
		img = null

		return

	resize = (h, w, isHard) ->
		# console.log('resize')		
		
		wih = window.innerHeight
		hs = ( if typeof wih isnt 'undefined' then wih else (document[if isCompV then 'documentElement' else 'body'].offsetHeight - 22) ) - 100

		if not isHard
			scale0 = h / w
			wiw = window.innerWidth
			ws = ( if typeof wiw isnt 'undefined' then wiw else document[if isCompV then 'documentElement' else 'body'].offsetWidth ) - 120
			h1 = hs
			w1 = ws

			isDec = false
			h >= hs and (isDec = true) or (h1 = h)
			w >= ws and (isDec = true) or (w1 = w)

			if isDec
				if scale0 <= h1/w1
					h1 = Math.round(scale0 * w1)
				else
					w1 = Math.round(h1 / scale0)

			img.style.height = h1 + 'px'
			img.style.width = w1 + 'px'

		setup.$container.css('width', ( (if isHard then w else w1) + 50 ) + 'px')

		doc = document.documentElement
		body = document.body
		topScroll = (doc && doc.scrollTop or body && body.scrollTop or 0)
		setup.$container.css('top', (hs - (if isHard then h else h1) + 20)/3 + topScroll + 'px')

		return

	init = () ->
		container = document.createElement('div')
		container.innerHTML = DS.tmpl(DS.tmpls.popup,
			p: prefix
		)

		DS.el.body.appendChild(container.firstChild);

		# params = ['main', 'fade', 'loader', 'container', 'close', 'img', 'left', 'right']
		# for param in params DS.util.each(params, (param) ->
		DS.util.each(['main', 'fade', 'loader', 'container', 'close', 'img', 'left', 'right'], (param) ->
			setup['$' + param] = DS.$("##{prefix}#{param}")
			
			return
		)

		setup.$fade.on('click', close)
		setup.$close.on('click', close)

		return

	return {
		open: (type, id, onLeft, onRight) ->
			not setup.$main and  init()

			isClosed = false

			setup.$container.hide()
			setup.$main.show()
			setup.$loader.show()

			setup.$left[if onLeft then 'show' else 'hide']()
			if onLeft
				# leftCallback = DS.dom.addEvent(setup.$left, 'click', onLeft)
				setup.$left.off('click').on('click', onLeft)

			# setup.$right.style.display = if onRight then '' else 'none'
			setup.$right[if onRight then 'show' else 'hide']()
			if onRight
				# DS.dom.removeEvent(setup.$right, 'click', rightCallback)
				# rightCallback = DS.dom.addEvent(setup.$right, 'click', onRight)
				setup.$right.off('click').on('click', onRight)

			switch type
				when 'img'
					# DS.dom.klass('remove', setup.$img, 'digiseller-popup-video')
					setup.$img.removeClass('digiseller-popup-video')

					img = new Image()
					img.onload = () ->
						return if isClosed

						h = img.height
						w = img.width

						# DS.dom.removeEvent(window, 'resize', wrCallback)
						DS.$(window).off('resize')
						show(() ->							
							resize(h, w)
							return
						)

						setup.$img
							.html('')
							.get(0).appendChild(img)

					img.src = id

				else
					# DS.dom.klass('add', setup.$img, 'digiseller-popup-video')
					setup.$img.addClass('digiseller-popup-video')

					show(() ->
						resize(200, 500, true)
						return
					)

					setup.$img.html(id)

			return

		close: close
	}
)()


# http://habrahabr.ru/post/156185/
DS.share =
	vk: (title, img) ->
		return '//vkontakte.ru/share.php?' +
			'url=' + DS.util.enc(document.location) + '&' +
			'title=' + DS.util.enc(title) + '&' +
			'image=' + DS.util.enc(img) + '&' +
			'noparse=true'

	tw: (title) ->
		return '//twitter.com/share?' +
			'text=' + DS.util.enc(title) + '&' +
			'url=' + DS.util.enc(document.location)

	fb: (title, img) ->
		# return '//www.facebook.com/sharer.php?s=100&' +
			# 'p[url]=' + DS.util.enc(document.location) + '&' +
			# 'p[title]=' + DS.util.enc(title) + '&' +
			# 'p[images][0]=' + DS.util.enc(img)
			
		return '//www.facebook.com/sharer.php?u=' + DS.util.enc(document.location)

	wme: (title, img) ->
		return '//events.webmoney.ru/sharer.aspx?' +
			'url=' + DS.util.enc(document.location) + '&' +
			'title=' + DS.util.enc(title) + '&' +
			'image=' + DS.util.enc(img) + '&' +
			'noparse=0'

DS.agree = (flag, onAgree) ->
	$rules = DS.$('#digiseller-calc-rules')
	$rules.get(0).checked = flag if $rules.length

	DS.opts.agree = if flag then 1 else 0
	DS.cookie.set('digiseller-agree', DS.opts.agree)

	DS.popup.close()

	onAgree() if onAgree

	return
	
DS.widget =
	main:
		$el: null
		init: () ->
			@$el = DS.$('#digiseller-main')
			@$el
				.html('') # сбрасываем лоадер
				.on('click', (e) ->
					callback(e, 'click')
					
					return
				)
			
			callback = (e, type) ->
				$el = DS.$(e.originalTarget or e.srcElement)
				action = $el.attr('data-action')

				if action and typeof DS.eventsDisp[type + '-' + action] is 'function'
					DS.eventsDisp[type + '-' + action]($el, e)



			return

	loader: (() ->
		_counter = 0
		_timeouts = []

		return {
			$el: null
			init: () ->
				div = document.createElement('div')
				div.id = 'digiseller-loader'
				div.className = div.id
				div.innerHTML = DS.tmpl(DS.tmpls.loader, {})
				# div.style.display = 'none'

				DS.el.body.appendChild(div)

				@$el = DS.$("##{div.id}").hide()

				return

			show: (uid) ->
				that = @
				# console.log('show = ', uid)
				_timeouts[uid] = setTimeout(() ->
					_timeouts[uid] = 0
					_counter++
					
					that.$el.show()
					
					return
				, 1000)

				return

			hide: (uid) ->
				# console.log('hide = ', uid)
				clearTimeout(_timeouts[uid])

				if _timeouts[uid] is 0
					_counter--

				delete _timeouts[uid]

				if _counter <= 0
					@$el.hide()

				return
		}
	)()

	search:
		$el: null
		$input: null
		prefix: 'digiseller-search'
		init: () ->
			@$el = DS.$("##{@prefix}")
			return unless @$el.length

			@$el.html(DS.tmpls.search)

			@$input = DS.$("input.#{@prefix}-input", @$el)
			$form = DS.$("form.#{@prefix}-form", @$el)

			that = @
			$form.on('submit', (e) ->
				DS.util.prevent(e)

				window.location.hash = DS.opts.hashPrefix + "/search?s=#{that.$input.val()}"

				return
			)

			return

	lang:
		$el: null
		prefix: 'digiseller-langs'
		init: () ->
			@$el = DS.$("##{@prefix}")
			return unless @$el.length

			@$el.html( DS.tmpl(DS.tmpls.langs, {}) )

			DS.$('a', @$el).on('click', (e) ->
				DS.util.prevent(e)

				lang = DS.$(@).attr('data-lang')

				DS.cookie.set('digiseller-lang', lang)
				DS.opts.currentLang = lang
				
				window.location.reload()
				
				return
			)

			return

	category:
		$el: null
		isInited: false
		prefix: 'digiseller-category'
		init: () ->
			@$el = DS.$("##{@prefix}")
			return unless @$el.length

			@isInited = false

			that = @
			DS.ajax('GET', DS.opts.host + 'shop_categories.asp'
				$el: @$el
				data:
					lang: DS.opts.currentLang
					seller_id: DS.opts.seller_id
				onLoad: (res) ->					
					return off unless res

					that.$el.html( that.render(res.category, null, 0) )

					that.isInited = true

					that.mark()

					return
			)

			return

		mark: (() ->
			_go = (cid) ->
				$cats = DS.$('li', @$el)

				return unless $cats.length

				$subs = DS.$('ul', @$el)
				$subs.hide()
				$subs.eq(0).show()
				
				# $subs.show()
				# for sub in subs
					# sub.style.display = 'none'

				# subs[0].style.display = ''

				# DS.dom.klass('remove', $cats, "#{@prefix}-active", true)
				# DS.dom.klass('remove', $cats, "#{@prefix}-active-hmenu", true)
				
				$cats.removeClass(@prefix + '-active')
					.removeClass(@prefix + '-active-hmenu')

				return unless cid

				$cat = DS.$("##{@prefix}-#{cid}")
				return unless $cat.length

				# DS.dom.klass('add', $cat, @prefix + '-active')
				$cat.addClass(@prefix + '-active')

				$parent = $ancestor = $cat

				while $parent.get(0).id isnt @prefix
					# $parent.style.display = ''
					$parent.show()
					# $parent = DS.$($parent.get(0).parentNode)
					$parent = $parent.parent()

					if /li/i.test($parent.get(0).nodeName)
						# DS.dom.klass('add', $parent, @prefix + '-active-hmenu')
						$parent.addClass(@prefix + '-active-hmenu')

				# DS.dom.$("##{@prefix}-sub-#{cid}")?.style.display = ''
				DS.$("##{@prefix}-sub-#{cid}").show()

				return

			return (cid) ->
				return if not @$el or not @$el.length

				if @isInited
					_go.call(@, cid)
				else
					that = @
					count = 0
					interval = setInterval( ->
						if that.isInited or count > 1000
							clearInterval(interval)
							if that.isInited
								_go.call(that, cid)

						count++

						return

					, 50)

				return
		)()

		render: (categories, parent_cid) ->
			return '' if not categories				

			out = ''
			tmpl = DS.tmpl(DS.tmpls.category)
			that = @
			# for category in categories
			DS.util.each(categories, (category) ->
				out += tmpl(
					d: category
					url: DS.opts.hashPrefix + "/articles/#{category.id}"
					id: that.prefix + "-#{category.id}"
					sub: that.render(category.sub, category.id)
				)
				
				return
			)
			
			return DS.tmpl(DS.tmpls.categories,
				id: if parent_cid then @prefix + "-sub-#{parent_cid}" else ''
				out: out
			)

	currency:
		$el: null
		init: () ->
			@$el = DS.$('#digiseller-currency')
			return unless @$el.length

			@$el.html( DS.tmpl(DS.tmpls.currency, {}) )

			$select = DS.$('select', @$el) 
			$select
				.val(DS.opts.currency)
				.on('change', (e) ->
					$this = DS.$(@)
					type = $this.attr('data-type')

					# DS.opts.currency = DS.dom.select(@)
					DS.opts.currency = $select.val()
					DS.cookie.set('digiseller-currency', DS.opts.currency)
					DS.historyClick.reload()

					return
				)

			# DS.dom.select($sel.get(0), DS.opts.currency)
			# $sel.val(DS.opts.currency)

			return

	pager: class
		constructor: (@$el, opts) ->
			opts = opts or {}

			@page = opts.page || 1
			@rows = opts.rows || 10
			@total = opts.total || 0

			@opts =
				tmpl: opts.tmpl || DS.tmpls.pages
				max: opts.max || 2
				getLink: opts.getLink || (page) -> return page
				onChangeRows: opts.onChangeRows || (rows) ->

			return

		mark: () ->
			$pages = DS.$('a', @$el)

			# for page, index in pages
				# DS.dom.klass( (if @page == parseInt( DS.dom.attr(page, 'data-page') ) then 'add' else 'remove'), page, 'digiseller-activepage' )
			that = @
			$pages.each (el) ->
				$page = DS.$(el)				
				$page[if that.page == parseInt( $page.attr('data-page') ) then 'addClass' else 'removeClass']('digiseller-activepage')
				
				return
				
			return @

		render: () ->
			@page = parseInt(@page)
			@rows = parseInt(@rows)
			@total = parseInt(@total)

			@$el[if @total then 'show' else 'hide']()

			out = ''

			if @total > 1
				left = @page - @opts.max
				left = if left < 1 then 1 else left

				right = @page + @opts.max
				right = if right > @total then @total else right

				page = left


				while page <= right
					out += @opts.getLink(page)
					page++

				if left > 1
					out = @opts.getLink(1) + (if left > 2 then '<span>...</span> ' else '') + out

				if right < @total
					out = out + (if right < @total - 1 then '<span>...</span> ' else '') + @opts.getLink(@total)

			@$el.html( DS.tmpl(@opts.tmpl,
				out: out
			) )

			that = @
			DS.$('select', @$el)			
				.val(@rows)
				.on('change', (e) ->
					$this = DS.$(@)
					
					# that.rows = DS.dom.select(@)
					that.rows = $this.val()
					that.opts.onChangeRows(that.rows)
					
					return
				)

			# DS.dom.select($select, @rows)
			# $select.val(@rows)
			@mark()

			return @

	comments: class
		constructor: (@$el, @product_id, @init) ->
			@isInited = false
			@type = ''
			@page = 1
			@rows = 10
			@pager = null

			return

		get: () ->
			that = @
			# DS.JSONP.get(DS.opts.host + 'shop_reviews.asp', @$el,
			DS.ajax('GET', DS.opts.host + 'shop_reviews.asp',
				$el: @$el
				data:
					seller_id: DS.opts.seller_id
					product_id: @product_id
					type: @type
					page: @page
					rows: @rows
				onLoad: (data) ->
					return off unless data

					that.render(data)

					return
			)

			return

		render: (data) ->
			comments = data.review

			out = ''
			unless comments
				out = DS.tmpl(DS.tmpls.nothing, {})
			else
				tmpl = DS.tmpl(DS.tmpls.comment)
				# for comment in comments
				DS.util.each(comments, (comment) ->
					out += tmpl(
						d: comment
					)
					
					return
				)

			if @isInited
				# @pager.page = @page
				# @pager.rows = @rows
				# @pager.total = data.totalPages
				
				DS.util.extend(@pager,
					page: @page
					rows: @rows
					total: data.totalPages
				)
				
				@pager.render()
			else
				@init(data)
				@container = DS.$('.digiseller-comments', @$el)
				@isInited = true

			@container.html(out)

			return
			
	calc: class
		_els = ['amount', 'cnt', 'cntSelect', 'currency', 'amountR', 'price', 'buy', 'limit', 'rules', 'cart', 'method', 'curadd']
		_prefix = 'digiseller-calc'

		constructor: (@id) ->
			@$ = container: DS.$("##{_prefix}")

			return unless @$.container.length				

			that = @
			
			# for el in _els
			DS.util.each(_els, (el) ->
				that.$[el] = DS.$("##{_prefix}-#{el}")
				
				return
			)

			debouncedGet = DS.util.debounce( (type) ->				
				that.get(type)
				
				return
			)
			
			if @$.amount.length
				if @$.cnt.length
					@$.amount.on('keyup', () ->
						debouncedGet('amount')
						
						return
					)
					@$.cnt.on('keyup', () ->
						debouncedGet('cnt')
						
						return
					)

				@$.cntSelect.on('change', () ->
					that.get('cnt')
					
					return
				)

		
			onChangeCurrency = (withoutGet) ->
				index = that.$.currency.get(0).selectedIndex

				$curAdd = $curAddSelects.eq(index)
				vars = parseInt( $curAdd.attr('data-vars') )

				$curAddSelects.hide()
				
				if vars > 1
					$curAdd.show()
					that.$.method.removeClass(_prefix + '-method').addClass(_prefix + '-method-two')
				else
					that.$.method.addClass(_prefix + '-method').removeClass(_prefix + '-method-two')

				onChangeCurAdd($curAdd, withoutGet)
				
			$currencyOpts = DS.$('option', @$.currency)
			onChangeCurAdd = ($this, withoutGet) ->				
				index = $this.attr('data-index')
				val = $this.val()

				that.$.currency.get(0).selectedIndex = index
				$currencyOpts.eq(index).val(val)
				
				unless withoutGet
					that.get()
				
				return
				
			$curAddSelects = DS.$('select', @$.curadd)			
			$curAddSelects.on('change', ()->
				onChangeCurAdd( DS.$(@) )
			)
			
			@$.currency.on('change', () ->
				onChangeCurrency()
			)
			
			onChangeCurrency(true)
			
			$optionsCont = DS.$('#digiseller-calc-options')
			if $optionsCont.length
				@$.options = DS.$('input[type="radio"], input[type="checkbox"], select', $optionsCont) # 
				@$.options.on('change', () ->
					that.get()
					
					return
				)
				
			@get()

			if that.$.rules.length
				$parentRules = that.$.rules.parent()
				
				rules = (flag) ->
					$parentRules[if flag and not that.$.rules.get(0).checked then 'addClass' else 'removeClass'](_prefix + '-confirmation-error')

				@$.buy.on('mouseover', () ->
					rules(true)
					
					return
				).on('mouseout', () ->
					rules(false)
					
					return
				)
					
				@$.cart.on('mouseover', () ->
					rules(true)
					
					return
				).on('mouseout', () ->
					rules(false)
					
					return
				)

			return

		get: (type) ->
			that = @
			params =
				# product_id: @id
				p: @id
				# format: 'json'
				# lang: DS.opts.currentLang


			if type is 'amount'
				# params.amount = @$.amount.val()
				params.a = @$.amount.val()
			else #if @$.cntSelect.length or @$.cnt.length
				# params.cnt = if @$.cntSelect.length then @$.cntSelect.val() else @$.cnt.val()
				# params.cnt = if @$.cntSelect.length then @$.cntSelect.val() else @$.cnt.val()
				params.n = if @$.cntSelect.length then @$.cntSelect.val() else @$.cnt.val() or 0

				@checkMinMax(params.n)

			# params.currency = @$.currency.val()
			params.c = @$.currency.val()			
			params.x = '<response>'
			
			if @$.options then @$.options.each( (el) ->				
				switch el.nodeName
					when 'SELECT'
						params.x += '<option O="' + el.name.replace('option_select_', '') + '" V="' + DS.$(el).val() + '"/>'
					else
						if el.checked
							params.x += '<option O="' + el.name.replace('option_checkbox_', '').replace('option_radio_', '') + '" V="' + DS.$(el).val() + '"/>'
						
				return
			)
			
			params.x += '</response>'
			
			DS.ajax('GET', '//www.oplata.info/asp2/price_options.asp'
				$el: @$.container
				data: params
				onLoad: (res) ->					
					return off if not res
					
					that.render(res)
					
					return
			)
			
			# DS.JSONP.get(DS.opts.host + 'shop_unit.asp', @$.container,
				# params
			# , (data) ->
				# return off unless data

				# that.render(data.prices_unit)

				# return
			# )

			return

		checkMinMax: (cnt) ->
			that = @
			cnt = parseInt(cnt)
			max = parseInt( @$.buy.attr('data-max') )
			min = parseInt( @$.buy.attr('data-min') )

			minmax = (val, flag) ->
				that.disable(yes)
				
				that.$.limit.html( DS.tmpl(DS.tmpls.minmax,
					val: val
					flag: flag
				) ).show()
				
				return

			if max and cnt > max
				minmax(max, true)
				return
			else if min and cnt < min
				minmax(min, false)
				return


			@.disable(no)
			
			@$.limit.hide()

			return
		
		render: (data) ->
			return off unless data

			# @$.amount.val(data.unit_Amount if data.unit_Amount)
			# if data.amount
				# if @$.amount.length
					# console.log(2)
			@$.amount.val(data.amount)
				# else if @$.price.length
					# console.log(data.amount + ' ' + data.curr)
			@$.price.html(data.amount + ' ' + data.curr)

			# if @$.cnt.length && data.unit_Cnt
			if @$.cnt.length && data.cnt
				@checkMinMax(data.cnt)
				@$.cnt.val(data.cnt)

			if @$.cntSelect.length and data.curr
				# DS.dom.select(@$.cntSelect, data.unit_Currency)
				@$.cntSelect.val(data.curr)

			#!!!!!!!!!!!!! @$.amountR.html(data.unit_AmountDesc)
			@$.amountR.html(data.curr)
			
			if data.amount is '0'
				@.disable(yes)

			return
			
		disable: (disabled) ->
			go = ($el) ->
				$el[if disabled then 'addClass' else 'removeClass']('digiseller-cart-btn-disabled')
					.attr('data-action', if disabled then '' else 'buy')
				
			go(@.$.buy)
			go(@.$.cart)
			
			return
		
	cartButton:
		$el: null
		prefix: 'digiseller-cart'
		init: () ->
			@$el = DS.$("##{@prefix}-btn")

			return unless @$el.length

			DS.opts.hasCart = true
			
			@$el.html( DS.tmpl(DS.tmpls.cartButton, {
				count: DS.opts.cart_cnt
			}) )

			DS.$('a', @$el).on('click', (e) ->
				DS.util.prevent(e)
			
				new DS.widget.cart()

				return
			)

			return
			
		setCount: (count) ->
			DS.$("##{@prefix}-count").html(count)
			# DS.dom.klass( (if count then 'remove' else 'add'), DS.dom.$('#digiseller-cart-empty'), 'digiseller-cart-btn-empty' )
			DS.$("##{@prefix}-empty")[if count then 'removeClass' else 'addClass'](@prefix + '-btn-empty')
			
			return

	cart: class
		_prefix = 'digiseller-cart'		
		
		constructor: (@currency) ->			
			@get()

		get: () ->
			that = @
			DS.ajax('GET', DS.opts.host + 'shop_cart_lst.asp'
				$el: DS.widget.cartButton.$el
				data:
					lang: DS.opts.currentLang
					cart_uid: DS.opts.cart_uid
					cart_curr: @currency or ''
				onLoad: (res) ->					
					return off if not res
					
					that.render(res)
					
					return
			)
			
			return
			
		render: (res) ->
			items = ''
			tmpl = DS.tmpl(DS.tmpls.cartItem)
			count = 0
			
			if res.products
				# for product, i in res.products
				DS.util.each(res.products, (product, i) ->
					count++
					
					items += tmpl({
						d: product
						even: !!(i % 2)
					})
					
					return
				)
				
			DS.widget.cartButton.setCount(count)
			
			DS.popup.open( 'text',  DS.tmpl(DS.tmpls.cart, {
				d: res
				failPage: DS.util.enc(window.location)
				items: items
			}) )

			@init(res)
			
			return
			
		init: (res) ->
			$context = DS.$("##{_prefix}-items")
			
			return if not $context.length
			
			that = @
			
			changeCount = DS.util.debounce( ($this, isDel) ->				
				that.changeCount($this, isDel)
				
				return
			)
			
			DS.$(".#{_prefix}-del-product", $context).on('click', (e) ->
				DS.util.prevent(e)
				
				that.changeCount(DS.$(@), yes)
				
				return
			)
			
			DS.$('input', $context).on('change', (e) ->				
				changeCount( DS.$(@) )				
				return
			).on('keyup', (e) ->
				changeCount( DS.$(@) )				
				return
			)
			
			DS.$(".#{_prefix}-params-toggle", $context).on('click', (e) ->
				DS.util.prevent(e)
				
				$el = DS.$(@.parentNode)
				
				isOpened = $el.attr('data-opened') is '1'

				$el[if isOpened then 'removeClass' else 'addClass'](_prefix + '-show-params')
					.attr('data-opened', if isOpened then 0 else 1)
				
				return
			)
			
			$select = DS.$("##{_prefix}-currency")
			$select.val(res.currency).on('change', (e) ->
				new DS.widget.cart( $select.val() )				
				return
			)
			
			@.$go = DS.$("##{_prefix}-go")			
			@.$go.on('click', (e) ->
				DS.util.prevent(e)
				
				if that.$go.attr('data-disabled') is '1'
					return
				
				@.parentNode.submit()
				
				return
			)

			@.$amount = DS.$("##{_prefix}-amount")
			@.$amountCont = DS.$("##{_prefix}-amount-cont")
			
			return
			
		update: (res, id) ->
			items = (if res and res.products then res.products else [])
			idForDel = id
			
			@.$amount.html(res.amount)			
			
			hasError = no
			
			count = 0
			
			unless items.length
				@.disable(yes)
			else
				DS.util.each(items, (item, i) ->
					count++
					# item.error = 'dddd'
					if item.id is id
						idForDel = false
				
					$item = DS.$("##{_prefix}-item-#{item.id}")				
					$error = DS.$("##{_prefix}-item-error-#{item.id}")
					
					# $item[if item.error then 'addClass' else 'removeClass'](_prefix + '-error')
					# $error[if item.error then 'show' else 'hide']()
					
					if item.error
						$item.addClass(_prefix + '-error')
						$item.attr('data-error', 1)
						$error.show()
						DS.$('td', $error).html(item.error)
					else if item.id is id
						$item.removeClass(_prefix + '-error')
						$item.attr('data-error', 0)
						$error.hide()
					
					if $item.attr('data-error') is '1'
						hasError = yes
						
					# if item.error
						# hasError = yes
						# DS.$("##{_prefix}-item-count-#{item.id}").val(item.cnt_item)
						
					return
				)
				
				@.disable(hasError)
			
			DS.widget.cartButton.setCount(count)
			
			# @.$go[if hasError then 'addClass' else 'removeClass'](_prefix + '-btn-disabled')
				# .attr('data-disabled', if hasError then '1' else '0')
				
			# @.$amountCont[if hasError then 'hide' else 'show']()			
			
			if idForDel
				DS.$("##{_prefix}-item-#{idForDel}").remove()
				DS.$("##{_prefix}-item-error-#{idForDel}").remove()
				
			return
			
		disable: (disable) ->

			@.$go[if disable then 'addClass' else 'removeClass'](_prefix + '-btn-disabled')
				.attr('data-disabled', if disable then '1' else '0')
				
			@.$amountCont[if disable then 'hide' else 'show']()
			
			return
		
		changeCount: ($this, isDel) ->
			id = $this.attr('data-id')
			$item = DS.$("##{_prefix}-item-#{id}")
			$count = if isDel then DS.$("##{_prefix}-item-count-#{id}") else $this
			count = if isDel then 0 else $count.val()
			parsedCnt = parseInt( $count.val() )
			that = @

			if not isDel and not parsedCnt and `parsedCnt != count` #( `count == 0` or not /^[0-9]*$/.test(count) )
				newCount = parsedCnt || 1
				$count.val(newCount)
				parsedCnt = newCount
				
			DS.ajax('GET', DS.opts.host + 'shop_cart_lst.asp'
				$el: $this
				data:
					lang: DS.opts.currentLang
					cart_uid: DS.opts.cart_uid
					product_id: id
					product_cnt: parsedCnt
				onLoad: (res) ->					
					return off unless res				
					
					that.update(res, id)
					
					return
			)

			return			
			
DS.route =
	home:
		url: '/home'
		action: () ->
			DS.widget.category.mark()

			@get()

			return

		get: () ->
			that = @
			# DS.JSONP.get(DS.opts.host + 'shop_products.asp', DS.widget.main.$el,
			DS.ajax('GET', DS.opts.host + 'shop_products.asp',
				$el: DS.widget.main.$el
				data:
					seller_id: DS.opts.seller_id
					category_id: 0
					rows: 10
					order: DS.opts.sort
					currency: DS.opts.currency
				onLoad: (data) ->
					return off unless data

					that.render(data)
					DS.util.scrollUp()

					return
				)

			return

		render: (data) ->
			out = ''

			articles = data.product

			if articles and articles.length
				tmpl = DS.tmpl( DS.tmpls['article' + DS.opts.main_view.charAt(0).toUpperCase() + DS.opts.main_view.slice(1)] )
				# for article in articles
				DS.util.each(articles, (article) ->
					out += tmpl(
						d: article
						url: DS.opts.hashPrefix + "/detail/#{article.id}"
						imgsize: if DS.opts.main_view is 'tile' then DS.opts.imgsize_firstpage else DS.opts.imgsize_listpage
					)
					
					return
				)

			DS.widget.main.$el.html( DS.tmpl(DS.tmpls.showcaseArticles,
				out: if DS.opts.main_view is 'table' then '<table class="digiseller-table">' + out + '</table>' else out
				categories: data.categories
			) )
			
			return

	search:
		url: '/search(?:/([0-9]*))?\\?s=(.*)'
		search: null
		page: null
		rows: null
		pager: null
		prefix: 'digiseller-search'
		action: (params) ->
			@search = decodeURIComponent(params[2])
			@page = parseInt(params[1]) or 1
			@rows = DS.opts.rows

			DS.widget.category.mark()

			DS.widget.search.$input.val(@search)

			@get()

			return

		get: () ->
			that = @
			# DS.JSONP.get(DS.opts.host + 'shop_search.asp', DS.widget.main.$el,
			DS.ajax('GET', DS.opts.host + 'shop_search.asp',
				$el: DS.widget.main.$el
				data:
					seller_id: DS.opts.seller_id # 83991
					currency: DS.opts.currency
					page: @page
					rows: @rows
					search: @search
				onLoad: (data) ->
					return off unless data

					that.render(data)
					DS.util.scrollUp()

					return
			)

			return

		render: (data) ->
			out = ''

			articles = data.product

			if not articles or not articles.length
				out = DS.tmpl(DS.tmpls.nothing, {})
			else
				tmpl = DS.tmpl(DS.tmpls.searchResult)
				# for article in articles
				DS.util.each(articles, (article) ->
					out += tmpl(
						url: DS.opts.hashPrefix + "/detail/#{article.id}"
						d: article
					)
					
					return
				)

			$container = DS.$("##{@prefix}-results")

			if $container.length
				$container.html(out)

				@pager.page = @page
				@pager.rows = @rows
				@pager.total = data.totalPages
				@pager.render()
			else
				DS.widget.main.$el.html( DS.tmpl(DS.tmpls.searchResults,
					totalItems: data.totalItems
					out: out
				) )

				that = @
				tmpl = DS.tmpl(DS.tmpls.page)
				@pager = new DS.widget.pager(DS.$('.digiseller-paging', DS.widget.main.$el),
					page: @page
					rows: @rows
					total: data.totalPages
					getLink: (page) ->
						return tmpl(
							page: page
							url: DS.opts.hashPrefix + "/search/#{page}?s=#{that.search}"
						)

					onChangeRows: (rows) ->
						DS.opts.rows = rows
						DS.cookie.set(DS.route.articles.prefix + '-rows', rows)

						that.page = 1
						that.rows = rows
						that.get()

						DS.historyClick.changeHashSilent(DS.opts.hashPrefix + "/search/1?s=#{that.search}")

						return

				).render()

				DS.widget.currency.init()

			DS.$("##{@prefix}-query").html( @search.replace('<', '&lt;').replace('>', '&gt;') )
			DS.$("##{@prefix}-total").html(data.totalItems)

			return

	articles:
		url: '/articles/([0-9]*)(?:/([0-9]*))?'
		cid: null
		page: 1
		rows: null
		pager: null
		pagerComments: null
		prefix: 'digiseller-articles'
		action: (params) ->
			@cid = params[1]
			@page = parseInt(params[2]) or 1
			@rows = DS.opts.rows

			@get()

			return

		get: () ->
			DS.widget.category.mark(@cid)

			that = @
			# DS.JSONP.get(DS.opts.host + 'shop_products.asp', DS.widget.main.$el,
			DS.ajax('GET', DS.opts.host + 'shop_products.asp',
				$el: DS.widget.main.$el
				data:
				# format: 'json'
				# lang: DS.opts.currentLang
					seller_id: DS.opts.seller_id
					category_id: @cid
					page: @page
					rows: @rows
					order: DS.opts.sort
					currency: DS.opts.currency
				onLoad: (data) ->
					return off unless data

					that.render(data)
					DS.util.scrollUp()

					return
				)

			return

		render: (data) ->
			out = ''

			data.totalPages = parseInt(data.totalPages)

			articles = data.product
			
			if not articles or not articles.length
				out = DS.tmpl(DS.tmpls.nothing, {})
			else
				tmpl = DS.tmpl( DS.tmpls['article' + DS.opts.view.charAt(0).toUpperCase() + DS.opts.view.slice(1)] )
				# for article in articles
				DS.util.each(articles, (article) ->
					out += tmpl(
						d: article
						url: DS.opts.hashPrefix + "/detail/#{article.id}"
						imgsize: if DS.opts.view is 'tile' then DS.opts.imgsize_firstpage else DS.opts.imgsize_listpage
					)
					
					return
				)

			$container = DS.$("##{@prefix}-#{@cid}")
			if $container.length
				$container.html(if DS.opts.view is 'table' then '<table class="digiseller-table">' + out + '</table>' else out)

				@pager.page = @page
				@pager.rows = @rows
				@pager.total = data.totalPages
				@pager.render()
			else
				DS.widget.main.$el.html(DS.tmpl(DS.tmpls.articles,
					id: @prefix + '-' + @cid
					d: data
					hasCategories: if not data.categories or not data.categories.length then false else true
					articlesPanel: if data.totalPages then DS.tmpl(DS.tmpls.articlesPanel, {}) else ''
					out: out
				) )

				if data.totalPages
					that = @
					tmpl = DS.tmpl(DS.tmpls.page)
					@pager = new DS.widget.pager(DS.$('.digiseller-paging', DS.widget.main.$el), {
						page: @page
						rows: @rows
						total: data.totalPages
						getLink: (page) ->
							return tmpl(
								page: page
								url: DS.opts.hashPrefix + "/articles/#{that.cid}/#{page}"
							)
						onChangeRows: (rows) ->
							DS.opts.rows = rows
							DS.cookie.set(that.prefix + '-rows', rows)

							that.page = 1
							that.rows = rows
							that.get()
							
							DS.historyClick.changeHashSilent(DS.opts.hashPrefix + "/articles/#{that.cid}/1")

							return

					}).render()

					DS.widget.currency.init()

					# DS.$("#digiseller-options select").on('change', ()->
						# $this = DS.$(@)
						# type = $this.attr('data-type')
						# DS.opts[type] = $this.val()
						# DS.cookie.set("#{that.prefix}-#{type}", DS.opts[type])
						# that.get()
					# ).each( (el) ->
						# $this = DS.$(el)
						# type = $this.attr('data-type')
						# $this.val(DS.opts[type])
					# )
					
					set = (param) ->
						$select = DS.$("#digiseller-#{param} select")
						$select.on('change', (e) ->
							DS.opts[param] = $select.val()
							DS.cookie.set(that.prefix + "-#{param}", DS.opts[param])
							that.get()
							
							return
						).val(DS.opts[param])
						
						return

					# params = ['sort', 'view']
					# for param in params
					DS.util.each(['sort', 'view'], (param) ->
						set(param)
						
						return
					)

			return
	article:
		url: '/detail(?:/([0-9]*))'
		comments: null
		id: null
		prefix: 'digiseller-article'
		action: (params) ->
			@id = params[1] or 0

			that = @
			# DS.JSONP.get(DS.opts.host + 'shop_product_info.asp', DS.widget.main.$el,
			DS.ajax('GET', DS.opts.host + 'shop_product_info.asp',
				$el: DS.widget.main.$el
				data:
					seller_id: DS.opts.seller_id
					product_id: @id
					currency: DS.opts.currency
				onLoad: (data) ->
					return off unless data

					that.render(data)
					DS.util.scrollUp()

					return
			)

			return

		render: (data) ->
			if not data or not data.product
				DS.widget.main.$el.html( DS.tmpl(DS.tmpls.nothing, {}) )

				return

			DS.widget.category.mark(data.product.category_id)
			DS.widget.main.$el.html( DS.tmpl(DS.tmpls.articleDetail,
				d: data.product
				buy: DS.tmpl(DS.tmpls.buy,
					d: data.product
					failPage: DS.util.enc(window.location)
					agree: DS.opts.agree
				)
			) )

			new DS.widget.calc(data.product.id, data.product.prices_unit)

			DS.widget.currency.init()

			that = @

			$container = DS.$("##{@prefix}-thumbs")
			if $container.length				
				$thumbs  = DS.$('a', $container)
				$preview = DS.$("##{@prefix}-img-preview")
				activeClass = 'digiseller-left-thumbs-active'
				onClick = ($el) ->
					type = $el.attr('data-type')
					index = parseInt( $el.attr('data-index') )
					id = if type is 'img' then $el.attr('href') else $el.attr('data-id')
					
					$prev = $thumbs.eq(index - 1)
					$next = $thumbs.eq(index + 1)
					
					DS.popup.open(type, (if type is 'img' then id else DS.tmpl(DS.tmpls.video,
							id: id
							type: type
						)),
						# if $thumbs and $thumbs[index - 1] then () -> onClick( $thumbs.eq(index - 1) ) else false,
						# if $thumbs and $thumbs[index + 1] then () -> onClick( $thumbs.eq(index + 1)) else false
						if $prev.length then () -> onClick($prev); return else false,
						if $next.length then () -> onClick($next); return else false					
					)

					return
				
				$thumbs.on('click', (e) ->
					DS.util.prevent(e)

					onClick( DS.$(@) )
					
					return
				).on('mouseover', (e) ->
					$this = DS.$(@)
					
					return if $this.attr('data-type') isnt 'img'				

					$thumbs.removeClass(activeClass, true)
					$this.addClass(activeClass)

					index = $this.attr('data-index')
					id = $this.attr('data-id')

					$preview
						.attr('data-index', index)
						.css( 'backgroundImage', $preview.css('backgroundImage').replace(/idp=[0-9]+&/, "idp=#{id}&") )
						
					# $previewImg.src = $previewImg.src.replace(/idp=[0-9]+&/, "idp=#{id}&")
					# console.dir($preview.style)
					
					return
				)
				
				$preview.on('click', (e) ->
					DS.util.prevent(e)

					index = parseInt( $preview.attr('data-index') )

					onClick( $thumbs.eq(index) )
					
					return
				)
				
				# if $preview.length
					#$previewImg = DS.dom.$('img', $preview)[0]

			return

		initComments: (callback) ->
			$el = DS.$("##{@prefix}-comments-#{@id}")
			
			if $el.attr('data-inited')
				callback() if callback
				
				return

			that = @
			rowsCookie = 'digiseller-comments-rows'
			@comments = new DS.widget.comments($el, @id, (data) ->				
				$el.attr('data-inited', 1)
				
				that.comments.$el.html( DS.tmpl(DS.tmpls.comments,
					totalGood: data.totalGood
					totalBad: data.totalBad
				) )

				callback() if callback

				DS.$('select', $el).on('change', (e) ->
					$this = DS.$(@)
					
					that.comments.page = 1
					that.comments.type = DS.$('option', $this).eq(@selectedIndex).val()
					that.comments.get()
					
					return
				)

				tmpl = DS.tmpl(DS.tmpls.pageComment)
				that.comments.pager = new DS.widget.pager(DS.$('.digiseller-paging', that.comments.$el), {
					page: that.comments.page
					rows: that.comments.rows
					total: data.totalPages
					getLink: (page) ->
						return tmpl(
							page: page
							url: '#'
						)
					onChangeRows: (rows) ->
						DS.cookie.set(rowsCookie, rows)

						that.comments.page = 1
						that.comments.rows = rows
						that.comments.get()

						return

				}).render()

				return
			)

			@comments.rows = DS.cookie.get(rowsCookie) || 10
			@comments.get()

			return

	reviews:
		url: '/reviews(?:/([0-9]*))?'
		comments: null
		id: ""
		prefix: 'digiseller-reviews'
		action: (params) ->
			if not @id or DS.$('#' + @id).length is 0
				@id = @prefix + "-#{DS.util.getUID()}"
				that = @
				@comments = new DS.widget.comments(DS.widget.main.$el, '', (data) ->
					that.initComments(data)
					DS.util.scrollUp()
					
					return
				)

			@comments.page = parseInt(params[1]) or 1
			@comments.rows = DS.cookie.get(@prefix + '-rows') || 10
			@comments.get()

			return

		initComments: (data) ->
			@comments.$el.html( DS.tmpl(DS.tmpls.reviews,
				id: @id
				totalGood: data.totalGood
				totalBad: data.totalBad
			) )

			that = @
			tmpl = DS.tmpl(DS.tmpls.pageReview)
			goToFirstPage = () ->
				DS.historyClick.changeHashSilent(DS.opts.hashPrefix + "/reviews/1")
				
				return
			
			@comments.pager = new DS.widget.pager(DS.$('.digiseller-paging', @comments.$el), {
				page: @comments.page
				rows: @comments.rows
				total: data.totalPages
				getLink: (page) ->
					return tmpl(
						page: page
						url: DS.opts.hashPrefix + "/reviews/#{page}"
					)

				onChangeRows: (rows) ->
					DS.cookie.set(that.prefix + '-rows', rows)

					that.comments.page = 1
					that.comments.rows = rows
					that.comments.get()
					
					goToFirstPage()

					return
					
			}).render()

			# DS.dom.addEvent(DS.dom.$( 'select', DS.$("##{@prefix}-type select") )[0], 'change', (e) ->
			$select = DS.$("##{@prefix}-type select")
			$select.on('change', (e) ->
				that.comments.page = 1
				# that.comments.type = DS.dom.$('option', @)[@selectedIndex].value
				that.comments.type = $select.val()
				that.comments.get()
				
				goToFirstPage()
				
				return
			)

			return

	contacts:
		url: '/contacts'
		action: (params) ->
			that = @
			# DS.JSONP.get(DS.opts.host + 'shop_contacts.asp', DS.widget.main.$el,
			DS.ajax('GET', DS.opts.host + 'shop_contacts.asp',
				$el: DS.widget.main.$el
				data:
					seller_id: DS.opts.seller_id
				onLoad: (data) ->
					off unless data

					DS.widget.main.$el.html( DS.tmpl(DS.tmpls.contacts,
						d: data
					) )

					DS.util.scrollUp()

					return
			)

			return

DS.eventsDisp =
	'click-comments-page': ($el, e) ->
		DS.util.prevent(e)

		page = $el.attr('data-page')

		DS.route.article.comments.page = page
		DS.route.article.comments.get()

		return

	'click-buy': ($el, e) ->
		DS.util.prevent(e)

		id = $el.attr('data-id')
		isForm = parseInt( $el.attr('data-form') )
		isCart = parseInt( $el.attr('data-cart') )
		
		prefixBuy = 'digiseller-buy'
		prefixCalc = 'digiseller-calc'

		if isForm
			$form = DS.$("##{prefixBuy}-form-#{id}")
			$error = DS.$("##{prefixBuy}-error-#{id}")
			$rules = DS.$("##{prefixCalc}-rules")

			if $rules.length
				isChecked = $rules.get(0).checked
				DS.opts.agree = if isChecked then 1 else 0
				DS.cookie.set('digiseller-agree', DS.opts.agree)

				if !isChecked
					return
			
			required$Els = {}
			data = DS.serialize($form.get(0), (el) ->
				$parent = DS.$(el).parent()
				
				if $parent.attr('data-required')
					required$Els[el.name] = $parent
			)

			error = no
			# DS.dom.klass('del', DS.dom.$('.digiseller-calc-line', $form), 'digiseller-calc-line-err', true)				
			DS.$(".#{prefixCalc}-line", $form).removeClass(prefixCalc + '-line-err')
			
			for name, $parent of required$Els
				continue unless DS.util.hasOwnProp(required$Els, name)
				
				if not data[name]
					error = yes
					$parent.addClass(prefixCalc + '-line-err')
			
			$error.html(if error then DS.opts.i18n['someFieldsRequired'] else '')
			# $error.style.display = if error then '' else 'none'
			$error[if error then 'show' else 'hide']()
			
			return if error
			
			if not isCart
				$form.get(0).submit()
			else
				# console.log(data.cart_uid)
				# console.log(DS.opts.cart_uid)
				data.cart_uid = DS.opts.cart_uid
				DS.ajax('POST', DS.opts.host + 'shop_cart_add.asp',
					data: data,
					onLoad: (res, xhr) ->
						if res.cart_err and res.cart_err isnt ''
							$error.html(res.cart_err).show()
							
							#!!!!!!!!!!!!!!!!!!!! return
						
						DS.opts.cart_uid = res.cart_uid || ''
						
						DS.cookie.set('digiseller-cart_uid', DS.opts.cart_uid)
						DS.widget.cartButton.setCount(res.cart_cnt)
						
						new DS.widget.cart()
						
						return
					# onFail: (xhr) ->
						# console.log('Ошибка:', xhr.responseText)
				)
		else
			ai = $el.attr('data-ai')

			buy = () ->
				window.open("https://www.oplata.info/asp/pay_x20.asp?id_d=#{id}&ai=#{ai}&dsn=limit", '_blank')				
				return

			if (DS.opts.agreement_text)
				DS.popup.open( 'text', DS.tmpl(DS.tmpls.agreement, {}) )

				DS.$('#digiseller-agree').on('click', () ->
					DS.agree(true, buy)					
					return
				)

				DS.$('#digiseller-disagree').on('click', () ->
					DS.agree(false)					
					return
				)
			else
				buy()

		return

	'click-article-tab': ($el, e) ->
		DS.util.prevent(e)

		index = $el.attr('data-tab')

		$panels = $el.parent().next().children()

		# DS.dom.klass('remove', $el.parentNode.children, 'digiseller-activeTab', true)
		$el.parent().children().removeClass('digiseller-activeTab')
		# DS.dom.klass('add', $el, 'digiseller-activeTab')
		$el.addClass('digiseller-activeTab')

		change = () ->
			# for $panel in $panels
				# $panel.style.display = 'none'
			$panels.hide().eq(index).show()

			# $panels.eq(index).style.display = ''
			
			return
		
		if index is '2'
			DS.route.article.initComments(change)
		else
			change()

		return

	'click-share': ($el, e) ->
		type = $el.attr('data-type')
		title = $el.attr('data-title')
		img = $el.attr('data-img')
		# console.log(DS.share[type](title, img))
		if DS.share[type]
			window.open( DS.share[type](title, img), "digisellerShare_#{type}", DS.util.getPopupParams(626, 436) )

		return

	'click-agreement': ($el, e) ->
		DS.util.prevent(e)

		DS.popup.open( 'text', DS.tmpl(DS.tmpls.agreement, {}) )

		DS.$('#digiseller-agree').on('click', () ->
			DS.agree(true)
			return
		)
		DS.$('#digiseller-disagree').on('click', () ->
			DS.agree(false)
			return
		)
		
		return

DS.inited = no
DS.init = ->
	return off if DS.inited
	DS.inited = yes

	getEl = (elName) ->
		return document.getElementsByTagName(elName)[0] || document.documentElement
	
	DS.el.head = getEl('html')
	DS.el.body = getEl('body')

	unless DS.$('#digiseller-css').length
		# DS.dom.getStyle(DS.opts.host + 'shop_css.asp?seller_id=' + DS.opts.seller_id, () ->
		# DS.dom.getStyle(DS.opts.host + 'shop_css_test.asp?seller_id=' + DS.opts.seller_id)		
		DS.dom.getStyle('css/default/test.css')
	
	DS.opts.currency = DS.cookie.get('digiseller-currency') or DS.opts.currency

	# params = ['sort', 'rows', 'view']
	# for param in params
	DS.util.each(['sort', 'rows', 'view'], (param) ->
		DS.opts[param] = DS.cookie.get(DS.route.articles.prefix + '-' + param) or DS.opts[param]
		
		return
	)
	
	DS.opts.agree = DS.cookie.get('digiseller-agree') or DS.opts.agree

	DS.opts.cart_uid = DS.cookie.get('digiseller-cart_uid') or DS.opts.cart_uid
	
	DS.widget.category.init()
	DS.widget.main.init()
	DS.widget.loader.init()
	DS.widget.search.init()
	DS.widget.lang.init()
	DS.widget.cartButton.init()
	
	# DS.dom.$('#digiseller-logo')?.innerHTML = DS.tmpl(DS.tmpls.logo,
	DS.$('#digiseller-logo').html( DS.tmpl(DS.tmpls.logo,
		logo_img: DS.opts.logo_img
	) )

	# DS.dom.$('#digiseller-topmenu')?.innerHTML = DS.tmpl(DS.tmpls.topmenu, {})
	DS.$('#digiseller-topmenu').html( DS.tmpl(DS.tmpls.topmenu, {}) )

	if not DS.widget.category.$el.length
		DS.widget.main.$el.addClass('digiseller-main-nocategory')

	# $cart = DS.dom.$('#digiseller-cart-btn')
	# if $cart
		# DS.opts.hasCart = true
		# $cart.innerHTML = DS.tmpl(DS.tmpls.cartButton, {})

	homeInited = false
	DS.historyClick.addRoute('#.*', (params) ->
		if homeInited
			return

		homeInited = true
		DS.route.home.action()

		return
	)

	for name, route of DS.route
		# continue if not route.url or not route.action
		continue if not DS.route.hasOwnProperty(name) or not route.url or not route.action

		((route) ->
			DS.historyClick.addRoute(DS.opts.hashPrefix + route.url, (params) ->
				homeInited = true
				route.action(params)

				return
			)

			return
		)(route)

	DS.historyClick.rootAlias(DS.opts.hashPrefix + '/home')
	DS.historyClick.start()
	
	if window.location.hash is ''
		DS.historyClick.reload()

	DS.historyClick.onGo = () ->
		DS.popup.close()			
		return
		
	return

# alias
window.DigiSeller = DS

checkReady = () ->
	setTimeout(() ->
		if document.readyState isnt 'loading'		
			DS.init()		
		else
			checkReady()
	, 1)
	
	return

checkReady()

# css = document.getElementById('digiseller-css')	
# checkReadyCss = () ->
	# console.log(css.readyState)
	
	# setTimeout(() ->
		# if css.readyState isnt 'loading'
			# _cssIsLoaded = true
		# else
			# checkReadyCss()
			
		# return
	# , 1)
	
	# return

# checkReadyCss()

return









# DigiSeller.opts.i18n =
	# 'termsOfService': 'Условия предоставления сервиса'
	# 'accept': 'Принять'
	# 'refuse': 'Отказаться'
	# 'leader!': 'Лидер продаж!',
	# 'action!': 'Акция!',
	# 'new!': 'Новинка!',
	# 'shop': 'Магазин',
	# 'prevArticle': 'предыдущий товар',
	# 'nextArticle': 'следующий товар',
	# 'shareInFacebook': 'Поделиться в Facebook',
	# 'shareInVK': 'Поделиться в вКонтакте',
	# 'shareInTwitter': 'Поделиться в Twitter',
	# 'shareInWME': 'Поделиться в Webmoney.Events',
	# 'numberOfSales': 'Количество продаж',
	# 'description': 'Описание',
	# 'discounts': 'Скидки',
	# 'reviews': 'Отзывы',
	# 'addInformation': 'Дополнительная информация',
	# 'discountsOnQuantityPurchases': 'Скидки от количества приобретаемого товара',
	# 'whenBuyingFrom': 'при покупке от',
	# 'discount': 'скидка',
	# 'priceFor': 'цена за',
	# 'discountLoyalCustomers': 'Cкидка постоянным покупателям',
	# 'amountOfPurchasesFrom': 'сумма покупок от'
	# 'buy': 'Купить',
	# 'notAvailable': 'Нет в наличии',
	# 'readMore': 'Подробнее',
	# 'sortBy': 'Сортировать по',
	# 'nameFromAToZ': 'названию от А до Я',
	# 'nameFromZToA': 'названию от Я до А',
	# 'priceFromLowToHigh': 'цене от низкой до высокой',
	# 'priceFromHighToLow': 'цене от высокой до низкой',
	# 'view': 'Вид',
	# 'tile': 'плитки',
	# 'list': 'список',
	# 'table': 'таблица',
	# 'iAgreeWithTerms': 'с «<a data-action="agreement" href="#">Условиями предоставления сервиса</a>» ознакомлен и согласен.',
	# 'iWillPay': 'заплачу',
	# 'iWillGet': 'получу',
	# 'paymentVia': 'оплата через',
	# 'from': 'от',
	# 'adminComment': 'Комментарий администратора',
	# 'show': 'Показать',
	# 'allReviews': 'Все отзывы',
	# 'positive': 'Положительные',
	# 'negative': 'Отрицательные',
	# 'contactInfo': 'Контактная информация',
	# 'phone': 'Телефон',
	# 'statusIcqUser': 'Статус ICQ пользователя',
	# 'currency': 'Валюта',
	# 'loading': 'Загрузка...',
	# 'myPurchases': 'Мои покупки',
	# 'customerReviews': 'Отзывы покупателей',
	# 'contacts': 'Контакты',
	# 'max': 'Максимум',
	# 'min': 'Минимум',
	# 'nothingFound': 'Ничего не найдено',
	# 'displayedOnThePage': 'Выводить на странице',
	# 'search': 'Поиск',
	# 'onRequest': 'По запросу',
	# 'foundArticles': 'найдено товаров'


	
	# 'required': 'Обязательно',
	# 'toCart': 'В корзину',
	# 'cart': 'Корзина',
	# 'nameOfArticle': 'Название товара',
	# 'cost': 'Цена',
	# 'count': 'Количество',
	# 'cartIsEmpty': 'Корзина пуста',
	# 'goToPay': 'Перейти к оплате',
	# 'inTotal': 'Итого',
	# 'someFieldsRequired': 'Заполнены не все поля'
	


# DigiSeller.opts.seller_id = 18728
# DigiSeller.opts.seller_id = 83991


# @$selectCurrency = DS.dom.$( 'select', DS.dom.$('#digiseller-currency') )[0]
# DS.dom.addEvent(@$selectCurrency, 'change', (e) ->
	# DS.opts.currency = DS.dom.$('option', that.$selectCurrency)[that.$selectCurrency.selectedIndex].value
	# DS.util.cookie.set('digiseller-currency', DS.opts.currency)
	# that.get()
# )



# 'click-comments-switch': ($el, e) ->
	# DS.util.prevent(e)

	# type = DS.dom.attr($el, 'data-type')

	# DS.route.article.comments.page = 1
	# DS.route.article.comments.type = type
	# DS.route.article.comments.get()

	# DS.dom.klass('remove', DS.dom.$('.digiseller-activeTab', e.target.parentNode.parentNode), 'digiseller-activeTab', true)
	# DS.dom.klass('add', $el, 'digiseller-activeTab')

	# return


# 'click-img-show': ($el, e) ->
	# DS.util.prevent(e)

	# href = DS.dom.attr($el.parentNode, 'href')
	# id = DS.dom.attr($el, 'data-id')
	# $preview = DS.dom.$('#digiseller-img-preview')

	# $preview.href = href
	# DS.dom.$('img', $preview)[0].src = "//graph.digiseller.ru/img.ashx?w=261&idp=#{id}"

	# return



# @$selectCurrency = DS.dom.$( 'select', DS.dom.$('#digiseller-currency') )[0]
# DS.dom.addEvent(@$selectCurrency, 'change', (e) ->
	# DS.opts.currency = DS.dom.$('option', that.$selectCurrency)[that.$selectCurrency.selectedIndex].value
	# DS.util.cookie.set('digiseller-currency', DS.opts.currency)
	# that.get()
# )




# https://github.com/mtrpcic/pathjs

	# DS.$el.shop.innerHTML = '<img src="' + DS.opts.host + DS.opts.loader + '" style="digiseller-loader" alt="" />'
	# DS.$el.shop.innerHTML = '<div id="digiseller-preloader">Загрузка...</div>'
	# DS.dom.getStyle(DS.opts.host + 'shop_css.asp?seller_id=?' + DS.opts.seller_id)
	# DS.dom.getScript(DS.opts.host + DS.opts.tmpl + '?' + Math.random(), ->






# sorting
# type = DS.opts.sort.replace('DESC', '')
# dir = if DS.opts.sort.search(/desc/i) > -1 then 'desc' else 'asc'

# $orders = DS.dom.$('a', DS.dom.$('#digiseller-sort'))
# for $order in $orders
	# DS.dom.klass('remove', $order, 'digiseller-sort-asc digiseller-sort-desc')
	# DS.dom.attr($order, 'data-dir', '')

	# if type and type is DS.dom.attr($order, 'data-type')
		# DS.dom.klass('add', $order, 'digiseller-sort-' + dir)
		# DS.dom.attr($order, 'data-dir', dir)





# sort: ($el, e) ->
	# DS.util.prevent(e)

	# type = DS.dom.attr($el, 'data-type')
	# dir = DS.dom.attr($el, 'data-dir')
	# dir = if dir is 'asc' then 'desc' else ''

	# DS.opts.sort = type + dir.toUpperCase()
	# DS.util.cookie.set('digiseller-articles-sort', DS.opts.sort)

	# DS.route.articles.page = 1
	# DS.route.articles.get()

	# return






# DS.dom.addEvent(DS.dom.$('.digiseller-prod-buybtn', DS.widget.main.$el, 'input')[0], 'click', (e) ->
	# DS.util.prevent(e)

	# window.open('//plati.ru', 'digisellerBuy', DS.util.getPopupParams(670, 500))

	# return
# )