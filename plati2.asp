
<%@ Language=VBScript %><!DOCTYPE html><html>
	<head>	
		<script>
			(function(d) {
				var gc = function(c) { return d.cookie.match(new RegExp("(?:^|; )digiseller-" + c + "=([^;]*)")); },
					m = gc('lang'), m1 = gc('cart_uid'),
					l = m ? '&lang=' + m[1] : '', c = m1 ? '&cart_uid=' + m1[1] : '',
					pl = (d.getElementsByTagName('head')[0] || d.documentElement),
					st = d.createElement('link'), s = d.createElement('script');				
				st.type = 'text/css'; st.rel = 'stylesheet'; st.id = 'digiseller-css'; st.href = 'template/new digiseller/css/style.css'; // st.href = '//shop.digiseller.ru/xml/shop_css.asp?seller_id=18728'; //
				s.async = true; s.id = 'digiseller-js'; s.src = '//www.digiseller.ru/shop_test/digiseller-api.js2.asp?seller_id=18728' + l + c;
				!d.getElementById(st.id) && pl.appendChild(st); !d.getElementById(s.id) && pl.appendChild(s);
			})(document);
		</script>
		
		<meta name="viewport" content="width=device-width, initial-scale=1" />

	</head>
	<body>
		<!-- <%
		Dim MyRandomNum
		Randomize
		MyRandomNum = Rnd
		Response.Write MyRandomNum
		%> 18728 -->
		
		<span class="digiseller-body" id="digiseller-body" data-cat="v" data-logo="1" data-downmenu="1" data-purchases="1" data-langs="1" data-cart="1" data-search="1"></span>
		
		
<!-- 		<div class="digiseller-buy-standalone" data-id="1304331" data-img="1" data-name="1" data-img-size="200" data-ai="1111111111111111111111" data-no-price="1" ></div>
		
		<br/>
		
		<div class="digiseller-buy-standalone" data-id="1914354" data-img="1" data-name="1" data-img-size="200" data-ai="1111111111111111111111" data-no-price="1" ></div>
		
		<br/>
		
		<div class="digiseller-buy-standalone" data-id="1892651" data-img="1" data-name="1" data-img-size="200" data-ai="1111111111111111111111" data-no-price="1" ></div>
		
		<br/>
		
		<div class="digiseller-buy-standalone" data-id="1829167" data-img="1" data-name="1" data-no-price="0" data-ai="123456"></div> -->
		
	</body>
</html>