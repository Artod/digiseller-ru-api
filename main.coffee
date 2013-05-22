###
DigiSeller-ru-api
22.03.2013 (c) http://artod.ru
###

((window, document) ->
	off if window.DigiSeller?

	DS = {}

	DS.$el =
		head: null
		body: null
		widget: null

	DS.opts =
		host: 'http://plati.ru'
		widgetId: 'digiseller-ru'
		# css: '/test/css/default/main.css'
		loader: '/test/img/loader.gif'
		hashPrefix: '#!digiseller'

	DS.util =
		extend: (target, source, overwrite) ->
			for key of source
				continue unless source.hasOwnProperty(key)
				target[key] = source[key] if overwrite or typeof target[key] is 'object'

			target

		getUID: ( ->
			id = 1
			() ->
				id++
		)()

		getPopupParams: (width, height) ->
			screenX = if typeof window.screenX isnt 'undefined' then window.screenX else window.screenLeft
			screenY = if typeof window.screenY isnt 'undefined' then window.screenY else window.screenTop
			outerWidth = if typeof window.outerWidth isnt 'undefined' then window.outerWidth else document.body.clientWidth
			outerHeight = if typeof window.outerHeight isnt 'undefined' then window.outerHeight else (document.body.clientHeight - 22)
			left = parseInt(screenX + ((outerWidth - width) / 2), 10)
			top = parseInt(screenY + ((outerHeight - height) / 2.5), 10)
			
			return "scrollbars=1, resizable=1, menubar=0, left=#{left}, top=#{top}, width=#{width}, height=#{height}, toolbar=0, status=0"

		cookie:
			get: (name) ->
				`var matches = document.cookie.match(new RegExp(
				  "(?:^|; )" + name.replace(/([\.$?*|{}\(\)\[\]\\\/\+^])/g, '\\$1') + "=([^;]*)"
				));

				return matches ? decodeURIComponent(matches[1]) : undefined;`

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

				value = encodeURIComponent(value);

				var updatedCookie = name + '=' + value;
				for (var propName in props) {
					updatedCookie += '; ' + propName;
					var propValue = props[propName];
					if (propValue !== true) {
						updatedCookie += '=' + propValue;
					}
				}

				document.cookie = updatedCookie;`

				return

			del: (name) ->
				@set(name, null, {expires: -1})

				return

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

		addEvent: ($el, event, callback) ->
			return unless $el

			if $el.attachEvent
				$el.attachEvent('on' + event, callback)
			else if $el.addEventListener
				$el.addEventListener(event, callback, false)

		removeEvent: ($el, event, callback) ->
			return unless $el

			if $el.detachEvent
				$el.detachEvent("on#{type}", callback)
			else if $el.removeEventListener
				$el.removeEventListener(event, callback, false)
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

			return els;`

			return

		select: ($select, val) ->
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
		getScript: (url, onLoad, onError) ->
			script = document.createElement('script')
			script.type = 'text/javascript'
			script.setAttribute('encoding', 'UTF-8')
			script.src = url

			done = no
			onComplite = (e) ->
				DS.widget.loader.hide()
				done = yes
				script.onload = script.onreadystatechange = null;

				DS.$el.head.removeChild(script) if DS.$el.head and script.parentNode

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

			DS.widget.loader.show()
			DS.$el.head.appendChild(script)

			return

	DS.widget =
		main:
			$el: null
		loader:
			$el: null
			timeout: null
			show: () ->
				unless @$el
					return

				that = @

				clearTimeout(@timeout)
				@timeout = setTimeout(() ->
					that.$el.style.display = ''
				, 1000)

				return

			hide: () ->
				unless @$el
					return

				clearTimeout(@timeout)
				@$el.style.display = 'none'

				return

		search:
			$el: null
			$input: null
			init: (@$el) ->
				form = DS.dom.$('.digiseller-search-form', @$el, 'form')[0]
				@$input = DS.dom.$('.digiseller-search-input', @$el, 'input')[0]

				self = @
				DS.dom.addEvent(form, 'submit', (e) ->
					if e.preventDefault then e.preventDefault() else e.returnValue = false

					window.location.hash = "#{DS.opts.hashPrefix}/search?s=" + self.$input.value

					return
				)

				return

		pager: class
			constructor: (@$el, opts) ->				
				opts = opts or {}

				@page = parseInt(opts.page) || 1
				@rows = parseInt(opts.rows) || 10
				@total = parseInt(opts.total) || 0

				@opts =
					tmpl: opts.tmpl || DS.tmpls.pages
					max: opts.max || 2
					getLink: opts.getLink || (page) -> return page
					onChangeRows: opts.onChangeRows || (rows) ->

				return

			mark: () ->
				pages = DS.dom.$('a', @$el)

				for page, index in pages
					DS.dom.klass((if @page == parseInt( DS.dom.attr(page, 'data-page') ) then 'add' else 'remove'), page, 'digiseller-activepage')

				return @

			render: () ->
				@page = parseInt(@page)
				@rows = parseInt(@rows)
				@total = parseInt(@total)
				
				@$el.style.display = if @total then '' else 'none'

				left = @page - @opts.max
				left = if left < 1 then 1 else left

				right = @page + @opts.max
				right = if right > @total then @total else right

				page = left

				out = ''
				while page <= right
					out += @opts.getLink(page)
					page++

				if left > 1
					out = @opts.getLink(1) + (if left > 2 then '<span>...</span>&nbsp;' else '') + out

				if right < @total
					out = out + (if right < @total - 1 then '<span>...</span>&nbsp;' else '') + @opts.getLink(@total)

				@$el.innerHTML = DS.tmpl(@opts.tmpl, out: out)

				that = @
				$select = DS.dom.$('select', @$el)[0]
				DS.dom.addEvent($select, 'change', (e) ->
					that.rows = DS.dom.$('option', $select)[$select.selectedIndex].value
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
				DS.JSONP.get('http://shop.digiseller.ru/xml/shop_reviews.asp', @$el,
					seller_id: DS.opts.seller_id
					product_id: @product_id
					format: 'json'
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
					for comment in comments
						out += DS.tmpl(DS.tmpls.comment, comment)

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

		category:
			$el: null
			isInited: false
			init: (@$el) ->
				@isInited = false

				that = @
				DS.JSONP.get('http://shop.digiseller.ru/xml/shop_categories.asp', @$el,
					seller_id: DS.opts.seller_id
					format: 'json'
				, (data) ->					
					return off unless data
					
					that.$el.innerHTML = that.render(data.category)

					that.isInited = true

					that.mark()

					return
				)

				return

			mark: (() ->
				go = (cid) ->
					cats = DS.dom.$('li', @$el)
					
					return unless cats.length

					subs = DS.dom.$('ul', @$el)
					for sub in subs
						sub.style.display = 'none'

					subs[0].style.display = ''

					DS.dom.klass('remove', cats, 'digiseller-activecat', true)

					return unless cid

					cat = DS.dom.$("#digiseller-category-#{cid}")

					return unless cat

					DS.dom.klass('add', cat, 'digiseller-activecat')

					parent = cat
					while parent.id isnt 'digiseller-category'
						parent.style.display = ''
						parent = parent.parentNode

					DS.dom.$("#digiseller-category-sub-#{cid}")?.style.display = ''

					return

				return (cid) ->					
					if @isInited
						go.call(@, cid)
					else
						that = @
						count = 0
						interval = setInterval( ->
							if that.isInited or count > 1000
								clearInterval(interval)
								if that.isInited
									go.call(that, cid)

							count++

							return

						, 50)

					return
			)()

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

				@get()

				return

			get: () ->
				that = @
				DS.JSONP.get('http://shop.digiseller.ru/xml/shop_products.asp', DS.widget.main.$el,
					seller_id: DS.opts.seller_id
					category_id: 0
					rows: 10
					format: 'json'
					order: DS.opts.sort
					currency: DS.opts.currency
				, (data) ->
					return off unless data

					that.render(data)

					return
				)

				return

			render: (data) ->
				out = ''

				articles = data.product

				if articles and articles.length
					for article in articles
						article.url = "#{DS.opts.hashPrefix}/detail/#{article.id}"
						out += DS.tmpl(DS.tmpls.showcaseArticle, article)

				DS.widget.main.$el.innerHTML = DS.tmpl(DS.tmpls.showcaseArticles,
					out: out
				)

		search:
			url: '/search(?:/([0-9]*))?\\?s=(.*)'
			header: null
			search: null
			page: null
			rows: null
			pager: null
			action: (params) ->
				@search = decodeURIComponent(params[2])
				@page = parseInt(params[1]) or 1
				@rows = DS.util.cookie.get('digiseller-search-rows') || 10

				DS.widget.category.mark()

				DS.widget.search.$input.value = @search

				@get()

				return

			get: () ->
				that = @
				DS.JSONP.get('http://shop.digiseller.ru/xml/shop_search.asp', DS.widget.main.$el,
					seller_id: 83991 #DS.opts.seller_id
					format: 'json'
					currency: DS.opts.currency
					page: @page
					rows: @rows
					search: @search
				, (data) ->
					return off unless data

					that.render(data)

					return
				)

				return

			render: (data) ->
				out = ''

				articles = data.product

				if not articles or not articles.length
					out = DS.tmpl(DS.tmpls.nothing, {})
				else
					for article in articles
						article.url = "#{DS.opts.hashPrefix}/detail/#{article.id}"
						out += DS.tmpl(DS.tmpls.searchResult, article)

				container = DS.dom.$('#digiseller-search-results')

				if container
					container.innerHTML = out

					@pager.page = @page
					@pager.rows = @rows
					@pager.total = data.totalPages
					@pager.render()
				else
					DS.widget.main.$el.innerHTML = DS.tmpl(DS.tmpls.searchResults, out: out)

					@header = DS.dom.$('.digiseller-search-query', DS.widget.main.$el, 'span')[0]

					that = @
					@pager = new DS.widget.pager(DS.dom.$('.digiseller-paging', DS.widget.main.$el)[0],
						page: @page
						rows: @rows
						total: data.totalPages
						getLink: (page) ->
							return DS.tmpl(DS.tmpls.page,
								page: page
								url: "#{DS.opts.hashPrefix}/search/#{page}?s=#{that.search}"
							)

						onChangeRows: (rows) ->
							DS.util.cookie.set('digiseller-search-rows', rows)

							that.page = 1
							that.rows = rows
							that.get()

							DS.historyClick.changeHashSilent("#{DS.opts.hashPrefix}/search/1?s=#{that.search}")

							return

					).render()

					DS.dom.select(DS.dom.$( 'select', DS.dom.$('#digiseller-currency') )[0], DS.opts.currency)
					
					# @$selectCurrency = DS.dom.$( 'select', DS.dom.$('#digiseller-currency') )[0]
					### DS.dom.addEvent(@$selectCurrency, 'change', (e) ->
						DS.opts.currency = DS.dom.$('option', that.$selectCurrency)[that.$selectCurrency.selectedIndex].value
						DS.util.cookie.set('digiseller-currency', DS.opts.currency)
						that.get()
					) ###

				@header.innerHTML = @search.replace('<', '&lt;').replace('>', '&gt;')

				return

		articles:
			url: '/articles/([0-9]*)(?:/([0-9]*))?'
			cid: null
			page: 1
			rows: 10
			pager: null
			pagerComments: null
			# $selectCurrency: null
			action: (params) ->
				@cid = params[1]
				@page = parseInt(params[2]) or 1
				@rows = DS.util.cookie.get('digiseller-articles-rows') || @rows

				@get()

				return

			get: () ->
				DS.widget.category.mark(@cid)

				that = @
				DS.JSONP.get('http://shop.digiseller.ru/xml/shop_products.asp', DS.widget.main.$el,
					seller_id: DS.opts.seller_id
					format: 'json'
					category_id: @cid
					page: @page
					rows: @rows
					order: DS.opts.sort
					currency: DS.opts.currency
				, (data) ->
					return off unless data

					that.render(data)

					return
				)

				return

			render: (data) ->
				out = ''

				articles = data.product
				unless articles
					out = DS.tmpl(DS.tmpls.nothing, {})
				else
					for article in articles
						article.url = "#{DS.opts.hashPrefix}/detail/#{article.id}"

						out += DS.tmpl(DS.tmpls.article, article)

				container = DS.dom.$("#digiseller-articles-#{@cid}")
				if container
					container.innerHTML = out

					@pager.page = @page
					@pager.rows = @rows
					@pager.total = data.totalPages
					@pager.render()
				else
					DS.widget.main.$el.innerHTML = DS.tmpl(DS.tmpls.articles,
						id: "digiseller-articles-#{@cid}"
						breadCrumbs: data.breadCrumbs
						out: out
					)

					that = @
					@pager = new DS.widget.pager(DS.dom.$('.digiseller-articles-pager', DS.widget.main.$el)[0], {
						page: @page
						rows: @rows
						total: data.totalPages
						getLink: (page) ->
							return DS.tmpl(DS.tmpls.page,
								page: page
								url: "#{DS.opts.hashPrefix}/articles/#{that.cid}/#{page}"
							)
						onChangeRows: (rows) ->
							DS.util.cookie.set('digiseller-articles-rows', rows)

							that.page = 1
							that.rows = rows
							that.get()

							DS.historyClick.changeHashSilent("#{DS.opts.hashPrefix}/articles/#{that.cid}/1")

							return

					}).render()

					DS.dom.select(DS.dom.$( 'select', DS.dom.$('#digiseller-currency') )[0], DS.opts.currency)
					# @$selectCurrency = DS.dom.$( 'select', DS.dom.$('#digiseller-currency') )[0]
					### DS.dom.addEvent(@$selectCurrency, 'change', (e) ->
						DS.opts.currency = DS.dom.$('option', that.$selectCurrency)[that.$selectCurrency.selectedIndex].value
						DS.util.cookie.set('digiseller-currency', DS.opts.currency)
						that.get()
					) ###

					$selectSort = DS.dom.$( 'select', DS.dom.$('#digiseller-sort') )[0]
					DS.dom.addEvent($selectSort, 'change', (e) ->
						DS.opts.sort = DS.dom.$('option', $selectSort)[$selectSort.selectedIndex].value
						DS.util.cookie.set('digiseller-articles-sort', DS.opts.sort)
						that.get()
					)
					DS.dom.select($selectSort, DS.opts.sort)

				return
		article:
			url: '/detail(?:/([0-9]*))'
			comments: null
			id: null
			action: (params) ->
				@id = params[1] or 0

				that = @
				DS.JSONP.get('http://shop.digiseller.ru/xml/shop_product_info.asp', DS.widget.main.$el,
					seller_id: DS.opts.seller_id
					format: 'json'
					product_id: @id
					currency: DS.opts.currency
				, (data) ->
					return off unless data
					
					that.render(data)

					return
				)

				return

			render: (data) ->
				if not data or not data.product
					DS.widget.main.$el.innerHTML = DS.tmpl(DS.tmpls.nothing, {})
					return

				DS.widget.category.mark(data.product.category_id)

				DS.widget.main.$el.innerHTML = DS.tmpl(DS.tmpls.articleDetail, data.product)
				
				DS.dom.select(DS.dom.$( 'select', DS.dom.$('#digiseller-currency') )[0], DS.opts.currency)
				
				DS.dom.addEvent(, 'click', (e) ->
					href = DS.dom.attr($el.parentNode, 'href')
					id = DS.dom.attr($el, 'data-id')
					$preview = DS.dom.$('#digiseller-img-preview')			
					
					$preview.href = href
					DS.dom.$('img', $preview)[0].src = "http://graph.digiseller.ru/img.ashx?w=261&idp=#{id}"
				)
				
				return
				
			initComments: () ->
				$el = DS.dom.$('#digiseller-article-comments-' + @id)
				
				if DS.dom.attr($el, 'inited')					
					return					
				
				that = @
				@comments = new DS.widget.comments($el, @id, (data, out) ->
					DS.dom.attr($el, 'inited', 1)
					
					that.comments.$el.innerHTML = DS.tmpl(DS.tmpls.comments, {})
					
					$selectType = DS.dom.$('select', $el)[0]
					DS.dom.addEvent($selectType, 'change', (e) ->
						that.comments.page = 1
						that.comments.type = DS.dom.$('option', $selectType)[$selectType.selectedIndex].value
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
							DS.util.cookie.set('digiseller-comments-rows', rows)

							that.comments.page = 1
							that.comments.rows = rows
							that.comments.get()

							return

					}).render()

					return
				)

				@comments.get()
				
				return

		reviews:
			url: '/reviews(?:/([0-9]*))?'
			comments: null
			id: ""
			action: (params) ->
				unless DS.dom.$('#' + @id)
					@id = "digiseller-reviews-#{DS.util.getUID()}"
					that = @
					@comments = new DS.widget.comments(DS.widget.main.$el, '', (data) ->
						that.initComments(data)
					)

				@comments.page = parseInt(params[1]) or 1
				@comments.rows = DS.util.cookie.get('digiseller-reviews-rows') || DS.opts.rows
				@comments.get()

				return

			initComments: (data) ->
				@comments.$el.innerHTML = DS.tmpl(DS.tmpls.reviews, {id: @id})

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
						DS.util.cookie.set('digiseller-reviews-rows', rows)

						that.comments.page = 1
						that.comments.rows = rows
						that.comments.get()

						return

				}).render()

				$selectType = DS.dom.$( 'select', DS.dom.$('#digiseller-reviews-type') )[0]
				DS.dom.addEvent($selectType, 'change', (e) ->
					that.comments.page = 1
					that.comments.type = DS.dom.$('option', $selectType)[$selectType.selectedIndex].value
					that.comments.get()
				)

				return

		contacts:
			url: '/contacts'
			action: (params) ->
				that = @
				DS.JSONP.get('http://shop.digiseller.ru/xml/shop_contacts.asp', DS.widget.main.$el,
					seller_id: DS.opts.seller_id
					format: 'json'
				, (data) ->
					off unless data
					
					DS.widget.main.$el.innerHTML = DS.tmpl(DS.tmpls.contacts, data)

					return
				)
				
				return
				

	DS.events =
		### 'click-comments-switch': ($el, e) ->
			if e.preventDefault then e.preventDefault() else e.returnValue = false

			type = DS.dom.attr($el, 'data-type')

			DS.route.article.comments.page = 1
			DS.route.article.comments.type = type
			DS.route.article.comments.get()

			DS.dom.klass('remove', DS.dom.$('.digiseller-activeTab', e.target.parentNode.parentNode), 'digiseller-activeTab', true)
			DS.dom.klass('add', $el, 'digiseller-activeTab')

			return ###

		'click-comments-page': ($el, e) ->
			if e.preventDefault then e.preventDefault() else e.returnValue = false

			page = DS.dom.attr($el, 'data-page')

			DS.route.article.comments.page = page
			DS.route.article.comments.get()

			return

		'click-buy': ($el, e) ->
			if e.preventDefault then e.preventDefault() else e.returnValue = false

			id = DS.dom.attr($el, 'data-id')

			window.open("https://www.oplata.info/asp/pay_x20.asp?id_d=#{id}&dsn=limit", 'digiseller', DS.util.getPopupParams(885, 600))

			return			
		
		### 'click-img-show': ($el, e) ->			
			if e.preventDefault then e.preventDefault() else e.returnValue = false

			href = DS.dom.attr($el.parentNode, 'href')
			id = DS.dom.attr($el, 'data-id')
			$preview = DS.dom.$('#digiseller-img-preview')			
			
			$preview.href = href
			DS.dom.$('img', $preview)[0].src = "http://graph.digiseller.ru/img.ashx?w=261&idp=#{id}"

			return ###
			
		'click-article-tab': ($el, e) ->
			if e.preventDefault then e.preventDefault() else e.returnValue = false
			
			index = DS.dom.attr($el, 'data-tab')
			$panels = $el.parentNode.nextSibling.children
			
			DS.dom.klass('remove', $el.parentNode.children, 'digiseller-activeTab', true)				
			DS.dom.klass('add', $el, 'digiseller-activeTab')
			
			for $panel in $panels
				$panel.style.display = 'none'				
				
			$panels[index].style.display = ''

			DS.route.article.initComments() if index is '1'				

			return
			
		'change-currency': ($el, e) ->
			type = DS.dom.attr($el, 'data-type')
			
			DS.opts.currency = DS.dom.$('option', $el)[$el.selectedIndex].value
			DS.util.cookie.set("digiseller-currency", DS.opts.currency)
			DS.historyClick.reload()

	inited = no
	DS.init = ->
		return off if inited
		inited = yes

		DS.$el.head = DS.dom.$('head')[0] || document.documentElement
		DS.$el.body = DS.dom.$('body')[0] || document.documentElement
		DS.$el.shop = DS.dom.$("##{DS.opts.widgetId}")
		
		DS.dom.getStyle(DS.opts.host + '/test/css/default/main.css?seller_id=' + DS.opts.seller_id, () -> # + '?' + Math.random()			
			DS.opts.currency = DS.util.cookie.get('digiseller-currency') or DS.opts.currency
			DS.opts.sort = DS.util.cookie.get('digiseller-articles-sort') or DS.opts.sort # name, nameDESC, price, priceDESC

			DS.$el.shop.innerHTML = DS.tmpl(DS.tmpls.main, DS.opts)

			DS.widget.main.$el = DS.dom.$('#digiseller-main')
			DS.widget.loader.$el = DS.dom.$('#digiseller-loader')
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
		
		callback = (e, type) ->
			el = e.originalTarget or e.srcElement
			action = DS.dom.attr(el, 'data-action')
			
			if action and typeof DS.events[type + '-' + action] is 'function'
				DS.events[type + '-' + action](el, e)		
		
		DS.dom.addEvent(DS.$el.shop, 'click', (e) ->			
			callback(e, 'click')
		)
		
		DS.dom.addEvent(DS.$el.shop, 'change', (e) ->
			callback(e, 'change')
		)

		return


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
					historyClick.params = hash.match(pattern)
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
	DS.JSONP = `(function() {
		var _uid = 0, _callbacks = [];

		function encode(str) {
			return encodeURIComponent(str);
		}

		function jsonp(url, el, params, callback) {
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
			
			var needCheck = el ? true : false;
			
			if (needCheck) {				
				DS.dom.attr(el, 'data-qid', _uid);
			}
			
			_callbacks[_uid] = function(data) {
				if ( needCheck && ( !el || _uid != DS.dom.attr(el, 'data-qid') ) ) {
					return;
				}
				
				callback(data);
			};

			DS.dom.getScript( url + query + '_' + Math.random() );
			
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

# DigiSeller.opts.seller_id = 18728
# DigiSeller.opts.seller_id = 83991






# https://github.com/mtrpcic/pathjs

	# DS.$el.shop.innerHTML = '<img src="' + DS.opts.host + DS.opts.loader + '" style="digiseller-loader" alt="" />'
	# DS.$el.shop.innerHTML = '<div id="digiseller-preloader">Загрузка...</div>'
	# DS.dom.getStyle('//shop.digiseller.ru/xml/shop_css.asp?seller_id=?' + DS.opts.seller_id)
	# DS.dom.getScript(DS.opts.host + DS.opts.tmpl + '?' + Math.random(), ->
	

# sorting
### type = DS.opts.sort.replace('DESC', '')
dir = if DS.opts.sort.search(/desc/i) > -1 then 'desc' else 'asc'

$orders = DS.dom.$('a', DS.dom.$('#digiseller-sort'))
for $order in $orders
	DS.dom.klass('remove', $order, 'digiseller-sort-asc digiseller-sort-desc')
	DS.dom.attr($order, 'data-dir', '')

	if type and type is DS.dom.attr($order, 'data-type')
		DS.dom.klass('add', $order, 'digiseller-sort-' + dir)
		DS.dom.attr($order, 'data-dir', dir) ###

### sort: ($el, e) ->
	if e.preventDefault then e.preventDefault() else e.returnValue = false

	type = DS.dom.attr($el, 'data-type')
	dir = DS.dom.attr($el, 'data-dir')
	dir = if dir is 'asc' then 'desc' else ''

	DS.opts.sort = type + dir.toUpperCase()
	DS.util.cookie.set('digiseller-articles-sort', DS.opts.sort)

	DS.route.articles.page = 1
	DS.route.articles.get()

	return
###

### DS.dom.addEvent(DS.dom.$('.digiseller-prod-buybtn', DS.widget.main.$el, 'input')[0], 'click', (e) ->
	if e.preventDefault then e.preventDefault() else e.returnValue = false

	window.open('//plati.ru', 'digiseller', DS.util.getPopupParams(670, 500))

	return
) ###