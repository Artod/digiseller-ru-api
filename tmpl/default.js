DigiSeller.tmpls = {
agreement: '<h2>������� �������������� �������</h2><div style="height:200px; width:550px; overflow-y:scroll; text-align:left;"><?= text ?></div><br /><a id=\'digiseller-agree\'>�������</a> <a id=\'digiseller-disagree\'>����������</a> ',article: '<div class="digiseller-product"><div class="digiseller-pricelabel"><span class="digiseller-article-cost"><? if (d.collection == \'unit\') { ?> �� <? } ?> <?= d.price ?></span><span class="digiseller-currency"><?= d.currency ?></span><? if (d.is_available) { ?><a class="digiseller-buyButton" data-action="buy" data-id="<?= d.id ?>">������</a><? } else { ?><a class="digiseller-buyButton-empty">��� � �������</a><? } ?></div><div class="digiseller-article-img" style="width:<?= 17 + imgsize ?>px;"><a onclick="location.hash=\'<?= url ?>\';"><img src="//graph.digiseller.ru/img.ashx?id_d=<?= d.cntImg != 0 ? d.id : 1 ?>&maxlength=<?= imgsize ?>" alt="" /></a></div><div class="digiseller-browseProdTitle"><a onclick="location.hash=\'<?= url ?>\'"><?= d.name ?>&nbsp;<? switch(d.label) {case \'top\': ?><span class="digiseller-labellider">����� ������!</span><? break;case \'sale\': ?><span class="digiseller-labelaction">�����!</span><? break;case \'new\': ?><span class="digiseller-labelnew">�������!</span><? break;} ?></a><p><?= d.info ?><br /><br /><a onclick="location.hash=\'<?= url ?>\';" class="digiseller-product-details" title="<?= d.name ?>">��������� �</a></p></div></div>',articleDetail: '<? var mainImg = d.preview_imgs && d.preview_imgs[0] ? d.preview_imgs[0].url : \'\' ?><? var reviewsCount = parseInt(d.statistics.good_reviews) + parseInt(d.statistics.bad_reviews); ?><? var price = (d.collection == \'unit\' ? \'�� \' : \'\') + d.price + \' \' + d.currency ?><div class="digiseller-productpge"><h1><?= d.name ?>&nbsp;<? switch(d.label) {case \'top\': ?><span class="digiseller-labellider">����� ������!</span><? break;case \'sale\': ?><span class="digiseller-labelaction">�����!</span><? break;case \'new\': ?><span class="digiseller-labelnew">�������!</span><? break;} ?></h1><div class="digiseller-breadcrumbs"><a title="�������" onclick="location.hash=\'#!digiseller/home\';">�������</a> &gt;&nbsp;<? if (d.breadCrumbs) {for (var i = 0, l = d.breadCrumbs.length; i < l - 1; i++) { ?><a title="<?= d.breadCrumbs[i].name ?>" onclick="location.hash=\'#!digiseller/articles/<?= d.breadCrumbs[i].id ?>\';"><?= d.breadCrumbs[i].name ?></a> &gt;&nbsp;<? } ?><a title="<?= d.breadCrumbs[l - 1].name ?>" onclick="location.hash=\'#!digiseller/articles/<?= d.breadCrumbs[l - 1].id ?>\';"><?= d.breadCrumbs[l - 1].name ?></a><? } ?></div><div class="digiseller-options"><span class="digiseller-social"><a class="digiseller-social-fb" title="���������� � facebook" data-action="share" data-type="fb" data-title="<?= d.name ?> / <?= price ?>" data-img="<?= mainImg ?>"></a><a class="digiseller-social-vk" title="���������� � ���������" data-action="share" data-type="vk" data-title="<?= d.name ?> / <?= price ?>" data-img="<?= mainImg ?>"></a><a class="digiseller-social-tw" title="���������� � twitter" data-action="share" data-type="tw" data-title="<?= d.name ?> / <?= price ?>"></a><a class="digiseller-social-wm" title="���������� � Webmoney.Events" data-action="share" data-type="wme" data-title="<?= d.name ?> / <?= price ?>" data-img="<?= mainImg ?>"></a></span><div id="digiseller-currency"></div></div><div class="digiseller-product-details"><div class="digiseller-product-left"><? if (mainImg) { ?><a href="<?= mainImg ?>" target="_blank" id="digiseller-article-img-preview" data-type="img"><img src="//graph.digiseller.ru/img.ashx?idp=<?= d.preview_imgs[0].id ?>&<?= d.preview_imgs[0].height > d.preview_imgs[0].width ? \'h\' : \'w\' ?>=<?= imgsize ?>" alt="<?= name ?>" /></a><? } else { ?><img src="//graph.digiseller.ru/img.ashx?id_d=1&maxlength=<?= imgsize ?>" alt="<?= d.name ?>" /><? } ?><? if (d.preview_imgs || d.preview_videos) { ?><div class="digiseller-left-thumbs" id="digiseller-article-thumbs"><? if (d.preview_imgs && d.preview_imgs.length > 1) { ?><? for (var i = 0, l = d.preview_imgs.length; i < l; i++) { ?><a href="<?= d.preview_imgs[i].url ?>" data-type="img"><img src="//graph.digiseller.ru/img.ashx?idp=<?= d.preview_imgs[i].id ?>&maxlength=80&crop=1" alt="" /></a><? } ?><? } ?><? if (d.preview_videos) { ?><? for (var i = 0, l = d.preview_videos.length; i < l; i++) { ?><a class="digiseller-videothumb" data-id="<?= d.preview_videos[i].id ?>" data-type="<?= d.preview_videos[i].type ?>"><img src="<?= d.preview_videos[i].preview ?>" alt="" /><span></span></a><? } ?><? } ?></div><? } ?></div><div class="digiseller-product-right"><?= buy ?><div class="digiseller-prod-info"><? if (d.type && d[d.type]) { ?><span class="digiseller-bold">�����&nbsp;��������:&nbsp;</span> <?= d[d.type].date ?><div class="digiseller-prodinfoseparator"></div><? } ?><span class="digiseller-bold">���������� ������/���������:</span> <?= d.statistics.sales ?>/<?= d.statistics.refunds ?><div class="digiseller-prodinfoseparator"></div></div><? if (d.units.price && d.units.desc) { ?><span class="digiseller-bold">����:</span> <?= d.units.price ?> <?= d.currency ?> �� <?= d.units.desc ?><br /><? } ?></div></div><div class="digiseller-both"></div><div><div class="digiseller-productdetails-tabs"><a class="digiseller-activeTab" data-action="article-tab" data-tab="0">��������</a><? if ((d.units && d.units.discounts) || (d.discounts && d.discounts.length)) { ?><a data-action="article-tab" data-tab="1">������</a><? } ?><? if (reviewsCount) { ?><a data-action="article-tab" data-tab="2">������ (<?= reviewsCount ?>)</a><? } ?></div><div><div class="digiseller-description_content"><div class="digiseller-prod-info"><?= d.info ?></div><? if (d.add_info !== "") { ?><div class="digiseller-prod-info"><h3>�������������� ����������:</h3><?= d.add_info ?></div><? } ?></div><div class="digiseller-reviews_content digiseller-discounttable2" style="display:none;"><? if ((d.units && d.units.discounts) || (d.discounts && d.discounts.length)) { ?><? if (d.units && d.units.discounts) { ?><h3>������ �� ���������� �������������� ������</h3><table class="digiseller-discounttable1"><thead><tr class="digiseller-discounttabbe-head"><td>��� ������� ��</td><td>������</td><td>���� �� <?= d.units.desc ?></td></tr></thead><tbody><? for (var i = 0, l = d.units.discounts.length; i < l; i++) { ?><tr><td><?= d.units.discounts[i].desc ?></td><td><?= d.units.discounts[i].percent ?>%</td><td><?= d.units.discounts[i].price ?> <?= d.currency ?></td></tr><? } ?></tbody></table><br /><? } ?> <? if (d.discounts && d.discounts.length) { ?><h3>C����� ���������� �����������</h3><table class="digiseller-discounttable1"><thead><tr class="digiseller-discounttabbe-head"><td>����� ������� ��</td><td>������</td></tr></thead><tbody><? for (var i = 0, l = d.discounts.length; i < l; i++) { ?><tr><td><?= d.discounts[i].summa ?> <?= d.currency ?></td><td><?= d.discounts[i].percent ?>%</td></tr><? } ?></tbody></table><br /><? } ?> <? } ?></div><div class="digiseller-reviews_content" id="digiseller-article-comments-<?= d.id ?>" style="display:none;"></div></div></div></div><br />',articleList: '<div class="digiseller-product"><div class="digiseller-pricelabel"><span class="digiseller-article-cost"><? if (d.collection == \'unit\') { ?> �� <? } ?> <?= d.price ?></span><span class="digiseller-currency"><?= d.currency ?></span><? if (d.is_available) { ?><a class="digiseller-buyButton" data-action="buy" data-id="<?= d.id ?>">������</a><? } else { ?><a class="digiseller-buyButton-empty">��� � �������</a><? } ?></div><div class="digiseller-article-img" style="width:<?= 17 + imgsize ?>px;"><a onclick="location.hash=\'<?= url ?>\';"><img src="//graph.digiseller.ru/img.ashx?id_d=<?= d.cntImg != 0 ? d.id : 1 ?>&maxlength=<?= imgsize ?>" alt="" /></a></div><div class="digiseller-browseProdTitle"><a onclick="location.hash=\'<?= url ?>\'"><?= d.name ?>&nbsp;<? switch(d.label) {case \'top\': ?><span class="digiseller-labellider">����� ������!</span><? break;case \'sale\': ?><span class="digiseller-labelaction">�����!</span><? break;case \'new\': ?><span class="digiseller-labelnew">�������!</span><? break;} ?></a><p><?= d.info ?><br /><br /><a onclick="location.hash=\'<?= url ?>\';" class="digiseller-product-details" title="<?= d.name ?>">��������� �</a></p></div></div>',articles: '<h1><?= d.breadCrumbs ? d.breadCrumbs[d.breadCrumbs.length - 1].name : \'\' ?></h1><div class="digiseller-breadcrumbs"><a title="�������" onclick="location.hash=\'#!digiseller/home\';">�������</a> &gt;&nbsp;<? if (d.breadCrumbs) {for (var i = 0, l = d.breadCrumbs.length; i < l - 1; i++) { ?><a title="<?= d.breadCrumbs[i].name ?>" onclick="location.hash=\'#!digiseller/articles/<?= d.breadCrumbs[i].id ?>\';"><?= d.breadCrumbs[i].name ?></a> &gt;&nbsp;<? } ?><strong><?= d.breadCrumbs[l - 1].name ?> (<?= d.totalItems ?>)</strong><? } ?></div><? if (hasCategories) { ?><div class="digiseller-category-blocks"><? for (var i = 0, l = d.categories.length; i < l; i++) { ?><div><a onclick="location.hash=\'#!digiseller/articles/<?= d.categories[i].id ?>\';"><img src="//graph.digiseller.ru/img.ashx?idn=<?= d.categories[i].hasImg == 1 ? d.categories[i].id : 1?>&maxlength=<?= opts.imgsize_category ?>" alt="<?= name ?>" /></a><a onclick="location.hash=\'#!digiseller/articles/<?= d.categories[i].id ?>\';" style="max-width:<?= opts.imgsize_category ?>px;"><?= d.categories[i].name ?><span>&nbsp;(<?= d.categories[i].cnt ?>)</span></a></div><? } ?></div><div class="digiseller-both"></div><? } ?><?= (d.totalPages ? articlesPanel : \'\') ?><? if (d.totalPages || !d.totalPages && !hasCategories) { ?><div class="digiseller-productList" id="<?= id ?>"><?= opts.view === \'table\' ? \'<table class="digiseller-table" id="\' + id + \'-table">\' + out + \'</table>\' : out ?></div><div class="digiseller-articles-pager"></div><? } ?><br />',articlesPanel: '<div class="digiseller-options"><div class="digiseller-sortby" id="digiseller-sort"><span>����������� ��: </span><select><option value="name">�������� �� � �� �</option><option value="nameDESC">�������� �� � �� �</option><option value="price">���� �� ������ �� �������</option><option value="priceDESC">���� �� ������� �� ������</option></select></div><div id="digiseller-view"><span>���: </span><select><option value="tile">������</option><option value="list">������</option><option value="table">�������</option></select></div><div id="digiseller-currency"></div></div>',articleTable: '<tr><td class="digiseller-table-left"><a onclick="location.hash=\'<?= url ?>\'"><?= d.name ?>                      </td><td class="digiseller-table-right"><div><span><? if (d.collection == \'unit\') { ?> �� <? } ?> <?= d.price ?> <?= d.currency ?></span><? if (d.is_available) { ?><a class="digiseller-buyButton" data-action="buy" data-id="<?= d.id ?>">������</a><? } else { ?><a class="digiseller-buyButton-empty">��� � �������</a><? } ?></div></td></tr>',articleTile: '<div class="digiseller-snapshot"><div><? if (d.label) {switch(d.label) {case \'top\': ?><span class="digiseller-vitrinaicon digiseller-lider">����� ������!</span><? break;case \'sale\': ?><span class="digiseller-vitrinaicon digiseller-action">�����!</span><? break;case \'new\': ?><span class="digiseller-vitrinaicon digiseller-newproduct">�������!</span><? break;}} else { ?><span class="digiseller-vitrinaicon"></span><? } ?><br /></div><div style="height:<?= 10 + imgsize ?>px;"><a onclick="location.hash=\'<?= url ?>\';"><img src="//graph.digiseller.ru/img.ashx?id_d=<?= d.cntImg != 0 ? d.id : 1 ?>&maxlength=<?= imgsize ?>" alt="" />&nbsp;</a></div><div class="digiseller-snapprodnamehldr" style="max-width:<?= imgsize ?>px;"><a onclick="location.hash=\'<?= url ?>\';" title="<?= d.name ?>"><span class="digiseller-snapname"><?= d.name ?></span></a></div><div><span class="digiseller-snapprice"><?= d.price ?></span><span class="digiseller-snapcurrency"><?= d.currency ?></span><? if (d.is_available) { ?><a class="digiseller-buyButton" data-action="buy" data-id="<?= d.id ?>">������</a><? } else { ?><a class="digiseller-buyButton-empty">��� � �������</a><? } ?></div></div>',buy: '<?var button = (d.is_available ? \'<a class="digiseller-buyButton" data-action="buy" data-id="\' + d.id + \'" data-form="1"\' + (d.prices_unit && d.prices_unit.unit_CntMin ? \' data-min="\' + d.prices_unit.unit_CntMin + \'"\' : \'\') + (d.prices_unit && d.prices_unit.unit_CntMax ? \' data-max="\' + d.prices_unit.unit_CntMax + \'"\' : \'\') + \' id="digiseller-calc-buy">������</a>\' : \'<a class="digiseller-buyButton-empty">��� � �������</a>\');?><div class="digiseller-productBuy"><? if (d.is_available) { ?><div id="digiseller-calc" class="digiseller-calc"><form method="POST" action="https://www.oplata.info/asp/pay.asp" id="digiseller-buy-form-<?= d.id ?>"><? if (!d.prices_unit) { ?><span class="digiseller-prod-cost" id="digiseller-calc-price"><?= d.price ?> <?= d.currency ?></span><? } else { ?><div class="digiseller-calc-quanity"><div class="digiseller-calc-left"><span>������� <b id="digiseller-calc-amountR"><?= d.prices_unit.unit_Currency ?></b></span><br /><input name="Unit_Summa" type="text" id="digiseller-calc-amount" value="<?= d.prices_unit.unit_Amount ?>"<?= (d.prices_unit.unit_Fixed ? \' disabled="disabled"\' : \'\') ?> />   </div> <div class="digiseller-calc-center"><span class="digiseller-calc-<?= d.prices_unit.unit_Fixed ? \'arrowLeft\' : \'arrowLeftRight\' ?>"></span></div><div class="digiseller-calc-right" ><span>������ <b><?= d.prices_unit.unit_Name ?></b></span><br /><? if (d.prices_unit.unit_Fixed) { ?><select id="digiseller-calc-cntSelect" style="width:100%" name="Unit_Cnt"><? for (var i = 0, l = d.prices_unit.unit_Fixed.length; i < l; i++) { ?><option value="<?= d.prices_unit.unit_Fixed[i] ?>"><?= d.prices_unit.unit_Fixed[i] ?></option><? } ?></select><? } else { ?><input name="Unit_Cnt" type="text" id="digiseller-calc-cnt" value="<?= d.prices_unit.unit_Cnt ?>" data-min="<?= d.prices_unit.unit_CntMin ?>" data-max="<?= d.prices_unit.unit_CntMax ?>" /><? } ?></div><div class="digiseller-calc-right-value"><?= d.prices_unit.unit_CntDesc ?></div></div><div class="digiseller-calc-limit" id="digiseller-calc-limit" style="display:none;"></div><? } ?><div class="digiseller-calc-method"><span>������ �����:</span><br /><select id="digiseller-calc-currency" name="TypeCurr"><? var currency = {wmz: \'USD\',wmr: \'RUR\',wme: \'EUR\',wmu: \'UAH\'};for (type in opts.types) {if ( !opts.types.hasOwnProperty(type) || !d.prices[type] || d.prices[type] == 0)continue; ?><option class="digiseller-calc-option digiseller-calc-<?= type ?>" value="<?= type ?>" data-price="<?= d.prices[type] ?>"<?= currency[type] === opts.currency ? \' selected="selected"\' : \'\' ?>><?= opts.types[type] ?></option><? } ?></select></div><? if (opts.agreement_text) { ?><div class="digiseller-calc-confirmation"><input type="checkbox" id="digiseller-calc-rules"<?= agree == 1 ? \' checked="checked"\' : \'\' ?> />� �<a data-action="agreement" href="#">��������� �������������� �������</a>� ���������� � ��������.</div><? } ?> <div class="digiseller-calc-buy"><input type="hidden" name="ID_D" value="<?= d.id ?>" /><input type="hidden" name="failPage" value="<?= failPage ?>" /><?= button ?></div></form></div><? } else { ?><?= button ?><? } ?></div>',categories: '<ul id="<?= id ?>"><?= out ?></ul>',category: '<li id="<?= id ?>"><a onclick="location.hash=\'<?= url ?>\';" title="<?= d.name ?>"><?= d.name ?>&nbsp;<span>(<?= d.cnt ?>)</span></a><?= sub ?></li>',comment: '<div class="digiseller-review"><span class="digiseller-reviewdate"><?= d.date ?></span><p><?= (d.type == "good" ? \'<span class="digiseller-reviewgood">+</span>\' : \'<span class="digiseller-reviewbad">-</span>\') ?>&nbsp;<?= d.info ?></p><? if (d.comment !== \'\') { ?><div class="digiseller-reviewcomment"><span class="digiseller-reviewcommentarrow">&#9650;</span><span class="digiseller-reviewcommentadmintxt"><span class="digiseller-reviewdate">����������� ��������������</span><?= d.comment ?></span></div><? } ?></div><div class="digiseller-both"></div>',comments: '<div class="digiseller-options"><div class="digiseller-filtersort"><span>��������: </span><select><option value="all">��� ������</option><option value="good">������������� (<?= totalGood ?>)</option><option value="bad">������������� (<?= totalBad ?>)</option></select></div></div><div class="digiseller-comments"></div><div class="digiseller-paging"></div>',contacts: '<div class="digiseller-contacts"><h1>���������� ����������</h1><div class="digiseller-breadcrumbs"><a title="�������" onclick="location.hash=\'#!digiseller/home\';">�������</a> &gt; <strong>���������� ����������</strong></div><div class="digiseller-contacts-block"><? if (d.email) { ?><span class="digiseller-contacts-label">e-Mail</span>: <span class="digiseller-contacts-value"><a href="mailto:<?= d.email ?>"><?= d.email ?></a></span><br /><? } ?><? if (d.icq) { ?><span class="digiseller-contacts-label">ICQ</span>: <span class="digiseller-contacts-value"><img src="http://status.icq.com/online.gif?icq=<?= d.icq ?>&img=5" title="������ ICQ ������������" /> <?= d.icq ?></span><br /><? } ?><? if (d.skype) { ?><span class="digiseller-contacts-label">Skype</span>: <span class="digiseller-contacts-value"><a href="skype:<?= d.skype ?>?chat"><?= d.skype ?></a></span><br /><? } ?><? if (d.wmid) { ?><span class="digiseller-contacts-label">wmid</span>: <span class="digiseller-contacts-value"><a href="//events.webmoney.ru/user.aspx?<?= d.wmid ?>"><?= d.wmid ?></a></span><br /><? } ?><? if (d.wmid) { ?><span class="digiseller-contacts-label">�������</span>: <span class="digiseller-contacts-value"><?= d.phone ?></span><br /><? } ?><p><?= d.comment ?></p></div></div>',currency: '<span>������: </span><select><option value="RUR">RUR</option><option value="USD">USD</option><option value="EUR">EUR</option><option value="UAH">UAH</option></select>',loader: '��������...',logo: '<div class="digiseller-logo"><a onclick="location.hash=\'#!digiseller/home\';"><img src="<?= logo_img ?>" alt="�������" /></a></div>',main: '<div class="digiseller-preloader" style="display:none;" id="digiseller-loader">��������...</div><div class="digiseller-fullwidth"><div class="digiseller-top"><? if (d.logo_visible) { ?><div class="digiseller-logo"><a href="#!digiseller/home"><img src="<?= d.logo_img ?>" alt="�������" /></a></div><? } ?><? if (d.form_search) { ?><div id="digiseller-search"><form class="digiseller-search-form"><input type="text" value="" class="digiseller-search-input" /><input type="submit" class="digiseller-search-go" value=" " /></form></div><? } ?><div class="digiseller-topmenu"><? if (d.menu_purchases) { ?><a href="#" title="��� �������" class="digiseller-myorderslnk">��� �������</a><? }if (d.menu_reviews) { ?><a href="#!digiseller/reviews" title="������ �����������" class="digiseller-reviewslnk">������ �����������</a><? }if (d.menu_contacts) { ?><a href="#!digiseller/contacts" title="��������" class="digiseller-contactslnk">��������</a><? } ?></div></div><div class="digiseller-category" id="digiseller-category"></div><div id="digiseller-main"></div></div>',minmax: '<?= (flag ? \'�������� \' : \'������� \') + val ?>',nothing: '<span class="digiseller-nothing-found">������ �� �������<span>',page: '<a onclick="location.hash=\'<?= url ?>\';" data-page="<?= page ?>"><?= page ?></a>&nbsp;',pageComment: '<a data-action="comments-page" data-page="<?= page ?>"><?= page ?></a>&nbsp;',pageReview: '<a onclick="location.hash=\'<?= url ?>\';" data-page="<?= page ?>"><?= page ?></a>&nbsp;',pages: '<div class="digiseller-paging"><?= out ?><div class="digiseller-pager-rows"><span>�������� �� ��������:</span>&nbsp;<select><option value="10">10</option><option value="20">20</option><option value="50">50</option><option value="100">100</option></select></div></div>',popup: '<div id="<?= p ?>main"><div id="<?= p ?>fade"></div><div id="<?= p ?>loader">&nbsp</div><div id="<?= p ?>container"><a href="#" id="<?= p ?>close">X</a><div id="<?= p ?>img"></div><br /><div class="digiseller-calc-center"><a id="<?= p ?>left"></a>&nbsp;&nbsp;&nbsp;<a id="<?= p ?>right"></a></div></div></div>\'',review: '<!-- ������ ����� ������������ comment.tmpl --><div class="digiseller-review"><span class="digiseller-reviewdate"><?= date ?></span><p><?= (type == "good" ? \'<span class="digiseller-reviewgood">+</span>\' : \'<span class="digiseller-reviewbad">-</span>\') ?>&nbsp;<?= info ?></p><? if (comment !== \'\') { ?><div class="digiseller-reviewcomment"><span class="digiseller-reviewcommentarrow">^</span><span class="digiseller-reviewcommentadmintxt"><span class="digiseller-reviewdate">����������� ��������������</span><?= comment ?></span></div><? } ?></div><div class="digiseller-both"></div>',reviews: '<div class="digiseller-reviewList"><h1>������ �����������</h1><div class="digiseller-breadcrumbs"><a title="�������" onclick="location.hash=\'#!digiseller/home\';">�������</a> &gt; <strong>������</strong></div><div class="digiseller-options"><div class="digiseller-filtersort" id="digiseller-reviews-type"><span>��������: </span><select><option value="all" selected="selected">��� ������</option><option value="good">������������� (<?= totalGood ?>)</option><option value="bad">������������� (<?= totalBad ?>)</option></select></div></div><div class="digiseller-comments" id="<?= id ?>"></div><div class="digiseller-paging"></div>',search: '<div id="digiseller-search"><form class="digiseller-search-form"><input type="text" value="" class="digiseller-search-input" /><input type="submit" class="digiseller-search-go" value="" /></form></div>',searchResult: '<div class="digiseller-product"><div class="digiseller-pricelabel"><span class="digiseller-article-cost"><?= d.price ?></span><span class="digiseller-currency"><?= d.currency ?></span></div><div class="digiseller-article-img" style="width:<?= 17 + imgsize ?>px;"><a onclick="location.hash=\'<?= url ?>\';"><img src="//graph.digiseller.ru/img.ashx?id_d=<?= d.id ?>&maxlength=<?= imgsize ?>" alt="<?= d.name ?>" /></a></div><div class="digiseller-browseProdTitle"><a onclick="location.hash=\'<?= url ?>\';" title=""><?= d.snippet_name ?></a><p><?= d.snippet_info ?><br /><br /><a onclick="location.hash=\'<?= url ?>\';" title="���������" class="digiseller-product-details">��������� �</a></p></div></div>',searchResults: '<h1>�����</h1><div class="digiseller-breadcrumbs"><a onclick="location.hash=\'#!digiseller/home\';" title="�������">�������</a> &gt; <strong>�����</strong></div><div class="digiseller-options"><div class="digiseller-sortby">�� �������&nbsp;"<span class="digiseller-bold" id="digiseller-search-query"></span>"&nbsp;������� �������:&nbsp;<span class="digiseller-bold" id="digiseller-search-total"></span></div><div id="digiseller-currency"></div></div><div class="digiseller-productList"><div id="digiseller-search-results"><?= out ?></div><div class="digiseller-paging"></div></div>',showcaseArticle: '<div class="digiseller-snapshot"><div><? if (d.label) {switch(d.label) {case \'top\': ?><span class="digiseller-vitrinaicon digiseller-lider">����� ������!</span><? break;case \'sale\': ?><span class="digiseller-vitrinaicon digiseller-action">�����!</span><? break;case \'new\': ?><span class="digiseller-vitrinaicon digiseller-newproduct">�������!</span><? break;}} else { ?><span class="digiseller-vitrinaicon"></span><? } ?><br /></div><div style="height:<?= 10 + imgsize_firstpage ?>px;"><a onclick="location.hash=\'<?= url ?>\';"><img src="//graph.digiseller.ru/img.ashx?id_d=<?= d.cntImg != 0 ? d.id : 1 ?>&maxlength=<?= imgsize_firstpage ?>" alt="" />&nbsp;</a></div><div class="digiseller-snapprodnamehldr" style="max-width:<?= imgsize_firstpage ?>px;"><a onclick="location.hash=\'<?= url ?>\';" title="<?= d.name ?>"><span class="digiseller-snapname"><?= d.name ?></span></a></div><div><span class="digiseller-snapprice"><?= d.price ?></span><span class="digiseller-snapcurrency"><?= d.currency ?></span><? if (d.is_available) { ?><a class="digiseller-buyButton" data-action="buy" data-id="<?= d.id ?>">������</a><? } else { ?><a class="digiseller-buyButton-empty">��� � �������</a><? } ?></div></div>',showcaseArticles: '<? if (categories && categories.length) { ?><div class="digiseller-category-blocks"><? for (var i = 0, l = categories.length; i < l; i++) { ?><div><a onclick="location.hash=\'<?= opts.hashPrefix ?>/articles/<?= categories[i].id ?>\';"><img src="//graph.digiseller.ru/img.ashx?idn=<?= categories[i].hasImg == 1 ? categories[i].id : 1?>&maxlength=<?= opts.imgsize_category ?>" alt="<?= name ?>" /></a><a onclick="location.hash=\'<?= opts.hashPrefix ?>/articles/<?= categories[i].id ?>\';" style="max-width:<?= opts.imgsize_category ?>px;"><?= categories[i].name ?><span>&nbsp;(<?= categories[i].cnt ?>)</span></a></div><? } ?></div><div class="digiseller-both"></div><br /><? } ?><div class="digiseller-productList digiseller-homepage"><?= out ?></div>',topmenu: '<div class="digiseller-topmenu"><? if (d.menu_purchases) { ?><a href="https://www.oplata.info" title="��� �������" class="digiseller-myorderslnk">��� �������</a><? }if (d.menu_reviews) { ?><a onclick="location.hash=\'#!digiseller/reviews\';" title="������ �����������" class="digiseller-reviewslnk">������ �����������</a><? }if (d.menu_contacts) { ?><a onclick="location.hash=\'#!digiseller/contacts\';" title="��������" class="digiseller-contactslnk">��������</a><? } ?></div>',video: '<iframe src="<?= (type === \'youtube\' ? \'//www.youtube.com/embed/\' : \'//player.vimeo.com/video/\') ?><?= id ?>?autoplay=1&wmode=opaque&origin=http://172.16.101.18&api=1" width="500" height="305" frameborder="0" allowfullscreen=""/>'};