<%@ Language=VBScript %><html>
	<head>	
		<!--script>
			(function(d) {
				var m = d.cookie.match(new RegExp("(?:^|; )digiseller-lang=([^;]*)")),
					m1 = d.cookie.match(new RegExp("(?:^|; )digiseller-cart_uid=([^;]*)")),
					l = m ? '&lang=' + m[1] : '',
					c = m1 ? '&cart_uid=' + m1[1] : '',
					s = d.createElement('script');

				s.async = true; s.src = '//www.digiseller.ru/shop_test/digiseller-api.js.asp?seller_id=18728' + l + c;				
				(d.getElementsByTagName('head')[0] || d.documentElement).appendChild(s);
			})(document);
		</script-->
		
		<!--script type="text/javascript" src="//www.digiseller.ru/shop_test/digiseller-api.js.asp?seller_id=18728"></script-->
		
		<script>
			(function(d) {
				var m = d.cookie.match(new RegExp("(?:^|; )digiseller-lang=([^;]*)")),
					m1 = d.cookie.match(new RegExp("(?:^|; )digiseller-cart_uid=([^;]*)")),
					l = m ? '&lang=' + m[1] : '', c = m1 ? '&cart_uid=' + m1[1] : '',
					pl = (d.getElementsByTagName('head')[0] || d.documentElement),
					s = d.createElement('script'),
					st = d.createElement('link');				
				st.type = 'text/css', st.rel = 'stylesheet', st.id = 'digiseller-css', st.href = 'css/default/test.css'; // st.href = '//shop.digiseller.ru/xml/shop_css.asp?seller_id=18728';  //
				s.async = true; s.src = '//www.digiseller.ru/shop_test/digiseller-api.js.asp?seller_id=18728' + l + c;
				pl.appendChild(st); pl.appendChild(s);
			})(document);
		</script>
		
	</head>
	<body>
		<!-- <%
		Dim MyRandomNum
		Randomize
		MyRandomNum = Rnd
		Response.Write MyRandomNum
		%> 18728 -->
		

		
		
		<div id="digiseller-logo" class="digiseller-logo"></div>
		
		<div id="digiseller-langs" class="digiseller-langs"></div>
		
		<div id="digiseller-cart-btn" class="digiseller-cart-btn"></div>
		
		<div id="digiseller-search" class="digiseller-search"></div>

		<div id="digiseller-topmenu" class="digiseller-topmenu"></div>
		
		<div id="digiseller-category" class="digiseller-category"></div>
		
		<div id="digiseller-main" class="digiseller-main">
			<div style="text-align:center;"><img src="http://www.digiseller.ru/shop/img/preloader.gif" alt="Загрузка..." /></div>
			<noscript>Ваш браузер не поддерживает JavaScript.</noscript>
		</div>
		
	</body>
</html>