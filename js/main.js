// Generated by CoffeeScript 1.6.1
/*
DigiSeller-ru-api
04.07.2013 (c) http://artod.ru
*/

(function(){(function(n,o){var p,inited;if(n.DigiSeller!=null){false}p={};p.$el={head:null,body:null,widget:null};p.opts={seller_id:null,host:'http://shop.digiseller.ru/xml/',hashPrefix:'#!digiseller',currency:'RUR',sort:'name',rows:10,logo_img:'',menu_purchases:true,menu_reviews:true,menu_contacts:true,imgsize_firstpage:160,imgsize_listpage:162,imgsize_infopage:163,imgsize_category:200};p.util={getUID:(function(){var a;a=1;return function(){return a++}})(),enc:function(t){return encodeURIComponent(t)},prevent:function(e){if(e.preventDefault){e.preventDefault()}else{e.returnValue=false}},extend:function(a,b,c){var d;for(d in b){if(!b.hasOwnProperty(d)){continue}if(c||typeof a[d]==='object'){a[d]=b[d]}}return a},getPopupParams:function(a,b){var c,outerHeight,outerWidth,screenX,screenY,top;screenX=typeof n.screenX!=='undefined'?n.screenX:n.screenLeft;screenY=typeof n.screenY!=='undefined'?n.screenY:n.screenTop;outerWidth=typeof n.outerWidth!=='undefined'?n.outerWidth:o.body.clientWidth;outerHeight=typeof n.outerHeight!=='undefined'?n.outerHeight:o.body.clientHeight-22;c=parseInt(screenX+((outerWidth-a)/2),10);top=parseInt(screenY+((outerHeight-b)/2.5),10);return"scrollbars=1, resizable=1, menubar=0, left="+c+", top="+top+", width="+a+", height="+b+", toolbar=0, status=0"},scrollUp:function(){n.scroll(0,null)},cookie:{get:function(a){var b=o.cookie.match(new RegExp("(?:^|; )"+a.replace(/([\.$?*|{}\(\)\[\]\\\/\+^])/g,'\\$1')+"=([^;]*)"));return b?decodeURIComponent(b[1]):undefined},set:function(a,b,c){c=c||{};var e=c.expires;if(typeof e=='number'&&e){var d=new Date();d.setTime(d.getTime()+e*1000);e=c.expires=d}if(e&&e.toUTCString){c.expires=e.toUTCString()}b=p.util.enc(b);var f=a+'='+b;for(var g in c){f+='; '+g;var h=c[g];if(h!==true){f+='='+h}}o.cookie=f},del:function(a){this.set(a,null,{expires:-1})}}};p.dom={$:function(b,c,d){var e,type;if(!b){return}type=b.substring(0,1);e=b.substring(1);switch(type){case'#':return o.getElementById(e);case'.':d=d?d:'*';if(typeof o.getElementsByClassName!=='function'){for(var i=-1,results=[],finder=new RegExp('(?:^|\\s)'+e+'(?:\\s|$)'),a=c&&c.getElementsByTagName&&c.getElementsByTagName(d)||o.all||o.getElementsByTagName(d),l=a.length;++i<l;finder.test(a[i].className)&&results.push(a[i]));a=null;return results}else{return(c||o).getElementsByClassName(e)};break;default:return(c||o).getElementsByTagName(b)}},attr:function(a,b,c){if(!a||typeof b==='undefined'){return false}if(typeof c!=='undefined'){a.setAttribute(b,c)}else{try{return a.getAttribute(b)}catch(e){return null}}},addEvent:function(a,e,b){var c;if(a.attachEvent){c=function(e){return b.call(a,e)};a.attachEvent('on'+e,c);return c}else if(a.addEventListener){a.addEventListener(e,b,false);return b}},removeEvent:function(a,e,b){if(a.detachEvent){a.detachEvent("on"+type,b)}else if(a.removeEventListener){a.removeEventListener(e,b,false)}},klass:function(a,b,c,d){if(!b||!a){return}if(!d){b=[b]}var e,_i,_len,re=new RegExp('(^|\\s)'+(a==='add'?c:c.replace(' ','|'))+'(\\s|$)','g');for(_len=b.length,_i=_len-1;_i>=0;_i--){e=b[_i];if(a==='add'&&re.test(e.className)){continue}e.className=a==='add'?(e.className+' '+c).replace(/\s+/g,' ').replace(/(^ | $)/g,''):e.className.replace(re,"$1").replace(/\s+/g," ").replace(/(^ | $)/g,"")}return b},select:function(a,b){var c,$options,i,_i,_len;$options=p.dom.$('option',a);for(i=_i=0,_len=$options.length;_i<_len;i=++_i){c=$options[i];if(c.value===b+''){a.selectedIndex=i;return}}},getStyle:function(a,b){var c,link;link=o.createElement('link');link.type='text/css';link.rel='stylesheet';link.href=a;p.$el.head.appendChild(link);c=new Image();c.onerror=function(){if(b){return b()}};c.src=a},getScript:function(a,b,c){var d,onComplite,script;script=o.createElement('script');script.type='text/javascript';script.setAttribute('encoding','UTF-8');script.src=a;d=false;onComplite=function(e){p.widget.loader.hide();d=true;script.onload=script.onreadystatechange=null;if(p.$el.head&&script.parentNode){p.$el.head.removeChild(script)}};script.onload=script.onreadystatechange=function(e){if(!d&&(!this.readyState||this.readyState==='loaded'||this.readyState==='complete')){onComplite();if(b!=null){b()}}};script.onerror=function(e){onComplite();if(c!=null){c}};p.widget.loader.show();p.$el.head.appendChild(script)}};p.widget={main:{$el:null,init:function(){var c;this.$el=p.dom.$('#digiseller-main');p.widget.main.$el.innerHTML='';c=function(e,a){var b,action;b=e.originalTarget||e.srcElement;action=p.dom.attr(b,'data-action');if(action&&typeof p.events[a+'-'+action]==='function'){return p.events[a+'-'+action](b,e)}};p.dom.addEvent(p.widget.main.$el,'click',function(e){return c(e,'click')})}},loader:{$el:null,timeout:null,init:function(){var a;a=o.createElement('div');a.id='digiseller-loader';a.className=a.id;a.innerHTML=p.tmpls.loader;a.style.display='none';p.$el.body.appendChild(a);this.$el=p.dom.$("#"+a.id)},show:function(){var a;clearTimeout(this.timeout);a=this;this.timeout=setTimeout(function(){return a.$el.style.display=''},1000)},hide:function(){clearTimeout(this.timeout);this.$el.style.display='none'}},search:{$el:null,$input:null,prefix:'digiseller-search',init:function(){var a,that;this.$el=p.dom.$("#"+this.prefix);if(!this.$el){return}this.$el.innerHTML=p.tmpls.search;this.$input=p.dom.$("."+this.prefix+"-input",this.$el,'input')[0];a=p.dom.$("."+this.prefix+"-form",this.$el,'form')[0];that=this;p.dom.addEvent(a,'submit',function(e){p.util.prevent(e);n.location.hash=p.opts.hashPrefix+("/search?s="+that.$input.value)})}},category:{$el:null,isInited:false,prefix:'digiseller-category',init:function(){var b;this.$el=p.dom.$("#"+this.prefix);if(!this.$el){return}this.isInited=false;b=this;p.JSONP.get(p.opts.host+'shop_categories.asp',this.$el,{seller_id:p.opts.seller_id,format:'json'},function(a){if(!a){return false}b.$el.innerHTML=b.render(a.category);b.isInited=true;b.mark()})},mark:(function(){var c;c=function(a){var b,cats,parent,sub,subs,_i,_len,_ref;cats=p.dom.$('li',this.$el);if(!cats.length){return}subs=p.dom.$('ul',this.$el);for(_i=0,_len=subs.length;_i<_len;_i++){sub=subs[_i];sub.style.display='none'}subs[0].style.display='';p.dom.klass('remove',cats,this.prefix+'-active',true);if(!a){return}b=p.dom.$("#"+this.prefix+"-"+a);if(!b){return}p.dom.klass('add',b,this.prefix+'-active');parent=b;while(parent.id!==this.prefix){parent.style.display='';parent=parent.parentNode}if((_ref=p.dom.$("#"+this.prefix+"-sub-"+a))!=null){_ref.style.display=''}};return function(a){var b,interval,that;if(!this.$el){return}if(this.isInited){c.call(this,a)}else{that=this;b=0;interval=setInterval(function(){if(that.isInited||b>1000){clearInterval(interval);if(that.isInited){c.call(that,a)}}b++},50)}}})(),render:function(a,b){var c,out,_i,_len;if(!a){return''}out='';for(_i=0,_len=a.length;_i<_len;_i++){c=a[_i];out+=p.tmpl(p.tmpls.category,{d:c,url:p.opts.hashPrefix+("/articles/"+c.id),id:this.prefix+("-"+c.id),sub:this.render(c.sub,c.id)})}return p.tmpl(p.tmpls.categories,{id:b?this.prefix+("-sub-"+b):'',out:out})}},currency:{$el:null,init:function(){var b;this.$el=p.dom.$('#digiseller-currency');if(!this.$el){return}this.$el.innerHTML=p.tmpls.currency;b=p.dom.$('select',this.$el)[0];p.dom.addEvent(b,'change',function(e){var a;a=p.dom.attr(this,'data-type');p.opts.currency=p.dom.$('option',this)[this.selectedIndex].value;p.util.cookie.set("digiseller-currency",p.opts.currency);p.historyClick.reload()});p.dom.select(b,p.opts.currency)}},pager:(function(){function _Class(b,c){this.$el=b;c=c||{};this.page=c.page||1;this.rows=c.rows||10;this.total=c.total||0;this.opts={tmpl:c.tmpl||p.tmpls.pages,max:c.max||2,getLink:c.getLink||function(a){return a},onChangeRows:c.onChangeRows||function(a){}};return}_Class.prototype.mark=function(){var a,page,pages,_i,_len;pages=p.dom.$('a',this.$el);for(a=_i=0,_len=pages.length;_i<_len;a=++_i){page=pages[a];p.dom.klass((this.page===parseInt(p.dom.attr(page,'data-page'))?'add':'remove'),page,'digiseller-activepage')}return this};_Class.prototype.render=function(){var a,left,out,page,right,that;this.page=parseInt(this.page);this.rows=parseInt(this.rows);this.total=parseInt(this.total);this.$el.style.display=this.total?'':'none';left=this.page-this.opts.max;left=left<1?1:left;right=this.page+this.opts.max;right=right>this.total?this.total:right;page=left;out='';while(page<=right){out+=this.opts.getLink(page);page++}if(left>1){out=this.opts.getLink(1)+(left>2?'<span>...</span>&nbsp;':'')+out}if(right<this.total){out=out+(right<this.total-1?'<span>...</span>&nbsp;':'')+this.opts.getLink(this.total)}this.$el.innerHTML=p.tmpl(this.opts.tmpl,{out:out});that=this;a=p.dom.$('select',this.$el)[0];p.dom.addEvent(a,'change',function(e){that.rows=p.dom.$('option',this)[this.selectedIndex].value;return that.opts.onChangeRows(that.rows)});p.dom.select(a,this.rows);this.mark();return this};return _Class})(),comments:(function(){function _Class(a,b,c){this.$el=a;this.product_id=b;this.init=c;this.isInited=false;this.type='';this.page=1;this.rows=10;this.pager=null;return}_Class.prototype.get=function(){var b;b=this;p.JSONP.get(p.opts.host+'shop_reviews.asp',this.$el,{seller_id:p.opts.seller_id,product_id:this.product_id,format:'json',type:this.type,page:this.page,rows:this.rows},function(a){if(!a){return false}b.render(a)})};_Class.prototype.render=function(a){var b,comments,out,_i,_len;comments=a.review;out='';if(!comments){out=p.tmpls.nothing}else{for(_i=0,_len=comments.length;_i<_len;_i++){b=comments[_i];out+=p.tmpl(p.tmpls.comment,{d:b})}}if(this.isInited){this.pager.page=this.page;this.pager.rows=this.rows;this.pager.total=a.totalPages;this.pager.render()}else{this.init(a);this.container=p.dom.$('.digiseller-comments',this.$el)[0];this.isInited=true}this.container.innerHTML=out};return _Class})()};p.route={home:{url:'/home',action:function(a){p.widget.category.mark();this.get()},get:function(){var b;b=this;p.JSONP.get(p.opts.host+'shop_products.asp',p.widget.main.$el,{seller_id:p.opts.seller_id,category_id:0,rows:10,format:'json',order:p.opts.sort,currency:p.opts.currency},function(a){if(!a){return false}b.render(a);p.util.scrollUp()})},render:function(a){var b,articles,out,_i,_len;out='';articles=a.product;if(articles&&articles.length){for(_i=0,_len=articles.length;_i<_len;_i++){b=articles[_i];out+=p.tmpl(p.tmpls.showcaseArticle,{d:b,url:p.opts.hashPrefix+("/detail/"+b.id),imgsize_firstpage:p.opts.imgsize_firstpage})}}return p.widget.main.$el.innerHTML=p.tmpl(p.tmpls.showcaseArticles,{out:out,categories:a.categories,opts:p.opts})}},search:{url:'/search(?:/([0-9]*))?\\?s=(.*)',search:null,page:null,rows:null,pager:null,prefix:'digiseller-search',action:function(a){this.search=decodeURIComponent(a[2]);this.page=parseInt(a[1])||1;this.rows=p.opts.rows;p.widget.category.mark();p.widget.search.$input.value=this.search;this.get()},get:function(){var b;b=this;p.JSONP.get(p.opts.host+'shop_search.asp',p.widget.main.$el,{seller_id:p.opts.seller_id,format:'json',currency:p.opts.currency,page:this.page,rows:this.rows,search:this.search},function(a){if(!a){return false}b.render(a);p.util.scrollUp()})},render:function(b){var c,articles,container,out,that,_i,_len;out='';articles=b.product;if(!articles||!articles.length){out=p.tmpls.nothing}else{for(_i=0,_len=articles.length;_i<_len;_i++){c=articles[_i];out+=p.tmpl(p.tmpls.searchResult,{url:p.opts.hashPrefix+("/detail/"+c.id),imgsize:p.opts.imgsize_listpage,d:c})}}container=p.dom.$("#"+this.prefix+"-results");if(container){container.innerHTML=out;this.pager.page=this.page;this.pager.rows=this.rows;this.pager.total=b.totalPages;this.pager.render()}else{p.widget.main.$el.innerHTML=p.tmpl(p.tmpls.searchResults,{totalItems:b.totalItems,out:out});that=this;this.pager=new p.widget.pager(p.dom.$('.digiseller-paging',p.widget.main.$el)[0],{page:this.page,rows:this.rows,total:b.totalPages,getLink:function(a){return p.tmpl(p.tmpls.page,{page:a,url:p.opts.hashPrefix+("/search/"+a+"?s="+that.search)})},onChangeRows:function(a){p.opts.rows=a;p.util.cookie.set(p.route.articles.prefix+'-rows',a);that.page=1;that.rows=a;that.get();p.historyClick.changeHashSilent(p.opts.hashPrefix+("/search/1?s="+that.search))}}).render();p.widget.currency.init()}p.dom.$("#"+this.prefix+"-query").innerHTML=this.search.replace('<','&lt;').replace('>','&gt;');p.dom.$("#"+this.prefix+"-total").innerHTML=b.totalItems}},articles:{url:'/articles/([0-9]*)(?:/([0-9]*))?',cid:null,page:1,rows:null,pager:null,pagerComments:null,prefix:'digiseller-articles',action:function(a){this.cid=a[1];this.page=parseInt(a[2])||1;this.rows=p.opts.rows;this.get()},get:function(){var b;p.widget.category.mark(this.cid);b=this;p.JSONP.get(p.opts.host+'shop_products.asp',p.widget.main.$el,{seller_id:p.opts.seller_id,format:'json',category_id:this.cid,page:this.page,rows:this.rows,order:p.opts.sort,currency:p.opts.currency},function(a){if(!a){return false}b.render(a);p.util.scrollUp()})},render:function(b){var c,article,articles,container,out,that,_i,_len;out='';b.totalPages=parseInt(b.totalPages);articles=b.product;if(!articles||!articles.length){out=p.tmpls.nothing}else{for(_i=0,_len=articles.length;_i<_len;_i++){article=articles[_i];out+=p.tmpl(p.tmpls.article,{d:article,url:p.opts.hashPrefix+("/detail/"+article.id),imgsize:p.opts.imgsize_listpage})}}container=p.dom.$("#"+this.prefix+"-"+this.cid);if(container){container.innerHTML=out;this.pager.page=this.page;this.pager.rows=this.rows;this.pager.total=b.totalPages;this.pager.render()}else{p.widget.main.$el.innerHTML=p.tmpl(p.tmpls.articles,{id:this.prefix+("-"+this.cid),opts:p.opts,d:b,hasCategories:!b.categories||!b.categories.length?false:true,articlesPanel:b.totalPages?p.tmpls.articlesPanel:'',out:out});if(b.totalPages){that=this;this.pager=new p.widget.pager(p.dom.$("."+this.prefix+"-pager",p.widget.main.$el)[0],{page:this.page,rows:this.rows,total:b.totalPages,getLink:function(a){return p.tmpl(p.tmpls.page,{page:a,url:p.opts.hashPrefix+("/articles/"+that.cid+"/"+a)})},onChangeRows:function(a){p.opts.rows=a;p.util.cookie.set(""+that.prefix+"-rows",a);that.page=1;that.rows=a;that.get();p.historyClick.changeHashSilent(p.opts.hashPrefix+("/articles/"+that.cid+"/1"))}}).render();p.widget.currency.init();c=p.dom.$('select',p.dom.$('#digiseller-sort'))[0];p.dom.addEvent(c,'change',function(e){p.opts.sort=p.dom.$('option',this)[this.selectedIndex].value;p.util.cookie.set(this.prefix+'-sort',p.opts.sort);return that.get()});p.dom.select(c,p.opts.sort)}}}},article:{url:'/detail(?:/([0-9]*))',comments:null,id:null,prefix:'digiseller-article',action:function(b){var c;this.id=b[1]||0;c=this;p.JSONP.get(p.opts.host+'shop_product_info.asp',p.widget.main.$el,{seller_id:p.opts.seller_id,format:'json',product_id:this.id,currency:p.opts.currency},function(a){if(!a){return false}c.render(a);p.util.scrollUp()})},render:function(b){var c,$thumbs,that,_i,_len,_ref;if(!b||!b.product){p.widget.main.$el.innerHTML=p.tmpls.nothing;return}p.widget.category.mark(b.product.category_id);p.widget.main.$el.innerHTML=p.tmpl(p.tmpls.articleDetail,{d:b.product,imgsize:p.opts.imgsize_infopage});p.widget.currency.init();that=this;$thumbs=p.dom.$("#"+this.prefix+"-thumbs");if($thumbs&&$thumbs.children){_ref=$thumbs.children;for(_i=0,_len=_ref.length;_i<_len;_i++){c=_ref[_i];p.dom.addEvent(c,'click',function(e){var a,$preview,$previewImg,height,id,orig,width;a=this;if(p.dom.attr(a,'class')==='digiseller-videothumb'){return}p.util.prevent(e);orig=p.dom.attr(a,'href');id=p.dom.attr(a,'data-id');height=parseInt(p.dom.attr(a,'data-height'));width=parseInt(p.dom.attr(a,'data-width'));$preview=p.dom.$("#"+that.prefix+"-img-preview");$previewImg=p.dom.$('img',$preview)[0];$preview.href=orig;$previewImg.src=$previewImg.src.replace(/idp=[0-9]+&(h|w)/i,"idp="+id+"&"+(height>width?'h':'w'))})}}},initComments:function(d){var f,that;f=p.dom.$(("#"+this.prefix+"-comments-")+this.id);if(p.dom.attr(f,'inited')){if(d){d()}return}that=this;this.comments=new p.widget.comments(f,this.id,function(b){var c;p.dom.attr(f,'inited',1);that.comments.$el.innerHTML=p.tmpl(p.tmpls.comments,{totalGood:b.totalGood,totalBad:b.totalBad});if(d){d()}c=p.dom.$('select',f)[0];p.dom.addEvent(c,'change',function(e){that.comments.page=1;that.comments.type=p.dom.$('option',this)[this.selectedIndex].value;return that.comments.get()});that.comments.pager=new p.widget.pager(p.dom.$('.digiseller-paging',that.comments.$el)[0],{page:that.comments.page,rows:that.comments.rows,total:b.totalPages,getLink:function(a){return p.tmpl(p.tmpls.pageComment,{page:a,url:'#'})},onChangeRows:function(a){p.util.cookie.set('digiseller-comments-rows',a);that.comments.page=1;that.comments.rows=a;that.comments.get()}}).render()});this.comments.rows=p.util.cookie.get('digiseller-comments-rows')||10;this.comments.get()}},reviews:{url:'/reviews(?:/([0-9]*))?',comments:null,id:"",prefix:'digiseller-reviews',action:function(b){var c;if(!p.dom.$('#'+this.id)){this.id=this.prefix+("-"+(p.util.getUID()));c=this;this.comments=new p.widget.comments(p.widget.main.$el,'',function(a){c.initComments(a);return p.util.scrollUp()})}this.comments.page=parseInt(b[1])||1;this.comments.rows=p.util.cookie.get(this.prefix+'-rows')||10;this.comments.get()},initComments:function(b){var c;this.comments.$el.innerHTML=p.tmpl(p.tmpls.reviews,{id:this.id,totalGood:b.totalGood,totalBad:b.totalBad});c=this;this.comments.pager=new p.widget.pager(p.dom.$('.digiseller-paging',this.comments.$el)[0],{page:this.comments.page,rows:this.comments.rows,total:b.totalPages,getLink:function(a){return p.tmpl(p.tmpls.pageReview,{page:a,url:"#!digiseller/reviews/"+a})},onChangeRows:function(a){p.util.cookie.set(this.prefix+'-rows',a);c.comments.page=1;c.comments.rows=a;c.comments.get()}}).render();p.dom.addEvent(p.dom.$('select',p.dom.$("#"+this.prefix+"-type"))[0],'change',function(e){c.comments.page=1;c.comments.type=p.dom.$('option',this)[this.selectedIndex].value;return c.comments.get()})}},contacts:{url:'/contacts',action:function(b){var c;c=this;p.JSONP.get(p.opts.host+'shop_contacts.asp',p.widget.main.$el,{seller_id:p.opts.seller_id,format:'json'},function(a){if(!a){false}p.widget.main.$el.innerHTML=p.tmpl(p.tmpls.contacts,{d:a});p.util.scrollUp()})}}};p.events={'click-comments-page':function(a,e){var b;p.util.prevent(e);b=p.dom.attr(a,'data-page');p.route.article.comments.page=b;p.route.article.comments.get()},'click-buy':function(a,e){var b;p.util.prevent(e);b=p.dom.attr(a,'data-id');n.open("https://www.oplata.info/asp/pay_x20.asp?id_d="+b+"&dsn=limit",'_blank')},'click-article-tab':function(b,e){var c,change,index;p.util.prevent(e);index=p.dom.attr(b,'data-tab');c=b.parentNode.nextSibling.children;p.dom.klass('remove',b.parentNode.children,'digiseller-activeTab',true);p.dom.klass('add',b,'digiseller-activeTab');change=function(){var a,_i,_len;for(_i=0,_len=c.length;_i<_len;_i++){a=c[_i];a.style.display='none'}return c[index].style.display=''};if(index==='1'){p.route.article.initComments(change)}else{change()}},'click-share':function(a,e){var b,title,type;type=p.dom.attr(a,'data-type');title=p.dom.attr(a,'data-title');b=p.dom.attr(a,'data-img');if(p.share[type]){return n.open(p.share[type](title,b),"digisellerShare_"+type,p.util.getPopupParams(626,436))}}};p.share={vk:function(a,b){return"//vkontakte.ru/share.php?url="+(p.util.enc(o.location))+"&title="+(p.util.enc(a))+"&image="+(p.util.enc(b))+"&noparse=true"},tw:function(a){return"//twitter.com/share?text="+(p.util.enc(a))+"&url="+(p.util.enc(o.location))},fb:function(a,b){return"//www.facebook.com/sharer.php?s=100&p[url]="+(p.util.enc(o.location))+"&p[title]="+(p.util.enc(a))+"&p[images][0]="+(p.util.enc(b))},wme:function(a,b){return"//events.webmoney.ru/sharer.aspx?url="+(p.util.enc(o.location))+"&title="+(p.util.enc(a))+"&image="+(p.util.enc(b))+"&noparse=0"}};p.historyClick=(function(){var c='',_needReload=false,_routes=[],_revRoutes=[];function init(){if(!d.interval){d.interval=setInterval(urlHashCheck,100)}}function urlHashCheck(){var a=false;if(_needReload){a=true}if(n.location.hash!==d.currentHash||_needReload){d.prevHash=(_needReload?d.prevHash:d.currentHash);d.currentHash=n.location.hash.toString();go(d.currentHash&&d.currentHash!='#'?d.currentHash:c);if(a){_needReload=false}}}function go(a){if(!a){return}var b,callback;for(var i=0,len=_revRoutes.length;i<len;i++){b=_revRoutes[i][0];callback=_revRoutes[i][1];if(b.test(a)&&typeof callback==='function'){d.params=a.match(b);callback(d.params);return}}}var d={interval:null,currentHash:'',prevHash:'',params:[],start:function(){init()},rootAlias:function(a){if(a){c=a}else{return c}},addRoute:function(a,b){if(typeof a==='string'){a=[a]}for(var i=0;i<a.length;i++){_routes.push([new RegExp(a[i],'i'),b])}_revRoutes=_routes.slice().reverse()},reload:function(){_needReload=true},changeHashSilent:function(a){d.prevHash=d.currentHash;d.currentHash=n.location.hash=a}};return d})();p.JSONP=(function(){var i=[];function jsonp(b,c,d,e){var f=(b||'').indexOf('?')===-1?'?':'&',key;d=d||{};var g=p.util.getUID();d.queryId=g;for(key in d){if(!d.hasOwnProperty(key)){continue}f+=p.util.enc(key)+'='+p.util.enc(d[key])+'&'}var h=c?true:false;if(h){p.dom.attr(c,'data-qid',g)}i[g]=function(a){if(h&&(!c||a.queryId!=p.dom.attr(c,'data-qid'))){return}e(a)};p.dom.getScript(b+f+'_'+Math.random());return g}return{get:jsonp,callback:function(a){if(!a||!a.queryId||!i[a.queryId]){return}i[a.queryId](a);try{delete i[a.queryId]}catch(e){}i[a.queryId]=null}}})();p.tmpl=function(g,h){settings={evaluate:/<\?([\s\S]+?)\?>/g,interpolate:/<\?=([\s\S]+?)\?>/g,escape:/<\?-([\s\S]+?)\?>/g};var i=/(.)^/;var j=new RegExp([(settings.escape||i).source,(settings.interpolate||i).source,(settings.evaluate||i).source].join('|')+'|$','g');var k=0,source="__p+='",escaper=/\\|'|\r|\n|\t|\u2028|\u2029/g,escapes={"'":"'",'\\':'\\','\r':'r','\n':'n','\t':'t','\u2028':'u2028','\u2029':'u2029'};g.replace(j,function(b,c,d,e,f){source+=g.slice(k,f).replace(escaper,function(a){return'\\'+escapes[a]});source+=c?"'+\n((__t=("+c+"))==null?'':_.escape(__t))+\n'":d?"'+\n((__t=("+d+"))==null?'':__t)+\n'":e?"';\n"+e+"\n__p+='":'';k=f+b.length});source+="';\n";if(!settings.variable){source='with(obj||{}){\n'+source+'}\n'}source="var __t,__p='',__j=Array.prototype.join,"+"print=function(){__p+=__j.call(arguments,'');};\n"+source+"return __p;\n";try{var l=new Function(settings.variable||'obj',source)}catch(e){e.source=source;throw e;}if(h){return l(h)}var m=function(a){return l.call(this,a)};m.source='function('+(settings.variable||'obj')+'){\n'+source+'}';return m};inited=false;p.init=function(){if(inited){return false}inited=true;p.$el.head=p.dom.$('head')[0]||o.documentElement;p.$el.body=p.dom.$('body')[0]||o.documentElement;p.dom.getStyle(p.opts.host+'shop_css.asp?seller_id='+p.opts.seller_id,function(){var c,route,_fn,_ref,_ref1,_ref2;p.opts.currency=p.util.cookie.get('digiseller-currency')||p.opts.currency;p.opts.sort=p.util.cookie.get(p.route.articles.prefix+'-sort')||p.opts.sort;p.opts.rows=p.util.cookie.get(p.route.articles.prefix+'-rows')||p.opts.rows;p.widget.category.init();p.widget.main.init();p.widget.loader.init();p.widget.search.init();if((_ref=p.dom.$('#digiseller-logo'))!=null){_ref.innerHTML=p.tmpl(p.tmpls.logo,{logo_img:p.opts.logo_img})}if((_ref1=p.dom.$('#digiseller-topmenu'))!=null){_ref1.innerHTML=p.tmpl(p.tmpls.topmenu,{d:p.opts})}if(!p.widget.category.$el){p.widget.main.$el.className='digiseller-main-nocategory'}_ref2=p.route;_fn=function(b){p.historyClick.addRoute(p.opts.hashPrefix+b.url,function(a){b.action(a)})};for(c in _ref2){route=_ref2[c];if(!(p.route.hasOwnProperty(c)||route.url||route.action)){continue}_fn(route)}p.historyClick.rootAlias(p.opts.hashPrefix+'/home');p.historyClick.start();if(n.location.hash===''){p.historyClick.reload()}})};n.DigiSeller=p;p.dom.addEvent(n,'load',p.init)})(window,document)}).call(this);