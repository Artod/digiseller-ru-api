DigiSeller.tmpls = {
agreement: '<h2><?= DS.opts.i18n[\'termsOfService\'] ?></h2><div style="height:200px; width:550px; overflow-y:scroll; text-align:left;"><?= DS.opts.agreement_text ?></div><br /><a id=\'digiseller-agree\'><?= DS.opts.i18n[\'accept\'] ?></a> <a id=\'digiseller-disagree\'><?= DS.opts.i18n[\'refuse\'] ?></a> ',articleDetail: '<? var mainImg = d.preview_imgs && d.preview_imgs[0] ? d.preview_imgs[0].url : \'\' ?><? var reviewsCount = parseInt(d.statistics.good_reviews) + parseInt(d.statistics.bad_reviews); ?><? var price = (d.collection == \'unit\' ? \'�� \' : \'\') + d.price + \' \' + d.currency ?><img src="//shop.digiseller.ru/xml/shop_views.asp?idd=<?= d.id ?>&ids=<?= DS.opts.seller_id ?>" width="0" height="0" /><div class="digiseller-productpge"><h1><?= d.name ?>&nbsp;<? switch(d.label) {case \'top\': ?><span class="digiseller-labellider"><?= DS.opts.i18n[\'leader!\'] ?></span><? break;case \'sale\': ?><span class="digiseller-labelaction"><?= DS.opts.i18n[\'action!\'] ?></span><? break;case \'new\': ?><span class="digiseller-labelnew"><?= DS.opts.i18n[\'new!\'] ?></span><? break;} ?></h1><div class="digiseller-breadcrumbs"><a title="<?= DS.opts.i18n[\'shop\'] ?>" onclick="location.hash=\'#!digiseller/home\';"><?= DS.opts.i18n[\'shop\'] ?></a> &gt;&nbsp;<? if (d.breadCrumbs) {for (var i = 0, l = d.breadCrumbs.length; i < l - 1; i++) { ?><a title="<?= d.breadCrumbs[i].name ?>" onclick="location.hash=\'#!digiseller/articles/<?= d.breadCrumbs[i].id ?>\';"><?= d.breadCrumbs[i].name ?></a> &gt;&nbsp;<? } ?><a title="<?= d.breadCrumbs[l - 1].name ?>" onclick="location.hash=\'#!digiseller/articles/<?= d.breadCrumbs[l - 1].id ?>\';"><?= d.breadCrumbs[l - 1].name ?></a><? } ?></div><div class="digiseller-options"><span class="digiseller-social"><a class="digiseller-social-fb" title="<?= DS.opts.i18n[\'shareInFacebook\'] ?>" data-action="share" data-type="fb" data-title="<?= d.name ?> / <?= price ?>" data-img="<?= mainImg ?>"></a><a class="digiseller-social-vk" title="<?= DS.opts.i18n[\'shareInVK\'] ?>" data-action="share" data-type="vk" data-title="<?= d.name ?> / <?= price ?>" data-img="<?= mainImg ?>"></a><a class="digiseller-social-tw" title="<?= DS.opts.i18n[\'shareInTwitter\'] ?>" data-action="share" data-type="tw" data-title="<?= d.name ?> / <?= price ?>"></a><a class="digiseller-social-wm" title="<?= DS.opts.i18n[\'shareInWME\'] ?>" data-action="share" data-type="wme" data-title="<?= d.name ?> / <?= price ?>" data-img="<?= mainImg ?>"></a></span><? if (d.id_prev !== \'0\' || d.id_next !== \'0\') { ?><div class="digiseller-product-toggle"><div<?= (d.id_prev !== \'0\' ? \'\' : \' class="digiseller-disabled"\') ?>><span>&larr; </span><a<?= (d.id_prev !== \'0\' ? \' onclick="location.hash=\\\'#!digiseller/detail/\' + d.id_prev + \'\\\'"\' : \'\') ?>><?= DS.opts.i18n[\'prevArticle\'] ?></a> &nbsp;&nbsp;</div>|<div<?= (d.id_next !== \'0\' ? \'\' : \' class="digiseller-disabled"\') ?>>&nbsp;&nbsp; <a<?= (d.id_next !== \'0\' ? \' onclick="location.hash=\\\'#!digiseller/detail/\' + d.id_next + \'\\\'"\' : \'\') ?>><?= DS.opts.i18n[\'nextArticle\'] ?></a><span> &rarr;</span></div></div><? } ?><!--div id="digiseller-currency"></div--></div><div class="digiseller-product-details"><div class="digiseller-product-left"><div><div class="digiseller-productdetails-tabs"><a class="digiseller-activeTab" data-action="article-tab" data-tab="0"><?= DS.opts.i18n[\'description\'] ?></a><? if ((d.units && d.units.discounts) || (d.discounts && d.discounts.length)) { ?><a data-action="article-tab" data-tab="1"><?= DS.opts.i18n[\'discounts\'] ?></a><? } ?><? if (reviewsCount) { ?><a data-action="article-tab" data-tab="2"><?= DS.opts.i18n[\'reviews\'] ?></a><? } ?></div><div><div class="digiseller-description_content"><div class="digiseller-prod-info"><? if (mainImg) {var imgSize = parseInt(DS.opts.imgsize_infopage) + 20; ?><a href="<?= mainImg ?>" target="_blank" id="digiseller-article-img-preview" data-type="img" data-index="0" style="min-width:<?= imgSize ?>px; min-height:<?= imgSize ?>px; background: url(//graph.digiseller.ru/img.ashx?idp=<?= d.preview_imgs[0].id ?>&maxlength=<?= DS.opts.imgsize_infopage ?>) no-repeat scroll center center transparent;" title="<?= name ?>"><!--img src="//graph.digiseller.ru/img.ashx?idp=<?= d.preview_imgs[0].id ?>&maxlength=<?= DS.opts.imgsize_infopage ?>" alt="<?= name ?>" /--><!--img src="//graph.digiseller.ru/img.ashx?idp=<?= d.preview_imgs[0].id ?>&<?= d.preview_imgs[0].height > d.preview_imgs[0].width ? \'h\' : \'w\' ?>=<?= DS.opts.imgsize_infopage ?>" alt="<?= name ?>" /--></a><? } else { ?><img class="digiseller-no-img" src="//graph.digiseller.ru/img.ashx?id_d=1&maxlength=<?= DS.opts.imgsize_infopage ?>" alt="<?= d.name ?>" /><? } ?><? if (d.preview_imgs || d.preview_videos) { ?><div class="digiseller-left-thumbs" id="digiseller-article-thumbs"><? if (d.preview_imgs) { ?><div class="digiseller-image-view"><? var index = 0;DS.util.each(d.preview_imgs, function(preview_img, i) { ?><a href="<?= preview_img.url ?>" data-type="img" data-index="<?= index ?>" data-id="<?= preview_img.id ?>"<?=  d.preview_imgs.length == 1 ? \' style="display:none;"\' : \'\' ?>><img src="//graph.digiseller.ru/img.ashx?idp=<?= preview_img.id ?>&maxlength=44&crop=1" alt="" /></a><? index++;}); ?></div><? } ?><? if (d.preview_videos) { ?><div class="digiseller-video-view"><? DS.util.each(d.preview_videos, function(preview_video, i) { ?><a class="digiseller-videothumb" data-id="<?= preview_video.id ?>" data-type="<?= preview_video.type ?>" data-index="<?= index ?>"><img src="<?= preview_video.preview ?>" alt="" /><span></span></a><? index++;}); ?></div><? } ?></div><? } ?></div><div class="digiseller-prod-info"><?= d.info ?></div><? if (d.add_info !== "") { ?><div class="digiseller-prod-info"><h3><?= DS.opts.i18n[\'addInformation\'] ?>:</h3><?= d.add_info ?></div><? } ?></div><div class="digiseller-reviews_content digiseller-discounttable2 digiseller-hidden"><? if ((d.units && d.units.discounts) || (d.discounts && d.discounts.length)) { ?><? if (d.units && d.units.discounts) { ?><h3><?= DS.opts.i18n[\'discountsOnQuantityPurchases\'] ?></h3><table class="digiseller-discounttable1"><thead><tr class="digiseller-discounttabbe-head"><td><?= DS.opts.i18n[\'whenBuyingFrom\'] ?></td><td><?= DS.opts.i18n[\'discount\'] ?></td><td><?= DS.opts.i18n[\'priceFor\'] ?> <?= d.units.desc ?></td></tr></thead><tbody><? DS.util.each(d.units.discounts, function(discount, i) { ?><tr><td><?= discount.desc ?></td><td><?= discount.percent ?>%</td><td><?= discount.price ?> <?= d.currency ?></td></tr><? }); ?></tbody></table><br /><? } ?> <? if (d.discounts && d.discounts.length) { ?><h3><?= DS.opts.i18n[\'discountLoyalCustomers\'] ?></h3><table class="digiseller-discounttable1"><thead><tr class="digiseller-discounttabbe-head"><td><?= DS.opts.i18n[\'amountOfPurchasesFrom\'] ?></td><td><?= DS.opts.i18n[\'discount\'] ?></td></tr></thead><tbody><? DS.util.each(d.discounts, function(discount, i) { ?><tr><td><?= discount.summa ?> <?= d.currency ?></td><td><?= discount.percent ?>%</td></tr><? }); ?></tbody></table><br /><? } ?> <? } ?></div><div class="digiseller-reviews_content digiseller-hidden" id="digiseller-article-comments-<?= d.id ?>"></div></div></div></div><div class="digiseller-product-right"><?= buy ?><? if (d.statistics.sales && d.statistics.sales != \'0\') { ?><div class="digiseller-prod-info"><span><?= DS.opts.i18n[\'numberOfSales\'] ?>:&nbsp;</span><?= d.statistics.sales ?></div><? } ?></div></div><div class="digiseller-both"></div></div><br />',articleList: '<div class="digiseller-product"><div class="digiseller-pricelabel"><span class="digiseller-article-cost"><? if (d.collection == \'unit\') { ?> <span>��</span> <? } ?> <?= d.price ?></span><span class="digiseller-currency"><?= d.currency ?></span><? if (d.is_available) { ?><a class="digiseller-buyButton" data-action="buy" data-id="<?= d.id ?>" data-ai="<?= d.agency_id ?>"><?= DS.opts.i18n[\'buy\'] ?></a><? } else { ?><a class="digiseller-buyButton-empty"><?= DS.opts.i18n[\'notAvailable\'] ?></a><? } ?></div><div class="digiseller-article-img" style="width:<?= 17 + imgsize ?>px;"><a onclick="location.hash=\'<?= url ?>\';"><img src="//graph.digiseller.ru/img.ashx?id_d=<?= d.cntImg != 0 ? d.id : 1 ?>&maxlength=<?= imgsize ?>" alt="" /></a></div><div class="digiseller-browseProdTitle"><a onclick="location.hash=\'<?= url ?>\'"><?= d.name ?>&nbsp;<? switch(d.label) {case \'top\': ?><span class="digiseller-labellider"><?= DS.opts.i18n[\'leader!\'] ?></span><? break;case \'sale\': ?><span class="digiseller-labelaction"><?= DS.opts.i18n[\'action!\'] ?></span><? break;case \'new\': ?><span class="digiseller-labelnew"><?= DS.opts.i18n[\'new!\'] ?></span><? break;} ?></a><p><span class="digiseller-descr-underbutton"></span><?= d.info ?><br /><br /><a onclick="location.hash=\'<?= url ?>\';" class="digiseller-product-details" title="<?= d.name ?>"><?= DS.opts.i18n[\'readMore\'] ?> �</a></p></div></div>',articles: '<img src="//shop.digiseller.ru/xml/shop_views.asp?idd=0&ids=<?= DS.opts.seller_id ?>" width="0" height="0" /><h1><?= d.breadCrumbs ? d.breadCrumbs[d.breadCrumbs.length - 1].name : \'\' ?></h1><div class="digiseller-breadcrumbs"><a title="<?= DS.opts.i18n[\'shop\'] ?>" onclick="location.hash=\'#!digiseller/home\';"><?= DS.opts.i18n[\'shop\'] ?></a> &gt;&nbsp;<? if (d.breadCrumbs) {for (var i = 0, l = d.breadCrumbs.length; i < l - 1; i++) { ?><a title="<?= d.breadCrumbs[i].name ?>" onclick="location.hash=\'#!digiseller/articles/<?= d.breadCrumbs[i].id ?>\';"><?= d.breadCrumbs[i].name ?></a> &gt;&nbsp;<? } ?><strong><?= d.breadCrumbs[l - 1].name ?> (<?= d.totalItems ?>)</strong><? } ?></div><? if (hasCategories) { ?><div class="digiseller-category-blocks"><? DS.util.each(d.categories, function(category, i) { ?><div><a onclick="location.hash=\'#!digiseller/articles/<?= category.id ?>\';"><img src="//graph.digiseller.ru/img.ashx?idn=<?= category.hasImg == 1 ? category.id : 1?>&maxlength=<?= DS.opts.imgsize_category ?>" alt="<?= name ?>" /></a><a onclick="location.hash=\'#!digiseller/articles/<?= category.id ?>\';" style="max-width:<?= DS.opts.imgsize_category ?>px;"><?= category.name ?><span>&nbsp;(<?= category.cnt ?>)</span></a></div><? }); ?></div><div class="digiseller-both"></div><? } ?><?= (d.totalPages ? articlesPanel : \'\') ?><? if (d.totalPages || !d.totalPages && !hasCategories) { ?><div class="digiseller-productList" id="<?= id ?>"><?= DS.opts.view === \'table\' ? \'<table class="digiseller-table" id="\' + id + \'-table">\' + out + \'</table>\' : out ?></div><div class="digiseller-paging"></div><? } ?><br />',articlesPanel: '<div class="digiseller-options"><div class="digiseller-sortby" id="digiseller-sort"><span><?= DS.opts.i18n[\'sortBy\'] ?>: </span><select><option value="" disabled="disabled"></option><option value="name"><?= DS.opts.i18n[\'nameFromAToZ\'] ?></option><option value="nameDESC"><?= DS.opts.i18n[\'nameFromZToA\'] ?></option><option value="price"><?= DS.opts.i18n[\'priceFromLowToHigh\'] ?></option><option value="priceDESC"><?= DS.opts.i18n[\'priceFromHighToLow\'] ?></option></select></div><div id="digiseller-view"><span><?= DS.opts.i18n[\'view\'] ?>: </span><select><option value="tile"><?= DS.opts.i18n[\'tile\'] ?></option><option value="list"><?= DS.opts.i18n[\'list\'] ?></option><option value="table"><?= DS.opts.i18n[\'table\'] ?></option></select></div><div id="digiseller-currency"></div></div>',articleTable: '<tr><td class="digiseller-table-left"><a onclick="location.hash=\'<?= url ?>\'"><?= d.name ?>                      </td><td class="digiseller-table-right"><div><span><? if (d.collection == \'unit\') { ?> <span>��</span> <? } ?> <?= d.price ?> <span><?= d.currency ?></span></span><? if (d.is_available) { ?><a class="digiseller-buyButton" data-action="buy" data-id="<?= d.id ?>" data-ai="<?= d.agency_id ?>"><?= DS.opts.i18n[\'buy\'] ?></a><? } else { ?><a class="digiseller-buyButton-empty"><?= DS.opts.i18n[\'notAvailable\'] ?></a><? } ?></div></td></tr>',articleTile: '<div class="digiseller-snapshot"><div><? if (d.label) {switch(d.label) {case \'top\': ?><span class="digiseller-vitrinaicon digiseller-lider"><?= DS.opts.i18n[\'leader!\'] ?></span><? break;case \'sale\': ?><span class="digiseller-vitrinaicon digiseller-action"><?= DS.opts.i18n[\'action!\'] ?></span><? break;case \'new\': ?><span class="digiseller-vitrinaicon digiseller-newproduct"><?= DS.opts.i18n[\'new!\'] ?></span><? break;}} else { ?><span class="digiseller-vitrinaicon"></span><? } ?><br /></div><div style="height:<?= 10 + imgsize ?>px;"><a onclick="location.hash=\'<?= url ?>\';"><img src="//graph.digiseller.ru/img.ashx?id_d=<?= d.cntImg != 0 ? d.id : 1 ?>&maxlength=<?= imgsize ?>" alt="" />&nbsp;</a></div><div class="digiseller-snapprodnamehldr" style="max-width:<?= imgsize ?>px;"><a onclick="location.hash=\'<?= url ?>\';" title="<?= d.name ?>"><span class="digiseller-snapname"><?= d.name ?></span></a></div><div><span class="digiseller-snapprice"><?= d.price ?></span><span class="digiseller-snapcurrency"><?= d.currency ?></span><? if (d.is_available) { ?><a class="digiseller-buyButton" data-action="buy" data-id="<?= d.id ?>" data-ai="<?= d.agency_id ?>"><?= DS.opts.i18n[\'buy\'] ?></a><? } else { ?><a class="digiseller-buyButton-empty"><?= DS.opts.i18n[\'notAvailable\'] ?></a><? } ?></div></div>',buy: '<?var button = (d.is_available? \'<a class="digiseller-buyButton" data-action="buy" data-id="\' + d.id + \'" data-form="1"\'+ (d.prices_unit && d.prices_unit.unit_CntMin ? \' data-min="\' + d.prices_unit.unit_CntMin + \'"\' : \'\')+ (d.prices_unit && d.prices_unit.unit_CntMax ? \' data-max="\' + d.prices_unit.unit_CntMax + \'"\' : \'\')+ \' id="digiseller-calc-buy">\' + DS.opts.i18n[\'buy\'] + \'</a>\'+ (DS.opts.hasCart && d.no_cart != 1 ? \' <a class="digiseller-buyButton" data-action="buy" data-id="\' + d.id + \'" data-form="1" data-cart="1" id="digiseller-calc-cart">\' + DS.opts.i18n[\'toCart\'] + \'</a>\' : \'\'): \'<a class="digiseller-buyButton-empty">\' + DS.opts.i18n[\'notAvailable\'] + \'</a>\');?><div class="digiseller-productBuy"><? if (d.is_available) { ?><div id="digiseller-calc" class="digiseller-calc"><form method="POST" action="https://www.oplata.info/asp2/pay.asp" id="digiseller-buy-form-<?= d.id ?>"><input type="hidden" name="Agent" value="<?= d.agency_id ?>" /><input type="hidden" name="product_id" value="<?= d.id ?>" /><input type="hidden" name="ID_D" value="<?= d.id ?>" /><input type="hidden" name="seller_id" value="<?= DS.opts.seller_id ?>" /><input type="hidden" name="FailPage" value="<?= failPage ?>" /><? if (!d.prices_unit) { ?><span class="digiseller-prod-cost" id="digiseller-calc-price"><?= d.price ?> <?= d.currency ?></span><? } else { ?><div class="digiseller-calc-quanity"><table><tr><td><span><?= DS.opts.i18n[\'iWillPay\'] ?> <b id="digiseller-calc-amountR"><?= d.prices_unit.unit_Currency ?></b></span><br /></td><td colspan="3"><span><?= DS.opts.i18n[\'iWillGet\'] ?> <b><?= d.prices_unit.unit_Name ?></b></span></td></tr><tr><td><div class="digiseller-calc-left"><input name="Unit_Summa" type="text" id="digiseller-calc-amount" value="<?= d.prices_unit.unit_Amount ?>"<?= (d.prices_unit.unit_Fixed ? \' disabled="disabled"\' : \'\') ?> />   </div></td><td><div class="digiseller-calc-center"><span class="digiseller-calc-<?= d.prices_unit.unit_Fixed ? \'arrowLeft\' : \'arrowLeftRight\' ?>"></span></div></td><td ><div class="digiseller-calc-right"><div><? if (d.prices_unit.unit_Fixed) { ?><select id="digiseller-calc-cntSelect" style="width:100%" name="Unit_Cnt"><? DS.util.each(d.prices_unit.unit_Fixed, function(unit_Fixed) { ?><option value="<?= unit_Fixed ?>"><?= unit_Fixed ?></option><? }); ?></select><? } else { ?><input name="Unit_Cnt" type="text" id="digiseller-calc-cnt" value="<?= d.prices_unit.unit_Cnt ?>" data-min="<?= d.prices_unit.unit_CntMin ?>" data-max="<?= d.prices_unit.unit_CntMax ?>" /><? } ?></div><div><span class="digiseller-calc-right-value"><?= d.prices_unit.unit_CntDesc ?></span></div></div></td></tr></table></div><div class="digiseller-calc-limit digiseller-hidden" id="digiseller-calc-limit"></div><? } ?><div class="digiseller-calc-method-two" id="digiseller-calc-method"><span><?= DS.opts.i18n[\'paymentVia\'] ?>:</span><br /><? if (d.payment_methods) {?><div><div><select id="digiseller-calc-currency" name="TypeCurr"><? for (type in d.payment_methods) {if (!DS.util.hasOwnProp(d.payment_methods, type) || !d.payment_methods[type]) continue; ?><option class="digiseller-calc-option digiseller-calc-<?= (\'\' + (d.payment_methods[type][0] && d.payment_methods[type][0][0])).toLowerCase() ?>" value=""><?= type ?></option><? } ?></select></div><div id="digiseller-calc-curadd"><? var i = 0;for (type in d.payment_methods) {if (!DS.util.hasOwnProp(d.payment_methods, type) || !d.payment_methods[type]) continue; ?><select class="digiseller-hidden" data-vars="<?= d.payment_methods[type].length ?>" data-index="<?= i ?>"><? DS.util.each(d.payment_methods[type], function(options) { ?><option value="<?= options[0] ?>"<?= options[1] === DS.opts.currency ? \' selected="selected"\' : \'\' ?>><?= options[1] ?></option><? }); ?></select><? i++;} ?></div></div><? } ?></div><? if (d.options && d.options.length) { ?><div id="digiseller-calc-options"><? DS.util.each(d.options, function(option, i) { ?><div class="digiseller-calc-line"<?= option.required == 1 ? \' data-required="1"\' : \'\' ?>><div><?= option.label ?> <?= option.required == 1 ? \'<span title="\' + DS.opts.i18n[\'required\'] + \'">*</span>\' : \'\' ?> <?= option.comment ? \'<span class="digiseller-form-help">?</span><i class="digiseller-form-tip">\' + option.comment + \'</i>\' : \'\' ?></div><? switch(option.type) {case \'text\': ?><input type="text" name="<?= option.name ?>" /><? break;case \'textarea\': ?><textarea name="<?= option.name ?>"></textarea><? break;case \'select\': ?><select name="<?= option.name ?>"><? if (option.variants && option.variants.length)if (option.required != 1) { ?><option></option><? }DS.util.each(option.variants, function(variant, ii) { ?><option value="<?= variant.value ?>"<?= variant[\'default\'] == 1 ? \' selected\' : \'\' ?>><?= variant.text ?><?= variant.modify ? \' (\' + variant.modify + \')\' : \'\' ?></option><? }); ?></select><? break;case \'checkbox\': case \'radio\':if (option.variants && option.variants.length) {DS.util.each(option.variants, function(variant, ii) { ?><input type="<?= option.type ?>" id="<?= option.name ?>_<?= ii ?>" name="<?= option.name + (option.type === \'checkbox\' ? \'-\' + variant.value : \'\') ?>" value="<?= variant.value ?>"<?= variant[\'default\'] == 1 ? \' checked\' : \'\' ?> /><label for="<?= option.name ?>_<?= ii ?>"><?= variant.text ?><?= variant.modify ? \' (\' + variant.modify + \')\' : \'\' ?></label><br /><? });}break;} ?></div> <? }); ?></div><? } ?><? if (DS.opts.agreement_text) { ?><div class="digiseller-calc-confirmation"><input type="checkbox" id="digiseller-calc-rules"<?= agree == 1 ? \' checked="checked"\' : \'\' ?> /><?= DS.opts.i18n[\'iAgreeWithTerms\'] ?></div><? } ?> <div class="digiseller-calc-buy"><?= button ?></div><div class="digiseller-calc-line-err digiseller-hidden" id="digiseller-buy-error-<?= d.id ?>"></div></form></div><? } else { ?><div class="digiseller-calc digiseller-notinstock"><span class="digiseller-prod-cost" id="digiseller-calc-price"><?= d.prices_unit ? DS.opts.i18n[\'from\'] : \'\' ?> <?= d.price ?> <?= d.currency ?></span><?= button ?></div><? } ?></div>',cart: '<h2><?= DS.opts.i18n[\'cart\'] ?></h2><table class="digiseller-cart-popup"><tbody><tr class="digiseller-cart-header"><td><?= DS.opts.i18n[\'nameOfArticle\'] ?></td><td class="digiseller-cart-price"><?= DS.opts.i18n[\'cost\'] ?>&nbsp;</td><td><?= DS.opts.i18n[\'count\'] ?></td><td>&nbsp;</td></tr></tbody></table><div class="digiseller-cart-content"><? if (items) { ?><table class="digiseller-cart-popup" id="digiseller-cart-items"><tbody><?= items ?></tbody></table><? } else { ?><?= DS.opts.i18n[\'cartIsEmpty\'] ?><? } ?></div><br /><div class="digiseller-cart-footer"><form action="https://www.oplata.info/asp2/pay.asp" method="POST"><input type="hidden" name="TypeCurr" value="<?= d.currency ?>" /><input type="hidden" name="FailPage" value="<?= failPage ?>" /><input type="hidden" name="Cart_UID" value="<?= DS.opts.cart_uid ?>" /><input type="hidden" name="Lang" value="<?= DS.opts.currentLang ?>" /><a id="digiseller-cart-go"<?= !items ? \' data-disabled="1" class="digiseller-cart-btn-disabled"\' : \'\' ?>><?= DS.opts.i18n[\'goToPay\'] ?></a></form><span id="digiseller-cart-amount-cont"<?= !items ? \' class="digiseller-hidden"\' : \'\' ?>><?= DS.opts.i18n[\'inTotal\'] ?>:&nbsp;&nbsp;<span id="digiseller-cart-amount"><?= d.amount ?></span><select id="digiseller-cart-currency"><? DS.util.each(d.cart_curr, function(curr) { ?><option value="<?= curr ?>"><?= curr ?></option><? }); ?></select></span></div>',cartButton: '<div<?= parseInt(DS.opts.cart_cnt) ? \'\' : \' class="digiseller-cart-btn-empty"\' ?> id="digiseller-cart-empty"><a href="#" title="<?= DS.opts.i18n.showCart ?>"><span id="digiseller-cart-count"><?= DS.opts.cart_cnt || 0 ?></span></a></div>',cartItem: '<tr id="digiseller-cart-item-<?= d.item_id ?>"<?= d.error ? \' class="digiseller-cart-error" \' : \'\' ?>><td><? if (d.options) { ?><a class="digiseller-cart-params-toggle">12</a><? } ?><div><a href="#!digiseller/detail/<?= d.id ?>"><?= d.name ?></a></div><? if (d.options) { ?><div class="digiseller-cart-row-param"><? DS.util.each(d.options, function(option) {  ?><strong><?= option.name ?>: </strong><? DS.util.each(option.variant, function(variant, i) {  ?><?= variant.data ?><?= variant.modify ? \' (\' + variant.modify + \')\' : \'\' ?><?= option.variant.length - 1 === i ? \'\' : \', \' ?><? }) ?><br /><? }) ?></div><? } ?></td><td class="digiseller-cart-price"><span id="digiseller-cart-item-cost-<?= d.item_id ?>"><?= d.price ?></span> <?= d.currency ?></td><td><input type="number" min="1" step="1" value="<?= d.cnt_item ?>" id="digiseller-cart-item-count-<?= d.item_id ?>" data-id="<?= d.item_id ?>"<?= d.cnt_lock == 1 ? \' disabled="disabled"\' : \'\' ?> /></td><td><a target="_blank" class="digiseller-cart-del-product" href="#" data-id="<?= d.item_id ?>">x</a></td></tr><tr class="digiseller-cart-error<?= d.error ? \'\' : \' digiseller-hidden\' ?>" id="digiseller-cart-item-error-<?= d.item_id ?>"> <!-- � ������ ��� ��� tr --><td colspan="4"><?= d.error || \'\' ?></td></tr>',categories: '<ul id="<?= id ?>"><?= out ?></ul>',category: '<li id="<?= id ?>"<?= sub ? \' class="digiseller-hmenu-withsub"\' : \'\' ?>><i></i><a onclick="location.hash=\'<?= url ?>\';" title="<?= d.name ?>"><?= d.name ?><span>&nbsp;&nbsp;(<?= d.cnt ?>)</span></a><?= sub ?></li>',comment: '<div class="digiseller-review"><span class="digiseller-reviewdate"><?= d.date ?></span><p><?= (d.type == "good" ? \'<span class="digiseller-reviewgood">+</span>\' : \'<span class="digiseller-reviewbad">-</span>\') ?>&nbsp;<?= d.info ?></p><? if (d.comment !== \'\') { ?><div class="digiseller-reviewcomment"><span class="digiseller-reviewcommentarrow">&#9650;</span><span class="digiseller-reviewcommentadmintxt"><span class="digiseller-reviewdate"><?= DS.opts.i18n[\'adminComment\'] ?></span><?= d.comment ?></span></div><? } ?></div><div class="digiseller-both"></div>',comments: '<div class="digiseller-options"><div class="digiseller-filtersort"><span><?= DS.opts.i18n[\'show\'] ?>: </span><select><option value="all"><?= DS.opts.i18n[\'allReviews\'] ?></option><option value="good"><?= DS.opts.i18n[\'positive\'] ?> (<?= totalGood ?>)</option><option value="bad"><?= DS.opts.i18n[\'negative\'] ?> (<?= totalBad ?>)</option></select></div></div><div class="digiseller-comments"></div><div class="digiseller-paging"></div>',contacts: '<div class="digiseller-contacts"><h1><?= DS.opts.i18n[\'contactInfo\'] ?></h1><div class="digiseller-breadcrumbs"><a title="<?= DS.opts.i18n[\'shop\'] ?>" onclick="location.hash=\'#!digiseller/home\';"><?= DS.opts.i18n[\'shop\'] ?></a> &gt; <strong><?= DS.opts.i18n[\'contactInfo\'] ?></strong></div><div class="digiseller-contacts-block"><? if (d.email) { ?><span class="digiseller-contacts-label">e-Mail</span>: <span class="digiseller-contacts-value"><a href="mailto:<?= d.email ?>"><?= d.email ?></a></span><br /><? } ?><? if (d.icq) { ?><span class="digiseller-contacts-label">ICQ</span>: <span class="digiseller-contacts-value"><img src="http://status.icq.com/online.gif?icq=<?= d.icq ?>&img=5" title="<?= DS.opts.i18n[\'statusIcqUser\'] ?>" /> <?= d.icq ?></span><br /><? } ?><? if (d.skype) { ?><span class="digiseller-contacts-label">Skype</span>: <span class="digiseller-contacts-value"><a href="skype:<?= d.skype ?>?chat"><?= d.skype ?></a></span><br /><? } ?><? if (d.wmid) { ?><span class="digiseller-contacts-label">wmid</span>: <span class="digiseller-contacts-value"><a href="//events.webmoney.ru/user.aspx?<?= d.wmid ?>"><?= d.wmid ?></a></span><br /><? } ?><? if (d.wmid) { ?><span class="digiseller-contacts-label"><?= DS.opts.i18n[\'phone\'] ?></span>: <span class="digiseller-contacts-value"><?= d.phone ?></span><br /><? } ?><p><?= d.comment ?></p></div></div>',currency: '<span><?= DS.opts.i18n[\'currency\'] ?>: </span><select><option value="RUR">RUR</option><option value="USD">USD</option><option value="EUR">EUR</option><option value="UAH">UAH</option></select>',langs: '<div class="langs_bg <?= DS.opts.currentLang.toLowerCase() ?>-icon"></div><div class="digiseller-langs-dd"><span></span><div><? DS.util.each(DS.opts.langs, function(lang) { ?><a href="#" data-action="click-lang" data-lang="<?= lang[0] ?>"><?= lang[1] ?></a><? }); ?></div></div>',loader: '<?= DS.opts.i18n[\'loading\'] ?>',logo: '<div class="digiseller-logo"><a onclick="location.hash=\'#!digiseller/home\';"><img src="<?= logo_img ?>" alt="Logo" /></a></div>',minmax: '<?= (flag ? DS.opts.i18n[\'max\'] : DS.opts.i18n[\'min\']) + \' \' + val ?>',nothing: '<span class="digiseller-nothing-found"><?= DS.opts.i18n[\'nothingFound\'] ?><span>',page: '<a onclick="location.hash=\'<?= url ?>\';" data-page="<?= page ?>"><?= page ?></a>&nbsp;',pageComment: '<a data-action="comments-page" data-page="<?= page ?>"><?= page ?></a>&nbsp;',pageReview: '<a onclick="location.hash=\'<?= url ?>\';" data-page="<?= page ?>"><?= page ?></a>&nbsp;',pages: '<?= out ?><div class="digiseller-pager-rows"><span><?= DS.opts.i18n[\'displayedOnThePage\'] ?>:</span>&nbsp;<select><option value="10">10</option><option value="20">20</option><option value="50">50</option><option value="100">100</option></select></div>',popup: '<div id="<?= p ?>main"><div id="<?= p ?>fade"></div><div id="<?= p ?>loader">&nbsp</div><div id="<?= p ?>container"><a href="#" id="<?= p ?>close">X</a><div id="<?= p ?>img"></div><br /><div class="digiseller-calc-center"><a id="<?= p ?>left"></a>&nbsp;&nbsp;&nbsp;<a id="<?= p ?>right"></a></div></div></div>\'',reviews: '<div class="digiseller-reviewList"><h1><?= DS.opts.i18n[\'customerReviews\'] ?></h1><div class="digiseller-breadcrumbs"><a title="<?= DS.opts.i18n[\'shop\'] ?>" onclick="location.hash=\'#!digiseller/home\';"><?= DS.opts.i18n[\'shop\'] ?></a> &gt; <strong><?= DS.opts.i18n[\'reviews\'] ?></strong></div><div class="digiseller-options"><div class="digiseller-filtersort" id="digiseller-reviews-type"><span><?= DS.opts.i18n[\'show\'] ?>: </span><select><option value="all" selected="selected"><?= DS.opts.i18n[\'allReviews\'] ?></option><option value="good"><?= DS.opts.i18n[\'positive\'] ?> (<?= totalGood ?>)</option><option value="bad"><?= DS.opts.i18n[\'negative\'] ?> (<?= totalBad ?>)</option></select></div></div><div class="digiseller-comments" id="<?= id ?>"></div><div class="digiseller-paging"></div>',search: '<form class="digiseller-search-form"><input type="text" value="" class="digiseller-search-input" /><input type="submit" class="digiseller-search-go" value="" /></form>',searchResult: '<div class="digiseller-product"><div class="digiseller-pricelabel"><span class="digiseller-article-cost"><?= d.price ?></span><span class="digiseller-currency"><?= d.currency ?></span></div><div class="digiseller-article-img" style="width:<?= 17 + DS.opts.imgsize_listpage ?>px;"><a onclick="location.hash=\'<?= url ?>\';"><img src="//graph.digiseller.ru/img.ashx?id_d=<?= d.id ?>&maxlength=<?= DS.opts.imgsize_listpage ?>" alt="<?= d.name ?>" /></a></div><div class="digiseller-browseProdTitle"><a onclick="location.hash=\'<?= url ?>\';" title=""><?= d.snippet_name ?></a><p><?= d.snippet_info ?><br /><br /><a onclick="location.hash=\'<?= url ?>\';" title="<?= DS.opts.i18n[\'readMore\'] ?>" class="digiseller-product-details"><?= DS.opts.i18n[\'readMore\'] ?> �</a></p></div></div>',searchResults: '<h1><?= DS.opts.i18n[\'search\'] ?></h1><div class="digiseller-breadcrumbs"><a onclick="location.hash=\'#!digiseller/home\';" title="<?= DS.opts.i18n[\'shop\'] ?>"><?= DS.opts.i18n[\'shop\'] ?></a> &gt; <strong><?= DS.opts.i18n[\'search\'] ?></strong></div><div class="digiseller-options"><div class="digiseller-sortby"><?= DS.opts.i18n[\'onRequest\'] ?>&nbsp;"<span class="digiseller-bold" id="digiseller-search-query"></span>"&nbsp;<?= DS.opts.i18n[\'foundArticles\'] ?>:&nbsp;<span class="digiseller-bold" id="digiseller-search-total"></span></div><div id="digiseller-currency"></div></div><div class="digiseller-productList"><div id="digiseller-search-results"><?= out ?></div><div class="digiseller-paging"></div></div>',showcaseArticles: '<img src="//shop.digiseller.ru/xml/shop_views.asp?idd=0&ids=<?= DS.opts.seller_id ?>" width="0" height="0" /><? if (categories && categories.length) { ?><div class="digiseller-category-blocks"><? DS.util.each(categories, function(category) { ?><div><a onclick="location.hash=\'<?= DS.opts.hashPrefix ?>/articles/<?= category.id ?>\';"><img src="//graph.digiseller.ru/img.ashx?idn=<?= category.hasImg == 1 ? category.id : 1?>&maxlength=<?= DS.opts.imgsize_category ?>" alt="<?= name ?>" /></a><a onclick="location.hash=\'<?= DS.opts.hashPrefix ?>/articles/<?= category.id ?>\';" style="max-width:<?= DS.opts.imgsize_category ?>px;"><?= category.name ?><span>&nbsp;(<?= category.cnt ?>)</span></a></div><? }); ?></div><div class="digiseller-both"></div><br /><? } ?><div class="digiseller-productList digiseller-homepage"><?= (out ? out : (categories && categories.length ? \'\' : DS.opts.i18n[\'articlesNotFound\'])) ?></div>',topmenu: '<div class="digiseller-topmenu"><? if (DS.opts.menu_purchases) { ?><a href="https://www.oplata.info" title="<?= DS.opts.i18n[\'myPurchases\'] ?>" class="digiseller-myorderslnk"><?= DS.opts.i18n[\'myPurchases\'] ?></a><? }if (DS.opts.menu_reviews) { ?><a onclick="location.hash=\'#!digiseller/reviews\';" title="<?= DS.opts.i18n[\'customerReviews\'] ?>" class="digiseller-reviewslnk"><?= DS.opts.i18n[\'customerReviews\'] ?></a><? }if (DS.opts.menu_contacts) { ?><a onclick="location.hash=\'#!digiseller/contacts\';" title="<?= DS.opts.i18n[\'contacts\'] ?>" class="digiseller-contactslnk"><?= DS.opts.i18n[\'contacts\'] ?></a><? } ?></div>',video: '<iframe src="<?= (type === \'youtube\' ? \'//www.youtube.com/embed/\' : \'//player.vimeo.com/video/\') ?><?= id ?>?autoplay=1&wmode=opaque&origin=http://172.16.101.18&api=1" width="500" height="305" frameborder="0" allowfullscreen=""/>'};