###*
DigiSeller-ru-api
26.11.2014 (c) http://artod.ru
###

off if window.DigiSeller?

DS = {}

DS.$el =
	head: null
	body: null
	widget: null

DS.opts =
	seller_id: null
	host: '//shop.digiseller.ru/xml/new/'
	hashPrefix: '#!digiseller'
	currency: 'RUR'
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
		if (typeof exp == 'number' && exp) {
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
	getUID: ( ->
		id = 1
		return () -> id++
	)()

	enc: (t) ->
		return encodeURIComponent(t)

	prevent: (e) ->
		if e.preventDefault then e.preventDefault() else e.returnValue = false

		return

	extend: (target, source, overwrite) ->
		for key of source
			continue unless Object.prototype.hasOwnProperty.call(source, key)
			target[key] = source[key] if overwrite or typeof target[key] is 'object'

		return target

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

	cookie: DS.cookie # backward compatibility
	agree: DS.agree # backward compatibility

DS.dom =
	$: (selector, context, tagName) ->
		return unless selector

		type = selector.substring(0, 1)
		name = selector.substring(1)

		switch type
			when '#'
				document.getElementById(name)
			when '.'
				tagName = if tagName then tagName else '*'

				`if ( typeof document.getElementsByClassName !== 'function' ) {
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

	attr: ($el, attr, val) ->
		if not $el or typeof attr is 'undefined'
			return false

		if typeof val isnt 'undefined'
			$el.setAttribute(attr, val)
		else
			try
				return $el.getAttribute(attr)
			catch e
				return null

		return

	addEvent: ($el, e, callback) ->
		if $el.attachEvent
			ieCallback = (e) -> callback.call($el, e)
			$el.attachEvent('on' + e, ieCallback)

			return ieCallback

		else if $el.addEventListener
			$el.addEventListener(e, callback, false)

			return callback

		return

	removeEvent: ($el, e, callback) ->
		if $el.detachEvent
			$el.detachEvent("on#{e}", callback)
		else if $el.removeEventListener
			$el.removeEventListener(e, callback, false)

		return

	klass: (action, els, c, multy) ->
		`if (!els || !action) {
			return;
		}

		if (!multy) {
			els = [els];
		}

		var $el, _i, _len,
			re = new RegExp('(^|\\s)' + ( action === 'add' ? c : c.replace(' ', '|') ) + '(\\s|$)', 'g');

		for (_len = els.length, _i = _len-1; _i >= 0; _i--) {
			$el = els[_i];
			if ( action === 'add' && re.test($el.className) ) {
				continue;
			}

			$el.className = action === 'add' ? ($el.className + ' ' + c).replace(/\s+/g, ' ').replace(/(^ | $)/g, '') : $el.className.replace(re, "$1").replace(/\s+/g, " ").replace(/(^ | $)/g, "");
		}

		return els`

		return

	select: ($select, val) ->
		if typeof val is 'undefined'
			return DS.dom.$('option', $select)[$select.selectedIndex].value
		else
			$options = DS.dom.$('option', $select)
			for $option, i in $options
				if $option.value is val + ''
					$select.selectedIndex = i
					return

		return

	getStyle: (url, onLoad) ->
		link = document.createElement('link')
		link.type = 'text/css'
		link.rel = 'stylesheet'
		link.href = url

		DS.$el.head.appendChild(link)

		css = new Image()
		css.onerror = () ->
			onLoad() if onLoad
		css.src = url

		return

	# jQuery.getScript
	getScript: (url, onLoad, onError, onComplete) ->
		script = document.createElement('script')
		script.type = 'text/javascript'
		script.setAttribute('encoding', 'UTF-8')
		script.src = url

		done = no
		_onComplete = (e) ->
			# sasas = Math.random()*10000
			# console.log(sasas)
			# setTimeout(()->		
			
			done = yes
			script.onload = script.onreadystatechange = null

			DS.$el.head.removeChild(script) if DS.$el.head and script.parentNode
			# console.log('onComplete')
			onComplete() if onComplete
				
				
			# , sasas)
			
			
			
			return

		script.onload = script.onreadystatechange = (e) ->
			if ( not done and (not this.readyState or this.readyState is 'loaded' or this.readyState is 'complete') )
				_onComplete()
				onLoad() if onLoad

			return

		script.onerror = (e) ->
			_onComplete()
			onError if onError

			return

		DS.$el.head.appendChild(script)

		return

# https://gist.githubusercontent.com/bullgare/5336154/raw/e907dd47330d2af59e0a68f6fa272b4fdaa069ba/services.js
DS.serialize = (form, onEach) ->
	`if (!form || form.nodeName !== "FORM") {
		return;
	}

	var i, j,
		obj = {},
		enc = encodeURIComponent;

	for (i = form.elements.length - 1; i >= 0; i = i - 1) {
		if (form.elements[i].name === "") {
			continue;
		}
		
		switch (form.elements[i].nodeName) {
			case 'INPUT':
				switch (form.elements[i].type) {
					case 'text':
					case 'hidden':
					case 'password':
					case 'number':
						obj[form.elements[i].name] = enc(form.elements[i].value);
						break;
					case 'checkbox':
					case 'radio':
						if (form.elements[i].checked) {
							obj[form.elements[i].name] = enc(form.elements[i].value);
						}
						break;
					case 'file':
						break;
				}
				break;
			case 'TEXTAREA':
				obj[form.elements[i].name] = enc(form.elements[i].value);
				break;
			case 'SELECT':
				switch (form.elements[i].type) {
					case 'select-one':
						obj[form.elements[i].name] = enc(form.elements[i].value);
						break;
					case 'select-multiple':
						for (j = form.elements[i].options.length - 1; j >= 0; j = j - 1) {
							if (form.elements[i].options[j].selected) {
								obj[form.elements[i].name] = enc(form.elements[i].options[j].value);
							}
						}
						break;
				}
				break;
		}
		
		if (typeof onEach === 'function') {
			onEach(form.elements[i]);
		}
	}

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

		DS.dom.addEvent(window, 'hashchange', urlHashCheck);
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
		},
		changeHashSilent: function(hash) {
			historyClick.prevHash = historyClick.currentHash;
			historyClick.currentHash = window.location.hash = hash;
		}
	};

	return historyClick;
})()`

DS.ajax = (() ->
	`function createCORSRequest(method, url) {
		var xhr = new XMLHttpRequest();
		if ('withCredentials' in xhr) {
			xhr.open(method, url, true);
		} else if (typeof XDomainRequest !== 'undefined') {
			xhr = new XDomainRequest();
			xhr.open(method, url);
		} else {
			xhr = null;
		}
		
		//xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded; charset=UTF-8');
		
		return xhr;
	}
	
	function toQueryString(params) {
		var key,
			queryString = [];

		for (key in params) {
			queryString.push( ( DS.util.enc(key) + '=' + DS.util.enc(params[key]) ) );
		}

		return queryString.join('&');
	}`

	return (method, url, opts) ->
		opts = DS.util.extend(
			el: null
			data: {}
			onLoad: () ->
			onFail: () ->
			onComplete: () ->
		, opts, true)

		opts.data.transp = 'cors'	

		queryString = toQueryString(opts.data)
		
		xhr = createCORSRequest(method, if method is 'GET' then url + (if /\?/.test(url) then '&' else '?') + '_=' + Math.random() + queryString else url)

		uid = DS.util.getUID()

		DS.widget.loader.show(uid)
		
		_onComplete = () ->
			opts.onComplete()
			DS.widget.loader.hide(uid)

		if not xhr
			opts.data.transp = 'jsonp'
			DS.JSONP.get(url, opts.el, opts.data, opts.onLoad, opts.onFail, _onComplete)

			return

		needCheck = if opts.el then yes else no

		if needCheck
			DS.dom.attr(opts.el, 'data-qid', uid)

		xhr.onreadystatechange = () ->
			if (xhr.readyState is 4) 
				console.log(xhr.status)
			
			
		xhr.onload = () ->
			_onComplete()
			
			if needCheck and parseInt( DS.dom.attr(opts.el, 'data-qid') ) isnt uid
				return

			opts.onLoad(JSON.parse(xhr.responseText), xhr)

		xhr.onerror = () ->			
			_onComplete()			
			opts.onFail(xhr)

		xhr.send(queryString)

		xhr
)()

DS.JSONP = `(function() {
	var _callbacks = [];

	function jsonp(url, el, params, onLoad, onFail, onComplete) {
		var query = (url || '').indexOf('?') === -1 ? '?' : '&', key;

		params = params || {};

		var _uid = DS.util.getUID();
		params.queryId = _uid;

		for (key in params) {
			if ( !Object.prototype.hasOwnProperty.call(params, key) ) {
				continue;
			}

			query += DS.util.enc(key) + '=' + DS.util.enc(params[key]) + '&'
		}

		var needCheck = el ? true : false;

		if (needCheck) {
			DS.dom.attr(el, 'data-qid', _uid);
		}

		_callbacks[_uid] = function(data) {
			if ( needCheck && ( !el || data.queryId != DS.dom.attr(el, 'data-qid') ) ) {
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
	wrCallback = null
	leftCallback = null
	rightCallback = null
	isClosed = true

	show = (onResize) ->
		setup.$loader.style.display = 'none'
		setup.$container.style.display = ''

		wrCallback = DS.dom.addEvent(window, 'resize', onResize)
		onResize()

		return

	close = (e) ->
		DS.util.prevent(e) if e
		setup.$img.innerHTML = ''
		setup.$main.style.display = 'none'
		DS.dom.removeEvent(window, 'resize', wrCallback)
		isClosed = true
		img = null

		return

	resize = (h, w, isHard) ->
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

		setup.$container.style.width = ( (if isHard then w else w1) + 50) + 'px'

		doc = document.documentElement
		body = document.body
		topScroll = (doc && doc.scrollTop or body && body.scrollTop or 0)
		setup.$container.style.top = (hs - (if isHard then h else h1) + 20)/3 + topScroll + 'px'

		return

	init = () ->
		container = document.createElement('div')
		container.innerHTML = DS.tmpl(DS.tmpls.popup,
			p: prefix
		)

		(document.getElementsByTagName('body')[0] or document.documentElement).appendChild(container.firstChild);

		params = ['main', 'fade', 'loader', 'container', 'close', 'img', 'left', 'right']
		for param in params
			setup['$' + param] = document.getElementById(prefix + param)

		DS.dom.addEvent(setup.$fade, 'click', close)
		DS.dom.addEvent(setup.$close, 'click', close)

		return

	return {
		open: (type, id, onLeft, onRight) ->
			not setup.$main and  init()

			isClosed = false

			setup.$container.style.display = 'none'
			setup.$main.style.display = ''
			setup.$loader.style.display = ''

			setup.$left.style.display = if onLeft then '' else 'none'
			if onLeft
				DS.dom.removeEvent(setup.$left, 'click', leftCallback)
				leftCallback = DS.dom.addEvent(setup.$left, 'click', onLeft)

			setup.$right.style.display = if onRight then '' else 'none'
			if onRight
				DS.dom.removeEvent(setup.$right, 'click', rightCallback)
				rightCallback = DS.dom.addEvent(setup.$right, 'click', onRight)

			switch type
				when 'img'
					DS.dom.klass('remove', setup.$img, 'digiseller-popup-video')

					img = new Image()
					img.onload = () ->
						return if isClosed

						h = img.height
						w = img.width

						DS.dom.removeEvent(window, 'resize', wrCallback)

						show(() ->
							resize(h, w)
							return
						)

						setup.$img.innerHTML = ''
						setup.$img.appendChild(img)

					img.src = id

				else
					DS.dom.klass('add', setup.$img, 'digiseller-popup-video')

					show(() ->
						resize(200, 500, true)
						return
					)

					setup.$img.innerHTML = id

			return

		close: close
	}
)()

# http://habrahabr.ru/post/156185/
DS.share =
	vk: (title, img) ->
		return "//vkontakte.ru/share.php?
url=#{DS.util.enc(document.location)}&
title=#{DS.util.enc(title)}&
image=#{DS.util.enc(img)}&
noparse=true"

	tw: (title) ->
		return "//twitter.com/share?
text=#{DS.util.enc(title)}&
url=#{DS.util.enc(document.location)}"

	fb: (title, img) ->
		return "//www.facebook.com/sharer.php?s=100&
p[url]=#{DS.util.enc(document.location)}&
p[title]=#{DS.util.enc(title)}&
p[images][0]=#{DS.util.enc(img)}"

	wme: (title, img) ->
		return "//events.webmoney.ru/sharer.aspx?
url=#{DS.util.enc(document.location)}&
title=#{DS.util.enc(title)}&
image=#{DS.util.enc(img)}&
noparse=0"

DS.agree = (flag, onAgree) ->
	$rules = DS.dom.$('#digiseller-calc-rules')
	$rules.checked = flag if $rules

	DS.opts.agree = if flag then 1 else 0
	DS.cookie.set('digiseller-agree', DS.opts.agree)

	DS.popup.close()

	onAgree() if onAgree

	return

DS.showCart = () ->
	DS.popup.open( 'text', DS.tmpl(DS.tmpls.cart, {}) )
	
DS.widget =
	main:
		$el: null
		init: () ->
			@$el = DS.dom.$('#digiseller-main')
			DS.widget.main.$el.innerHTML = '' # сбрасываем лоадер

			callback = (e, type) ->
				$el = e.originalTarget or e.srcElement
				action = DS.dom.attr($el, 'data-action')

				if action and typeof DS.events[type + '-' + action] is 'function'
					DS.events[type + '-' + action]($el, e)

			DS.dom.addEvent(DS.widget.main.$el, 'click', (e) ->
				callback(e, 'click')
			)

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
				div.style.display = 'none'

				DS.$el.body.appendChild(div)

				@$el = DS.dom.$("##{div.id}")

				return

			show: (uid) ->
				that = @
				# console.log('show = ', uid)
				_timeouts[uid] = setTimeout(() ->
					_timeouts[uid] = 0
					_counter++
					that.$el.style.display = ''
					
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
					@$el.style.display = 'none'

				return
		}
	)()

	search:
		$el: null
		$input: null
		prefix: 'digiseller-search'
		init: () ->
			@$el = DS.dom.$("##{@prefix}")
			return unless @$el

			@$el.innerHTML = DS.tmpls.search

			@$input = DS.dom.$(".#{@prefix}-input", @$el, 'input')[0]
			form = DS.dom.$(".#{@prefix}-form", @$el, 'form')[0]

			that = @
			DS.dom.addEvent(form, 'submit', (e) ->
				DS.util.prevent(e)

				window.location.hash = DS.opts.hashPrefix + "/search?s=#{that.$input.value}"

				return
			)

			return

	lang:
		$el: null
		prefix: 'digiseller-langs'
		init: () ->
			@$el = DS.dom.$("##{@prefix}")
			return unless @$el

			@$el.innerHTML = DS.tmpl(DS.tmpls.langs, {})

			$links = DS.dom.$('a', @$el)
			for $link in $links
				DS.dom.addEvent($link, 'click', (e) ->
					DS.util.prevent(e)

					lang = DS.dom.attr(@, 'data-lang')

					DS.cookie.set('digiseller-lang', lang)

					window.location.reload()
				)

			return

	category:
		$el: null
		isInited: false
		prefix: 'digiseller-category'
		init: () ->
			@$el = DS.dom.$("##{@prefix}")
			return unless @$el

			@isInited = false

			that = @
			DS.ajax('GET', DS.opts.host + 'shop_categories.asp'
				el: @$el
				data:
					format: 'json'
					lang: DS.opts.currentLang
					seller_id: DS.opts.seller_id
				onLoad: (res) ->					
					return off unless res

					that.$el.innerHTML = that.render(res.category, null, 0)

					that.isInited = true

					that.mark()

					return
			)

			return

		mark: (() ->
			_go = (cid) ->
				$cats = DS.dom.$('li', @$el)

				return unless $cats.length

				subs = DS.dom.$('ul', @$el)
				for sub in subs
					sub.style.display = 'none'

				subs[0].style.display = ''

				DS.dom.klass('remove', $cats, @prefix + '-active', true)
				DS.dom.klass('remove', $cats, @prefix + '-active-hmenu', true)

				return unless cid

				$cat = DS.dom.$("##{@prefix}-#{cid}")
				return unless $cat

				DS.dom.klass('add', $cat, @prefix + '-active')

				$parent = $ancestor = $cat

				while $parent.id isnt @prefix
					$parent.style.display = ''
					$parent = $parent.parentNode

					if /li/i.test($parent.tagName)
						DS.dom.klass('add', $parent, @prefix + '-active-hmenu')

				DS.dom.$("##{@prefix}-sub-#{cid}")?.style.display = ''

				return

			return (cid) ->
				return unless @$el

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
			compileTmpl = DS.tmpl(DS.tmpls.category)
			for category in categories
				out += compileTmpl(
					d: category
					url: DS.opts.hashPrefix + "/articles/#{category.id}"
					id: @prefix + "-#{category.id}"
					sub: @render(category.sub, category.id)
				)

			DS.tmpl(DS.tmpls.categories,
				id: if parent_cid then @prefix + "-sub-#{parent_cid}" else ''
				out: out
			)

	currency:
		$el: null
		init: () ->
			@$el = DS.dom.$('#digiseller-currency')
			return unless @$el

			@$el.innerHTML = DS.tmpl(DS.tmpls.currency, {})

			$sel = DS.dom.$('select', @$el)[0]
			DS.dom.addEvent($sel, 'change', (e) ->
				type = DS.dom.attr(@, 'data-type')

				DS.opts.currency = DS.dom.select(@)
				DS.cookie.set('digiseller-currency', DS.opts.currency)
				DS.historyClick.reload()

				return
			)

			DS.dom.select($sel, DS.opts.currency)

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
			pages = DS.dom.$('a', @$el)

			for page, index in pages
				DS.dom.klass( (if @page == parseInt( DS.dom.attr(page, 'data-page') ) then 'add' else 'remove'), page, 'digiseller-activepage' )

			return @

		render: () ->
			@page = parseInt(@page)
			@rows = parseInt(@rows)
			@total = parseInt(@total)

			@$el.style.display = if @total then '' else 'none'


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

			@$el.innerHTML = DS.tmpl(@opts.tmpl,
				out: out
			)

			that = @
			$select = DS.dom.$('select', @$el)[0]
			DS.dom.addEvent($select, 'change', (e) ->
				that.rows = DS.dom.select(@)
				that.opts.onChangeRows(that.rows)
			)

			DS.dom.select($select, @rows)
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
			DS.JSONP.get(DS.opts.host + 'shop_reviews.asp', @$el,
				format: 'json'
				lang: DS.opts.currentLang
				seller_id: DS.opts.seller_id
				product_id: @product_id
				type: @type
				page: @page
				rows: @rows
			, (data) ->
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
				compileTmpl = DS.tmpl(DS.tmpls.comment)
				for comment in comments
					out += compileTmpl(
						d: comment
					)

			if @isInited
				@pager.page = @page
				@pager.rows = @rows
				@pager.total = data.totalPages
				@pager.render()
			else
				@init(data)
				@container = DS.dom.$('.digiseller-comments', @$el)[0]
				@isInited = true

			@container.innerHTML = out

			return
	calc: class
		_els = ['amount', 'cnt', 'cntSelect', 'currency', 'amountR', 'price', 'buy', 'limit', 'rules']
		_prefix = 'digiseller-calc'

		constructor: (@id) ->
			@$ = container: DS.dom.$("##{_prefix}")

			unless @$.container
				return

			for el in _els
				@$[el] = DS.dom.$("##{_prefix}-#{el}")

			that = @

			if @$.amount
				if @$.cnt
					DS.dom.addEvent( @$.amount, 'keyup', () -> that.get('amount') )
					DS.dom.addEvent( @$.cnt, 'keyup', () -> that.get('cnt') )

				if @$.cntSelect then DS.dom.addEvent( @$.cntSelect, 'change', () -> that.get('cnt') )

			DS.dom.addEvent(@$.currency, 'change', () ->
				if that.$.amount
					that.get()
				else if that.$.price
					that.$.price.innerHTML = DS.dom.attr(DS.dom.$('option', that.$.currency)[that.$.currency.selectedIndex], 'data-price')
			)

			rules = (flag) ->
				if that.$.rules
					DS.dom.klass( (if flag and not that.$.rules.checked then 'add' else 'remove'), that.$.rules.parentNode, 'digiseller-calc-confirmation-error' )

			DS.dom.addEvent( @$.buy, 'mouseover', () -> rules(true) )
			DS.dom.addEvent( @$.buy, 'mouseout', () -> rules(false) )

			return

		get: (type) ->
			that = @
			params =
				product_id: @id
				format: 'json'
				lang: DS.opts.currentLang

			if type is 'amount'
				params.amount = @$.amount.value
			else
				params.cnt = if @$.cntSelect then DS.dom.select(@$.cntSelect) else @$.cnt.value

				@checkMinMax(params.cnt)

			params.currency = DS.dom.select(@$.currency)

			DS.JSONP.get(DS.opts.host + 'shop_unit.asp', @$.container,
				params
			, (data) ->
				return off unless data

				that.render(data.prices_unit)

				return
			)

			return

		checkMinMax: (cnt) ->
			that = @
			cnt = parseInt(cnt)
			max = parseInt( DS.dom.attr(@$.buy, 'data-max') )
			min = parseInt( DS.dom.attr(@$.buy, 'data-min') )

			minmax = (val, flag) ->
				that.$.limit.style.display = ''
				DS.dom.attr(that.$.buy, 'data-action', '')

				that.$.limit.innerHTML = DS.tmpl(DS.tmpls.minmax,
					val: val
					flag: flag
				)

			if max and cnt > max
				minmax(max, true)

				return
			else if min and cnt < min
				minmax(min, false)

				return

			DS.dom.attr(@$.buy, 'data-action', 'buy')
			@$.limit.style.display = 'none'

			return

		render: (data) ->
			return off unless data

			@$.amount.value = data.unit_Amount if data.unit_Amount

			if @$.cnt && data.unit_Cnt
				@checkMinMax(data.unit_Cnt)
				@$.cnt.value = data.unit_Cnt

			if @$.cntSelect and data.unit_Currency
				DS.dom.select(@$.cntSelect, data.unit_Currency)

			@$.amountR.innerHTML = data.unit_AmountDesc

			return
			
	cartButton:
		$el: null
		init: () ->
			@$el = DS.dom.$('#digiseller-cart-btn')
			return unless @$el

			DS.opts.hasCart = true
			
			@$el.innerHTML = DS.tmpl(DS.tmpls.cartButton, {})

			$a = DS.dom.$('a', @$el)[0]
			DS.dom.addEvent($a, 'click', (e) ->
				DS.showCart()

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
			DS.JSONP.get(DS.opts.host + 'shop_products.asp', DS.widget.main.$el,
				format: 'json'
				lang: DS.opts.currentLang
				seller_id: DS.opts.seller_id
				category_id: 0
				rows: 10
				order: DS.opts.sort
				currency: DS.opts.currency
			, (data) ->
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
				compileTmpl = DS.tmpl( DS.tmpls['article' + DS.opts.main_view.charAt(0).toUpperCase() + DS.opts.main_view.slice(1)] )
				for article in articles
					out += compileTmpl(
						d: article
						url: DS.opts.hashPrefix + "/detail/#{article.id}"
						imgsize: if DS.opts.main_view is 'tile' then DS.opts.imgsize_firstpage else DS.opts.imgsize_listpage
					)

			DS.widget.main.$el.innerHTML = DS.tmpl(DS.tmpls.showcaseArticles,
				out: if DS.opts.main_view is 'table' then '<table class="digiseller-table">' + out + '</table>' else out
				categories: data.categories
			)

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

			DS.widget.search.$input.value = @search

			@get()

			return

		get: () ->
			that = @
			DS.JSONP.get(DS.opts.host + 'shop_search.asp', DS.widget.main.$el,
				format: 'json'
				lang: DS.opts.currentLang
				seller_id: DS.opts.seller_id # 83991
				currency: DS.opts.currency
				page: @page
				rows: @rows
				search: @search
			, (data) ->
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
				compileTmpl = DS.tmpl(DS.tmpls.searchResult)
				for article in articles
					out += compileTmpl(
						url: DS.opts.hashPrefix + "/detail/#{article.id}"
						d: article
					)

			container = DS.dom.$("##{@prefix}-results")

			if container
				container.innerHTML = out

				@pager.page = @page
				@pager.rows = @rows
				@pager.total = data.totalPages
				@pager.render()
			else
				DS.widget.main.$el.innerHTML = DS.tmpl(DS.tmpls.searchResults,
					totalItems: data.totalItems
					out: out
				)

				that = @
				@pager = new DS.widget.pager(DS.dom.$('.digiseller-paging', DS.widget.main.$el)[0],
					page: @page
					rows: @rows
					total: data.totalPages
					getLink: (page) ->
						return DS.tmpl(DS.tmpls.page,
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

			DS.dom.$("##{@prefix}-query").innerHTML = @search.replace('<', '&lt;').replace('>', '&gt;')
			DS.dom.$("##{@prefix}-total").innerHTML = data.totalItems

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
			DS.JSONP.get(DS.opts.host + 'shop_products.asp', DS.widget.main.$el,
				format: 'json'
				lang: DS.opts.currentLang
				seller_id: DS.opts.seller_id
				category_id: @cid
				page: @page
				rows: @rows
				order: DS.opts.sort
				currency: DS.opts.currency
			, (data) ->
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
				compileTmpl = DS.tmpl( DS.tmpls['article' + DS.opts.view.charAt(0).toUpperCase() + DS.opts.view.slice(1)] )
				for article in articles
					out += compileTmpl(
						d: article
						url: DS.opts.hashPrefix + "/detail/#{article.id}"
						imgsize: if DS.opts.view is 'tile' then DS.opts.imgsize_firstpage else DS.opts.imgsize_listpage
					)

			container = DS.dom.$("##{@prefix}-#{@cid}")
			if container
				container.innerHTML = if DS.opts.view is 'table' then '<table class="digiseller-table">' + out + '</table>' else out

				@pager.page = @page
				@pager.rows = @rows
				@pager.total = data.totalPages
				@pager.render()
			else
				DS.widget.main.$el.innerHTML = DS.tmpl(DS.tmpls.articles,
					id: @prefix + '-' + @cid
					d: data
					hasCategories: if not data.categories or not data.categories.length then false else true
					articlesPanel: if data.totalPages then DS.tmpl(DS.tmpls.articlesPanel, {}) else ''
					out: out
				)

				if data.totalPages
					that = @
					@pager = new DS.widget.pager(DS.dom.$('.digiseller-paging', DS.widget.main.$el)[0], {
						page: @page
						rows: @rows
						total: data.totalPages
						getLink: (page) ->
							return DS.tmpl(DS.tmpls.page,
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

					set = (param) ->
						$selectSort = DS.dom.$( 'select', DS.dom.$("#digiseller-#{param}") )[0]
						DS.dom.addEvent($selectSort, 'change', (e) ->
							DS.opts[param] = DS.dom.select(@)
							DS.cookie.set(that.prefix + "-#{param}", DS.opts[param])
							that.get()
						)
						DS.dom.select($selectSort, DS.opts[param])

					params = ['sort', 'view']
					for param in params
						set(param)

			return
	article:
		url: '/detail(?:/([0-9]*))'
		comments: null
		id: null
		prefix: 'digiseller-article'
		action: (params) ->
			@id = params[1] or 0

			that = @
			DS.JSONP.get(DS.opts.host + 'shop_product_info.asp', DS.widget.main.$el,
				format: 'json'
				lang: DS.opts.currentLang
				seller_id: DS.opts.seller_id
				product_id: @id
				currency: DS.opts.currency
			, (data) ->
				return off unless data

				that.render(data)
				DS.util.scrollUp()

				return
			)

			return

		render: (data) ->
			if not data or not data.product
				DS.widget.main.$el.innerHTML = DS.tmpl(DS.tmpls.nothing, {})

				return

			DS.widget.category.mark(data.product.category_id)
			DS.widget.main.$el.innerHTML = DS.tmpl(DS.tmpls.articleDetail,
				d: data.product
				buy: DS.tmpl(DS.tmpls.buy,
					d: data.product
					failPage: window.location
					agree: DS.opts.agree
				)
			)

			new DS.widget.calc(data.product.id, data.product.prices_unit)

			DS.widget.currency.init()

			that = @

			onClick = ($el) ->
				type = DS.dom.attr($el, 'data-type')
				index = parseInt( DS.dom.attr($el, 'data-index') )
				id = if type is 'img' then DS.dom.attr($el, 'href') else DS.dom.attr($el, 'data-id')

				DS.popup.open(type, (if type is 'img' then id else DS.tmpl(DS.tmpls.video,
					id: id
					type: type
				)),
					if $thumbs and $thumbs[index - 1] then () -> onClick($thumbs[index - 1]) else false,
					if $thumbs and $thumbs[index + 1] then () -> onClick($thumbs[index + 1]) else false
				)

				return

			$thumbs = false
			$container = DS.dom.$("##{@prefix}-thumbs")
			if $container
				$thumbs  = DS.dom.$('a', $container)
				for $thumb in $thumbs
					DS.dom.addEvent($thumb, 'click', (e) ->
						DS.util.prevent(e)

						onClick(@)
					)

					DS.dom.addEvent($thumb, 'mouseover', (e) ->
						return if DS.dom.attr(@, 'data-type') isnt 'img'

						activeClass = 'digiseller-left-thumbs-active';

						DS.dom.klass('remove', $thumbs, activeClass, true)
						DS.dom.klass('add', @, activeClass)

						index = DS.dom.attr(@, 'data-index')
						id = DS.dom.attr(@, 'data-id')

						DS.dom.attr($preview, 'data-index', index)
						# $previewImg.src = $previewImg.src.replace(/idp=[0-9]+&/, "idp=#{id}&")
						# console.dir($preview.style)
						$preview.style.backgroundImage = $preview.style.backgroundImage.replace(/idp=[0-9]+&/, "idp=#{id}&")
					)

			$preview = DS.dom.$("##{@prefix}-img-preview")
			if $preview
				#$previewImg = DS.dom.$('img', $preview)[0]
				DS.dom.addEvent($preview, 'click', (e) ->
					DS.util.prevent(e)

					index = parseInt( DS.dom.attr(@, 'data-index') )

					onClick($thumbs[index])
				)

			return

		initComments: (callback) ->
			$el = DS.dom.$("##{@prefix}-comments-" + @id)

			if DS.dom.attr($el, 'inited')
				callback() if callback
				return

			that = @
			@comments = new DS.widget.comments($el, @id, (data) ->
				DS.dom.attr($el, 'inited', 1)

				that.comments.$el.innerHTML = DS.tmpl(DS.tmpls.comments,
					totalGood: data.totalGood
					totalBad: data.totalBad
				)

				callback() if callback

				$selectType = DS.dom.$('select', $el)[0]
				DS.dom.addEvent($selectType, 'change', (e) ->
					that.comments.page = 1
					that.comments.type = DS.dom.$('option', @)[@selectedIndex].value
					that.comments.get()
				)

				that.comments.pager = new DS.widget.pager(DS.dom.$('.digiseller-paging', that.comments.$el)[0], {
					page: that.comments.page
					rows: that.comments.rows
					total: data.totalPages
					getLink: (page) ->
						return DS.tmpl(DS.tmpls.pageComment,
							page: page
							url: '#'
						)
					onChangeRows: (rows) ->
						DS.cookie.set('digiseller-comments-rows', rows)

						that.comments.page = 1
						that.comments.rows = rows
						that.comments.get()

						return

				}).render()

				return
			)

			@comments.rows = DS.cookie.get('digiseller-comments-rows') || 10
			@comments.get()

			return

	reviews:
		url: '/reviews(?:/([0-9]*))?'
		comments: null
		id: ""
		prefix: 'digiseller-reviews'
		action: (params) ->
			unless DS.dom.$('#' + @id)
				@id = @prefix + "-#{DS.util.getUID()}"
				that = @
				@comments = new DS.widget.comments(DS.widget.main.$el, '', (data) ->
					that.initComments(data)
					DS.util.scrollUp()
				)

			@comments.page = parseInt(params[1]) or 1
			@comments.rows = DS.cookie.get(@prefix + '-rows') || 10
			@comments.get()

			return

		initComments: (data) ->
			@comments.$el.innerHTML = DS.tmpl(DS.tmpls.reviews,
				id: @id
				totalGood: data.totalGood
				totalBad: data.totalBad
			)

			that = @
			@comments.pager = new DS.widget.pager(DS.dom.$('.digiseller-paging', @comments.$el)[0], {
				page: @comments.page
				rows: @comments.rows
				total: data.totalPages
				getLink: (page) ->
					return DS.tmpl(DS.tmpls.pageReview,
						page: page
						url: "#!digiseller/reviews/#{page}"
					)

				onChangeRows: (rows) ->
					DS.cookie.set(@prefix + '-rows', rows)

					that.comments.page = 1
					that.comments.rows = rows
					that.comments.get()

					return

			}).render()

			DS.dom.addEvent(DS.dom.$( 'select', DS.dom.$("##{@prefix}-type") )[0], 'change', (e) ->
				that.comments.page = 1
				that.comments.type = DS.dom.$('option', @)[@selectedIndex].value
				that.comments.get()
			)

			return

	contacts:
		url: '/contacts'
		action: (params) ->
			that = @
			DS.JSONP.get(DS.opts.host + 'shop_contacts.asp', DS.widget.main.$el,
				format: 'json'
				lang: DS.opts.currentLang
				seller_id: DS.opts.seller_id
			, (data) ->
				off unless data

				DS.widget.main.$el.innerHTML = DS.tmpl(DS.tmpls.contacts,
					d: data
				)

				DS.util.scrollUp()

				return
			)

			return

DS.events =
	'click-comments-page': ($el, e) ->
		DS.util.prevent(e)

		page = DS.dom.attr($el, 'data-page')

		DS.route.article.comments.page = page
		DS.route.article.comments.get()

		return

	'click-buy': ($el, e) ->
		DS.util.prevent(e)

		id = DS.dom.attr($el, 'data-id')
		form = parseInt( DS.dom.attr($el, 'data-form') )
		cart = parseInt( DS.dom.attr($el, 'data-cart') )

		if form
			$form = DS.dom.$("#digiseller-buy-form-#{id}")
			$error = DS.dom.$("#digiseller-buy-error-#{id}")
			$rules = DS.dom.$('#digiseller-calc-rules')
			
			if $rules
				DS.opts.agree = if $rules.checked then 1 else 0
				DS.cookie.set('digiseller-agree', DS.opts.agree)

				if !$rules.checked
					return
			
			if not cart
				$form.submit()
			else
				requiredEls = {}
				data = DS.serialize($form, ($el) ->
					$parent = $el.parentNode
					if ( DS.dom.attr($parent, 'data-required') )
						requiredEls[$el.name] = $parent
				)
				
				error = no
				DS.dom.klass('del', DS.dom.$('.digiseller-calc-line', $form), 'digiseller-calc-line-err', true)				
				for name, $parent of requiredEls
					if not data[name]
						error = yes
						DS.dom.klass('add', $parent, 'digiseller-calc-line-err')
 				
				$error.innerHTML  = if error then 'Заполнены не все поля' else ''
				$error.style.display = if error then '' else 'none'
				
				return if error					
				
				DS.ajax('POST', DS.opts.host + '',
					data: data,
					onLoad: (res) ->
						# console.dir('res', res)
					onFail: (xhr) ->
						console.dir(xhr)
				)				
		else
			ai = DS.dom.attr($el, 'data-ai')

			buy = () ->
				window.open("https://www.oplata.info/asp/pay_x20.asp?id_d=#{id}&ai=#{ai}&dsn=limit", '_blank')

			if (DS.opts.agreement_text)
				DS.popup.open( 'text', DS.tmpl(DS.tmpls.agreement, {}) )

				DS.dom.addEvent(DS.dom.$('#digiseller-agree'), 'click', () ->
					DS.agree(true, buy)
				)

				DS.dom.addEvent(DS.dom.$('#digiseller-disagree'), 'click', () ->
					DS.agree(false)
				)
			else
				buy()

		return

	'click-article-tab': ($el, e) ->
		DS.util.prevent(e)

		index = DS.dom.attr($el, 'data-tab')
		$panels = $el.parentNode.nextSibling.children

		DS.dom.klass('remove', $el.parentNode.children, 'digiseller-activeTab', true)
		DS.dom.klass('add', $el, 'digiseller-activeTab')

		change = () ->
			for $panel in $panels
				$panel.style.display = 'none'

			$panels[index].style.display = ''

		if index is '2'
			DS.route.article.initComments(change)
		else
			change()

		return

	'click-share': ($el, e) ->
		type = DS.dom.attr($el, 'data-type')
		title = DS.dom.attr($el, 'data-title')
		img = DS.dom.attr($el, 'data-img')
		if DS.share[type]
			window.open( DS.share[type](title, img), "digisellerShare_#{type}", DS.util.getPopupParams(626, 436) )

		return

	'click-agreement': ($el, e) ->
		DS.util.prevent(e)

		DS.popup.open('text', DS.tmpl(DS.tmpls.agreement, {}))

		DS.dom.addEvent( DS.dom.$('#digiseller-agree'), 'click', () -> DS.agree(true) )
		DS.dom.addEvent( DS.dom.$('#digiseller-disagree'), 'click', () -> DS.agree(false) )

DS.inited = no
DS.init = ->
	return off if DS.inited
	DS.inited = yes

	DS.$el.head = DS.dom.$('head')[0] || document.documentElement
	DS.$el.body = DS.dom.$('body')[0] || document.documentElement

	# DS.dom.getStyle(DS.opts.host + 'shop_css.asp?seller_id=' + DS.opts.seller_id, () ->

	DS.dom.getStyle('css/default/test.css', () ->
		DS.opts.currency = DS.cookie.get('digiseller-currency') or DS.opts.currency

		params = ['sort', 'rows', 'view']
		for param in params
			DS.opts[param] = DS.cookie.get(DS.route.articles.prefix + '-' + param) or DS.opts[param]

		DS.opts.agree = DS.cookie.get('digiseller-agree') or DS.opts.agree

		DS.widget.category.init()
		DS.widget.main.init()
		DS.widget.loader.init()
		DS.widget.search.init()
		DS.widget.lang.init()
		DS.widget.cartButton.init()

		DS.dom.$('#digiseller-logo')?.innerHTML = DS.tmpl(DS.tmpls.logo,
			logo_img: DS.opts.logo_img
		)

		DS.dom.$('#digiseller-topmenu')?.innerHTML = DS.tmpl(DS.tmpls.topmenu, {})

		if not DS.widget.category.$el
			DS.widget.main.$el.className = 'digiseller-main-nocategory'

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
			continue unless DS.route.hasOwnProperty(name) or route.url or route.action

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

		return
	)

	return

# alias
window.DigiSeller = DS

checkReady = ()->
	if document.readyState isnt 'loading'
		DS.init()
	else
		setTimeout(()->
			checkReady()
			return
		, 1)

checkReady()

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