DigiSeller.tmpls = {
article: '<div class="digiseller-product"><div class="digiseller-pricelabel"><span class="digiseller-article-cost"><? if (d.collection == \'unit\') { ?> �� <? } ?> <?= d.price ?></span><span class="digiseller-currency"><?= d.currency ?></span><? if (d.is_available) { ?><a class="digiseller-buyButton" data-action="buy" data-id="<?= d.id ?>">������</a><? } else { ?><a class="digiseller-buyButton-empty">��� � �������</a><? } ?></div><div class="digiseller-article-img" style="width:<?= 17 + imgsize ?>px;"><a href="<?= url ?>"><img src="http://graph.digiseller.ru/img.ashx?id_d=<?= d.id ?>&maxlength=<?= imgsize ?>" alt="<?= d.name ?>" /></a></div><div class="digiseller-browseProdTitle"><a href="<?= url ?>"><?= d.name ?>&nbsp;<? switch(d.label) {case \'top\': ?><span class="digiseller-labellider">����� ������!</span><? break;case \'sale\': ?><span class="digiseller-labelaction">�����!</span><? break;case \'new\': ?><span class="digiseller-labelnew">�������!</span><? break;} ?></a><p><?= d.info ?><br /><br /><a href="<?= url ?>" class="digiseller-product-details" title="<?= d.name ?>">��������� �</a></p></div></div>',articleDetail: '<? var mainImg = d.preview_imgs && d.preview_imgs[0] ? d.preview_imgs[0].url : \'\' ?><? var reviewsCount = parseInt(d.statistics.good_reviews) + parseInt(d.statistics.bad_reviews); ?><? var price = (d.collection == \'unit\' ? \'�� \' : \'\') + d.price + \' \' + d.currency ?><div class="digiseller-productpge"><div class="digiseller-options"><span class="digiseller-social"><a class="digiseller-social-fb" title="���������� � facebook" data-action="share" data-type="fb" data-title="<?= d.name ?> / <?= price ?>" data-img="<?= mainImg ?>"></a><a class="digiseller-social-vk" title="���������� � ���������" data-action="share" data-type="vk" data-title="<?= d.name ?> / <?= price ?>" data-img="<?= mainImg ?>"></a><a class="digiseller-social-tw" title="���������� � twitter" data-action="share" data-type="tw" data-title="<?= d.name ?> / <?= price ?>"></a><a class="digiseller-social-wm" title="���������� � Webmoney.Events" data-action="share" data-type="wme" data-title="<?= d.name ?> / <?= price ?>" data-img="<?= mainImg ?>"></a></span><div id="digiseller-currency"><span>������: </span><select data-action="currency"><option value="RUR">RUR</option><option value="USD">USD</option><option value="EUR">EUR</option><option value="UAH">UAH</option></select></div></div><div class="digiseller-breadcrumbs"><a title="�������" href="#!digiseller/home">�������</a> &gt;&nbsp;<? if (d.breadCrumbs) {for (var i = 0, l = d.breadCrumbs.length; i < l - 1; i++) { ?><a title="<?= d.breadCrumbs[i].name ?>" href="#!digiseller/articles/<?= d.breadCrumbs[i].id ?>"><?= d.breadCrumbs[i].name ?></a> &gt;&nbsp;<? } ?><a title="<?= d.breadCrumbs[l - 1].name ?>" href="#!digiseller/articles/<?= d.breadCrumbs[l - 1].id ?>"><?= d.breadCrumbs[l - 1].name ?></a><? } ?></div><div class="digiseller-product-details"><div class="digiseller-product-left"><? if (mainImg) { ?><a href="<?= mainImg ?>" target="_blank" id="digiseller-img-preview"><img src="http://graph.digiseller.ru/img.ashx?idp=<?= d.preview_imgs[0].id ?>&<?= d.preview_imgs[0].height > d.preview_imgs[0].width ? \'h\' : \'w\' ?>=<?= imgsize ?>" alt="<?= name ?>" /></a><? } else { ?><img src="http://graph.digiseller.ru/img.ashx?id_d=1&maxlength=<?= imgsize ?>" alt="<?= d.name ?>" /><? } ?><? if (d.preview_imgs || d.preview_videos) { ?><div class="digiseller-left-thumbs" id="digiseller-article-thumbs"><? if (d.preview_imgs && d.preview_imgs.length > 1) { ?><? for (var i = 0, l = d.preview_imgs.length; i < l; i++) { ?><a href="<?= d.preview_imgs[i].url ?>" data-id="<?= d.preview_imgs[i].id ?>" data-height="<?= d.preview_imgs[i].height ?>" data-width="<?= d.preview_imgs[i].width ?>"><img src="http://graph.digiseller.ru/img.ashx?idp=<?= d.preview_imgs[i].id ?>&maxlength=80&crop=1" alt="" /></a><? } ?><? } ?><? if (d.preview_videos) { ?><? for (var i = 0, l = d.preview_videos.length; i < l; i++) { ?><a class="digiseller-videothumb" href="<?= (d.preview_videos[i].type == "youtube" ? "http://www.youtube.com/watch?v=" + d.preview_videos[i].id : "http://vimeo.com/" + d.preview_videos[i].id) ?>" target="_blank"><img src="<?= d.preview_videos[i].preview ?>" alt="" /><span></span></a><? } ?><? } ?></div><? } ?></div><div class="digiseller-product-right"><div class="digiseller-productBuy"><span class="digiseller-prod-cost"><?= price ?></span><? if (d.is_available) { ?><a class="digiseller-buyButton" data-action="buy" data-id="<?= d.id ?>">������</a><? } else { ?><a class="digiseller-buyButton-empty">��� � �������</a><? } ?></div><div><a title="" class="digiseller-prod-name"><?= d.name ?>&nbsp;<? switch(d.label) {case \'top\': ?><span class="digiseller-labellider">����� ������!</span><? break;case \'sale\': ?><span class="digiseller-labelaction">�����!</span><? break;case \'new\': ?><span class="digiseller-labelnew">�������!</span><? break;} ?></a></div><div class="digiseller-prod-info"><? if (d.type) { ?><? switch (d.type) {case "file": ?><span class="digiseller-bold">����� ��������:&nbsp;</span> <?= d.file.date ?><?break;case "text": ?><span class="digiseller-bold">����� ��������:&nbsp;</span> <?= d.text.date ?><? break;} ?><div class="digiseller-prodinfoseparator"></div><? } ?><span class="digiseller-bold">���������� ������/���������:</span> <?= d.statistics.sales ?>/<?= d.statistics.refunds ?><div class="digiseller-prodinfoseparator"></div></div><? if (d.units && d.units.discounts) { ?><table class="digiseller-discounttable1"><thead><tr class="digiseller-discounttabbe-head"><td>��� �������</td><td>������</td><td>���� �� <?= d.units.desc ?></td></tr></thead><tbody><? for (var i = 0, l = d.units.discounts.length; i < l; i++) { ?><tr><td>�� <?= d.units.discounts[i].desc ?></td><td><?= d.units.discounts[i].percent ?>%</td><td><?= d.units.discounts[i].price ?> <?= d.currency ?></td></tr><? } ?></tbody></table><? } else if (d.units.price && d.units.desc) { ?><span class="digiseller-bold">����:</span> <?= d.units.price ?> <?= d.currency ?> �� <?= d.units.desc ?><br /><? } ?><? if (d.discounts && d.discounts.length) { ?><div class="digiseller-discounttable2"><span>C����� ���������� �����������.</span>���� ����� ����� ������� ������ ���:<ul><? for (var i = 0, l = d.discounts.length; i < l; i++) { ?><li><?= d.discounts[i].summa ?> <?= d.currency ?> &mdash; ������ <?= d.discounts[i].percent ?>%</li><? } ?></ul></div><? } ?></div></div><div class="digiseller-both"></div><div><div class="digiseller-productdetails-tabs"><a class="digiseller-activeTab" data-action="article-tab" data-tab="0">��������</a><? if (reviewsCount) { ?><a data-action="article-tab" data-tab="1">������ (<?= reviewsCount ?>)</a><? } ?></div><div><div class="digiseller-description_content"><div class="digiseller-prod-info"><?= d.info ?></div><? if (d.add_info !== "") { ?><div class="digiseller-prod-info"><h3>�������������� ����������:</h3><?= d.add_info ?></div><? } ?></div><div class="digiseller-reviews_content" id="digiseller-article-comments-<?= d.id ?>" style="display:none;"></div></div></div></div>',articles: '<div class="digiseller-options"><div class="digiseller-sortby" id="digiseller-sort"><span>����������� ��: </span><select><option value="name">�������� �� � �� �</option><option value="nameDESC">�������� �� � �� �</option><option value="price">���� �� ������ �� �������</option><option value="priceDESC">���� �� ������� �� ������</option></select></div><div id="digiseller-currency"><span>������: </span><select data-action="currency"><option value="RUR">RUR</option><option value="USD">USD</option><option value="EUR">EUR</option><option value="UAH">UAH</option></select></div></div><div class="digiseller-breadcrumbs"><a title="�������" href="#!digiseller/home">�������</a> &gt;&nbsp;<? if (typeof (breadCrumbs) !== "undefined") {for (var i = 0, l = breadCrumbs.length; i < l - 1; i++) { ?><a title="<?= breadCrumbs[i].name ?>" href="#!digiseller/articles/<?= breadCrumbs[i].id ?>"><?= breadCrumbs[i].name ?></a> &gt;&nbsp;<? } ?><strong><?= breadCrumbs[l - 1].name ?></strong><? } ?></div><div class="digiseller-productList" id="<?= id ?>"><?= out ?></div><div class="digiseller-articles-pager"></div>',categories: '<ul id="<?= id ?>"><?= out ?></ul>',category: '<li id="<?= id ?>"><a href="<?= url ?>" title="<?= d.name ?>"><?= d.name ?> <span>(<?= d.cnt ?>)</span></a><?= sub ?></li>',comment: '<div class="digiseller-review"><span class="digiseller-reviewdate">21.04.2013 23:46</span><p><?= (d.type == "good" ? \'<span class="digiseller-reviewgood">+</span>\' : \'<span class="digiseller-reviewbad">-</span>\') ?>&nbsp;<?= d.info ?></p><? if (d.comment !== \'\') { ?><div class="digiseller-reviewcomment"><span class="digiseller-reviewcommentarrow">^</span><span class="digiseller-reviewcommentadmintxt"><span class="digiseller-reviewdate">����������� ��������������</span><?= d.comment ?></span></div><? } ?></div><div class="digiseller-both"></div>',comments: '<div class="digiseller-options"><div class="digiseller-filtersort"><span>��������: </span><select><option value="all">��� ������</option><option value="good">������������� (<?= totalGood ?>)</option><option value="bad">������������� (<?= totalBad ?>)</option></select></div></div><div class="digiseller-comments"></div><div class="digiseller-paging"></div>',contacts: '<div class="digiseller-contacts"><h1>���������� ����������</h1><div class="digiseller-breadcrumbs"><a title="�������" href="#!digiseller/home">�������</a> &gt; <strong>���������� ����������</strong></div><div class="digiseller-contacts-block"><? if (d.email) { ?><span class="digiseller-contacts-label">e-Mail</span>: <span class="digiseller-contacts-value"><a href="mailto:<?= d.email ?>"><?= d.email ?></a></span><br /><? } ?><? if (d.icq) { ?><span class="digiseller-contacts-label">ICQ</span>: <span class="digiseller-contacts-value"><img src="http://status.icq.com/online.gif?icq=<?= d.icq ?>&img=5" title="������ ICQ ������������" /> <?= d.icq ?></span><br /><? } ?><? if (d.skype) { ?><span class="digiseller-contacts-label">Skype</span>: <span class="digiseller-contacts-value"><a href="skype:<?= d.skype ?>?chat"><?= d.skype ?></a></span><br /><? } ?><? if (d.wmid) { ?><span class="digiseller-contacts-label">wmid</span>: <span class="digiseller-contacts-value"><a href="//events.webmoney.ru/user.aspx?<?= d.wmid ?>"><?= d.wmid ?></a></span><br /><? } ?><? if (d.wmid) { ?><span class="digiseller-contacts-label">�������</span>: <span class="digiseller-contacts-value">+7 (499) 321 12 15</span><br /><? } ?><p><?= d.comment ?></p></div></div>',main: '<div class="digiseller-preloader" style="display:none;" id="digiseller-loader">��������...</div><div class="digiseller-fullwidth"><div class="digiseller-top"><? if (d.logo_visible) { ?><div class="digiseller-logo"><a href="#!digiseller/home"><img src="<?= d.logo_img ?>" alt="�������" /></a></div><? } ?><? if (d.form_search) { ?><div id="digiseller-search"><form class="digiseller-search-form"><input type="text" value="" class="digiseller-search-input" /><input type="submit" class="digiseller-search-go" value=" " /></form></div><? } ?><div class="digiseller-topmenu"><? if (d.menu_purchases) { ?><a href="#" title="��� �������" class="digiseller-myorderslnk">��� �������</a><? }if (d.menu_reviews) { ?><a href="#!digiseller/reviews" title="������ �����������" class="digiseller-reviewslnk">������ �����������</a><? }if (d.menu_contacts) { ?><a href="#!digiseller/contacts" title="��������" class="digiseller-contactslnk">��������</a><? } ?></div></div><div class="digiseller-category" id="digiseller-category"></div><div id="digiseller-main"></div></div>',nothing: '<span class="digiseller-nothing-found">������ �� �������<span>',page: '<a href="<?= url ?>" data-page="<?= page ?>"><?= page ?></a>&nbsp;',pageComment: '<a data-action="comments-page" data-page="<?= page ?>"><?= page ?></a>&nbsp;',pageReview: '<a href="<?= url ?>" data-page="<?= page ?>"><?= page ?></a>&nbsp;',pages: '<div class="digiseller-paging"><?= out ?><div class="digiseller-pager-rows"><span>�������� �� ��������:</span>&nbsp;<select><option value="10">10</option><option value="20">20</option><option value="50">50</option><option value="100">100</option></select></div></div>',review: '<div class="digiseller-review"><span class="digiseller-reviewdate">21.04.2013 23:46</span><p><?= (type == "good" ? \'<span class="digiseller-reviewgood">+</span>\' : \'<span class="digiseller-reviewbad">-</span>\') ?>&nbsp;<?= info ?></p><? if (comment !== \'\') { ?><div class="digiseller-reviewcomment"><span class="digiseller-reviewcommentarrow">^</span><span class="digiseller-reviewcommentadmintxt"><span class="digiseller-reviewdate">����������� ��������������</span><?= comment ?></span></div><? } ?></div><div class="digiseller-both"></div>',reviews: '<div class="digiseller-reviewList"><h1>������ �����������</h1><div class="digiseller-options"><div class="digiseller-filtersort" id="digiseller-reviews-type"><span>��������: </span><select><option value="all" selected="selected">��� ������</option><option value="good">������������� (<?= totalGood ?>)</option><option value="bad">������������� (<?= totalBad ?>)</option></select></div></div><div class="digiseller-breadcrumbs"><a title="�������" href="#!digiseller/home">�������</a> &gt; <strong>������</strong></div><div class="digiseller-comments" id="<?= id ?>"></div><div class="digiseller-paging"></div>',searchResult: '<div class="digiseller-product"><div class="digiseller-pricelabel"><span class="digiseller-article-cost"><?= d.price ?></span><span class="digiseller-currency"><?= d.currency ?></span></div><div class="digiseller-article-img" style="width:<?= 17 + imgsize ?>px;"><a href="<?= url ?>"><img src="http://graph.digiseller.ru/img.ashx?id_d=<?= d.id ?>&maxlength=<?= imgsize ?>" alt="<?= d.name ?>" /></a></div><div class="digiseller-browseProdTitle"><a href="<?= url ?>" title=""><?= d.snippet_name ?></a><p><?= d.snippet_info ?><br /><br /><a title="���������" href="<?= url ?>" class="digiseller-product-details">��������� �</a></p></div></div>',searchResults: '<!--h1>����� �� ������� "<span class="digiseller-search-header-query"></span>"</h1><div id="digiseller-search-results" class="digiseller-search-results"><dl><?= out ?></dl></div><div class="digiseller-search-pager"></div--><div class="digiseller-options"><div class="digiseller-sortby">�� �������&nbsp;"<span class="digiseller-bold" id="digiseller-search-query"></span>"&nbsp;������� �������:&nbsp;<span class="digiseller-bold" id="digiseller-search-total"></span></div><div id="digiseller-currency"><span>������: </span><select data-action="currency"><option value="RUR">RUR</option><option value="USD">USD</option><option value="EUR">EUR</option><option value="UAH">UAH</option></select></div></div><div class="digiseller-breadcrumbs"><a title="�������" href="#!digiseller/home">�������</a> &gt; <strong>�����</strong></div><div class="digiseller-productList"><div id="digiseller-search-results"><?= out ?></div><div class="digiseller-paging"></div></div>',showcaseArticle: '<div class="digiseller-snapshot"><? if (d.label) { ?><div><? switch(d.label) {case \'top\': ?><span class="digiseller-vitrinaicon digiseller-lider">����� ������!</span><? break;case \'sale\': ?><span class="digiseller-vitrinaicon digiseller-action">�����!</span><? break;case \'new\': ?><span class="digiseller-vitrinaicon digiseller-newproduct">�������!</span><? break;} ?><br /></div><? } ?><div><a href="<?= url ?>" title="digiseller-productName"><a href="<?= url ?>"><img src="http://graph.digiseller.ru/img.ashx?id_d=<?= d.id ?>&maxlength=<?= imgsize ?>" alt="<?= d.name ?>" /></a></a></div><div class="digiseller-snapprodnamehldr" style="max-width:<?= imgsize ?>px;"><a href="<?= url ?>" title="<?= d.name ?>"><span class="digiseller-snapname"><?= d.name ?></span></a></div><div><span class="digiseller-snapprice"><?= d.price ?></span><span class="digiseller-snapcurrency"><?= d.currency ?></span><? if (d.is_available) { ?><a class="digiseller-buyButton" data-action="buy" data-id="<?= d.id ?>">������</a><? } else { ?><a class="digiseller-buyButton-empty">��� � �������</a><? } ?></div></div>',showcaseArticles: '<div class="digiseller-productList digiseller-homepage"><?= out ?></div>'};