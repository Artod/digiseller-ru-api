$(function($) {			
	var $form = $('#preview-form');
	if (!$form.length) {
		return;
	}
	
	var _data,
		$inputs = $form.find('input'),		
		$radio = $inputs.filter('[type="radio"]'),
		$previews = $('#preview [data-preview]'),
		names = ['code', 'logo', 'langs', 'cart', 'search', 'topmenu', 'menu', 'catalog'],
		$textarea = $('#preview-textarea');
		
	var escapeHtmlEntities = function (text) {
		return text.replace(/[\u00A0-\u2666<>\&]/g, function(c) {
			return '&' + 
			(escapeHtmlEntities.entityTable[c.charCodeAt(0)] || '#'+c.charCodeAt(0)) + ';';
		});
	};

	escapeHtmlEntities.entityTable = {
		60 : 'lt', 
		62 : 'gt'
	};
	
	var refreshData = function() {
		var $disabled = $form.find('input:disabled').removeAttr('disabled'),
			serAr = $form.serializeArray();
			
		$disabled.attr('disabled', 'disabled');
		
		_data = {};

		for (var i in serAr) {
			_data[serAr[i].name] = serAr[i].value;
		}
		
		_data.catalog = 1;
		_data.code = 1;
	};
	
	var highlight = function(name, show) {
		$previews.filter('[data-preview="' + name + '"]')[show ? 'addClass' : 'removeClass']('yellow_bg');
	};
	
	var render = function() {
		refreshData();

		var code = '';
		
		$.each(names, function(i, name) {
			var $preview = $previews.filter('[data-preview="' + name + '"]');
			
			if (name === 'menu') {				
				$preview.parent()[_data[name] ? 'removeClass' : 'addClass']('preview-menu-hide')[_data[name] && _data.menutype === 'h' ? 'addClass' : 'removeClass']('preview-menu-h');	
				$radio[_data[name] ? 'removeAttr' : 'attr']('disabled', 'disabled').closest('ul')[_data[name] ? 'removeClass' : 'addClass']('categories-checkbox-disabled');
			} else {
				$preview[_data[name] ? 'show' : 'hide']();
			}

			if (!_data[name]) {
				return;
			}
			
			var raw = $('#template-' + name).html();
			
			if (name === 'code') {
				raw = raw.replace(/{script}/g, 'script').replace(/{sid}/g, window.sid);
			} else if (name === 'menu') {
				raw = raw.replace('{hmenu}', _data.menu && _data.menutype === 'h' ? ' digiseller-hmenu' : '');
			} else if (name === 'catalog') {
				raw = raw.replace('{fullwidth}', !_data.menu || (_data.menu && _data.menutype === 'h') ? ' digiseller-fullwidth' : '')
			}
			
			code += raw;
		});		
		
		$textarea.val(code).fadeOut(100).fadeIn(100);
	};
	
	render();
	
	$inputs.filter('[type="checkbox"]').parent().on('mouseenter', function() {
		var $input = $(this).find('> input');		
		if ( !$input.is(':checked') ) {
			return;
		}
		
		highlight($input.attr('name'), true);
	}).on('mouseleave', function() {
		var name = $(this).find('> input').attr('name');		
		highlight(name, false);
	});

	$inputs.on('change', function() {
		var $input = $(this);
		
		render();
		
		$input.trigger('mouseleave').trigger('mouseenter');				
	});
	
	$textarea.on('focus', function() {
		$textarea.select();
	});
});