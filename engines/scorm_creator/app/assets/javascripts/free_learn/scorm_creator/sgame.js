var catalog = {};
//TODO create fancybox not working
SGAME_WEB = (function($,undefined){
	catalog.games = {};
	catalog.sfs = {};

	current_game = {};
	current_scorm_files = [];

	var games_carrousel_id = "games_carrousel";
	//var sf_carrousel_id = "lo_carrousel";

	var gallery = false;

	var init = function (){
		_createFancybox();
		_requestScormFiles(_createScormFilesList);
		_requestGameTemplates(_createGameCarrousel);
		_loadEvents();
	}

	var initGallery = function(){
		_requestGames(_createGalleryCarrousel);

		$("#closeGameIframe").click(function(){
			$("#closeGameIframe").hide();
			$("#gameInstance").attr("src","");
		});
	}

	var _createFancybox = function(){
		$("#upload_scorm").fancybox({
			'autoDimensions' : false,
			'scrolling': 'no',
			'width': 600,
			'height': 400,
			'padding': 0,
			'hideOnOverlayClick': false,
			'hideOnContentClick': false,
			'showCloseButton': true
		});

		$("#game_fancybox_link").fancybox({
			'autoDimensions' : false,
			'scrolling': 'no',
			'width': 600,
			'height': 400,
			'padding': 0,
			'hideOnOverlayClick': false,
			'hideOnContentClick': false,
			'showCloseButton': true
		});
	};

	var _createGameCarrousel = function(games){
		var carrouselImages = [];
		var carrouselImagesTitles = [];

		//carrouselImagesTitles.push("Upload");
		$.each(games, function(i, game) {
			var myImg = $("<img itemId="+game.id+" src="+game.avatar_url+" />");
			carrouselImages.push($(myImg)[0]);
			carrouselImagesTitles.push(game.name);
			catalog.games[game.id] = game;
		});
		CarrouselWrapper.loadImagesOnCarrouselOrder(carrouselImages,_onGameImagesLoaded,games_carrousel_id,carrouselImagesTitles);
	}

	var _createGalleryCarrousel = function(games){
		var carrouselImages = [];
		var carrouselImagesTitles = [];
		console.log(carrouselImages);
		$.each(games, function(i, game) {
			var myImg = $("<img itemId="+game.id+" src="+game.avatar_url+" />");
			carrouselImages.push($(myImg)[0]);
			carrouselImagesTitles.push(game.name);
			catalog.games[game.id] = game;
		});

		CarrouselWrapper.loadImagesOnCarrouselOrder(carrouselImages,_onGalleryImagesLoaded,games_carrousel_id,carrouselImagesTitles);
	}

	var _onGameImagesLoaded = function(){
		$("#" + games_carrousel_id).show();
		var options = new Array();
		options['rows'] = 1;
		options['callback'] = _onGameSelected;
		options['rowItems'] = 3;
		options['styleClass'] = "game";
		CarrouselWrapper.createCarrousel(games_carrousel_id, options);

		_previewGame(catalog.games[Object.keys(catalog.games)[0]]); //Preview first game
	}

	var _onGalleryImagesLoaded = function(){
		$("#" + games_carrousel_id).show();
		var options = new Array();
		options['rows'] = 1;
		options['callback'] = _onGameSelectedInGallery;
		options['rowItems'] = 6;
		options["width"] = 1100;
		options['styleClass'] = "gallery";
		CarrouselWrapper.createCarrousel(games_carrousel_id, options);
	}

	/* sfs is an array with scorm_files
	*/
	var _createScormFilesList = function(sfs){
		var listDiv = $(".scorm_list .list-group");
		_createImageList(sfs,listDiv);
		catalog.sfs = sfs;

	}

	var _createImageList = function(resourceList,listDiv){

		for (var n = 0; n<resourceList.length;n++){

			var li = $(document.createElement('li'));

			//panel default
			var element = $(document.createElement('div')).attr("class", "panel panel-default").attr("id",resourceList[n].id);

			//image
			var image_panel = $(document.createElement('div')).attr("class","panel-img");
			var img = $('<img />',{src: resourceList[n].avatar_url,width: 75,height:75});
			image_panel.append(img);

			var name_panel = $(document.createElement('div')).attr("class", "panel-body");
			var name = $(document.createElement('p')).text(resourceList[n].name + ": ");
			var description = $(document.createElement('p')).text(resourceList[n].description);
			name_panel.append(name)
			name_panel.append(description);


			var tick_panel = $(document.createElement('div')).attr("class", "panel-tick");
			var tick = $(document.createElement('span')).attr("class", "glyphicon glyphicon-ok non-checked").attr("aria-hidden", "true");

			tick_panel.append(tick);

			element.append(image_panel)
			element.append(name_panel)
			element.append(tick_panel);
			element.click(function(){
				_listItemChecks($(this));
				//TODO: onSFSelected
				_onSFSelected(this);
			});
			li.append(element);

			listDiv.append(li);

		}
	};

	var _listItemChecks = function(element){
				var tick= element.find(".panel-tick span");
				if(tick.is(':visible')){
					tick.hide();
					element.removeClass("selected");

				}else{
					tick.show();
					element.addClass("selected");
				}
	};

	var _onSFImagesLoaded = function(){
		$("#" + sf_carrousel_id).show();
		var options = new Array();
		options['rows'] = 1;
		options['callback'] = _onSFSelected;
		options['rowItems'] = 3;
		options['styleClass'] = "game";
		CarrouselWrapper.createCarrousel(sf_carrousel_id, options);
	}


	/**
	 * Events
	 */
	 var _loadEvents = function(){
	 	$("#create_form_div").click(function(){
			if(current_scorm_files.length===0){
				alert("Select at least one scorm file");
				return;
			}
			else{
				var scorms_info = "";
				for (var i = current_scorm_files.length - 1; i >= 0; i--) {
					scorms_info = scorms_info + " " + current_scorm_files[i].name;
				};
				$("#g_template_info").html(current_game.name);
				$("#scorms_info").html(scorms_info);
				$("#game_fancybox_link").click();
			}
	 	});


	 	$("#submit_game_form").click(function(){
			var scorm_ids_array = [];
			for (var i = current_scorm_files.length - 1; i >= 0; i--) {
				scorm_ids_array.push(current_scorm_files[i].id);
			};
			$("#scorms_ids").val(JSON.stringify(scorm_ids_array));
		 	$("#g_template_id").val(current_game.id);
		 	$("#create_form").submit();
	 	});

	 };

	/**
	 * API
	 */
	 var _requestScormFiles = function(successCallback,failCallback){
		$.ajax({
			async: false,
			type: 'GET',
			url: '/scorm_file.json',
			dataType: 'json',
			success: function(data) {
				if(typeof successCallback == "function"){
					successCallback(data);
				}
			},
			error: function(xhr, ajaxOptions, thrownError){
				if(typeof failCallback == "function"){
					failCallback(xhr, ajaxOptions, thrownError);
				}
			}
		});
	};

	var _requestGameTemplates = function(successCallback,failCallback){
		$.ajax({
			async: false,
			type: 'GET',
			url: '/game_template.json',
			dataType: 'json',
			success: function(data) {
				if(typeof successCallback == "function"){
					successCallback(data);
				}
			},
			error: function(xhr, ajaxOptions, thrownError){
				if(typeof failCallback == "function"){
					failCallback(xhr, ajaxOptions, thrownError);
				}
			}
		});
	}

	var _requestGames = function(successCallback,failCallback){
		$.ajax({
			async: false,
			type: 'GET',
			url: '/game.json',
			dataType: 'json',
			success: function(data) {
				if(typeof successCallback == "function"){
					successCallback(data);
				}
			},
			error: function(xhr, ajaxOptions, thrownError){
				if(typeof failCallback == "function"){
					failCallback(xhr, ajaxOptions, thrownError);
				}
			}
		});
	}



	/**
	 * Callbacks
	 */

	var _onGameSelected = function(event){
		var itemid = $(event.target).attr("itemid");
		if(itemid!==undefined){
			var id = parseInt(itemid);
			if(id===-1){
				_triggerFacyboxToUploadNewGame();
				return;
			}
			var game = catalog.games[id];
			_previewGame(game);
		}
	}

	var _onGameSelectedInGallery = function(event){
		var itemid = $(event.target).attr("itemid");
		if(itemid!==undefined){
			var id = parseInt(itemid);
			var game = catalog.games[id];
			_renderGameInstance(game);
		}
	}

	var _onSFSelected = function(event){

		var itemid = $(event).attr("id");
		if(itemid!==undefined){
			var id = parseInt(itemid);
			if(id===-1){
				_triggerFacyboxToUploadNewLO();
				return;
			}

			var sf = catalog.sfs[id];
			_addSF(sf);

		}
	}

	/*
	 * Update UI
	 */

	var _previewGame = function(game){
		current_game = game;
		$("#game_preview").attr("src",game.avatar_url);
		$("#game_description").html(game.description);
	}

	var _renderGameInstance = function(game){
		current_game = game;
		$("#gameInstance").attr("src","/game/"+game.id+".full");
		$("#closeGameIframe").show();
	}

	var _triggerFacyboxToUploadNewGame = function(game){
		//TODO
		// console.log("New game");
		alert("Upload Game: Service temporarily unavailable");
	}

	var _triggerFacyboxToUploadNewLO = function(game){
		$("#upload_scorm").click();
	}

	var _addSF = function(sf){

		//Max 3
		if(current_scorm_files.length >= 3){
			return;
		}

		//Already added LO
		if(current_scorm_files.indexOf(sf)!==-1){
			return;
		}
		current_scorm_files.push(sf);
		/*
		var scos_ids = sf.scos_ids;
		var assets_ids = sf.assets_ids;
		var all_ids = scos_ids.concat(assets_ids);
		var li = $("<li itemid='"+sf.id+"'>")

		var img = $("<img class='lo_preview' src='"+sf.avatar_url+"' />");
		var img_wrapper = $("<div class='lo_preview_wrapper'>");
		$(img_wrapper).append(img);
		$(li).append(img_wrapper);

		$(img).click(function(){
			_previewScormFile(all_ids,sf.name);
		});

		var description = $("<p class='lo_description'>"+sf.description+"</p>");
		var description2 = $("<p class='lo_number'>"+scos_ids.length+" SCOs and "+assets_ids.length+" assets</p>");
		var description_wrapper = $("<div class='lo_description_wrapper'>");
		$(description_wrapper).append(description);
		$(description_wrapper).append(description2);
		$(li).append(description_wrapper);

		var remove = $("<div class='remove_wrapper'><img class='remove' src='/assets/remove.png'/></div>");
		$(li).append(remove);

		$("#lo_list").append(li);

		$(remove).click(function(event){
			var li = $(event.target).parent().parent();
			var id = $(li).attr("itemid");
	 		 _removeSF(catalog.sfs[id]);
	 		 $(li).remove();
		});
		*/
	};

	//receives an array of ids of the los to show
	var _previewScormFile = function(lo_ids_array, sf_name){
		var links = "";
		$.each(lo_ids_array, function(i, lo_id) {
			var title = 'Preview of the learning object #'+i+ ' from the SCORM package "'+sf_name+'"';
			links += "<a rel='hidden_lo' href='/lo/"+lo_id+"' title='"+title+"'></a>";
		});

		$("#hidden_for_fancy").append(links);
		$("a[rel=hidden_lo]").fancybox({
                'transitionIn'      : 'none',
                'transitionOut'     : 'none',
                'width'             : '75%',
                'height'            : '85%',
                'autoScale'         : false,
                'type'              : 'iframe',
                'titleShow'			: true,
                'titlePosition' 	: 'inside',
                'onClosed'			: function(){ $("a[rel=hidden_lo]").remove();}
            });
		$("a[rel=hidden_lo]:first").click();
	};

	var _removeSF = function(sf){
		current_scorm_files.splice(current_scorm_files.indexOf(sf),1);
	}

	return {
		init 		: init,
		initGallery : initGallery
	};

}) (jQuery);

