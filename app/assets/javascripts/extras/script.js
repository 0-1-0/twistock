$(function(){

	// Modal window Mail
	$("#haction").click(function() {
		$("#modal-mail").reveal();
		return false;
	});


	// Scroll
	$(".scroll").mCustomScrollbar();


	// Button Close Dialog (x)
	$('.close-dialog').on('click', function(){
		$(this).closest('.bg').fadeOut(160);
		return false;
	});

	// History dialog
	$('#header_history').on('click', function(){
		var history = $('.history');

		$('.dialog').not( history ).fadeOut(160);

		history.fadeIn(160, function(){
			$(".scroll").mCustomScrollbar("update");
		});
		return false;
	});

	// Change dialog
	$('#header_change').on('click', function(){
		var network = $('.network');

		$('.dialog').not( network ).fadeOut(160);

		network.fadeIn(160);
		return false;
	});


	// CheckBox
	$('.checkbox').checkbox({cls:'checkbox'});



});


$('#tiles').imagesLoaded(function() {
	var options = {
		autoResize: true,
		container: $('#top'),
		offset: 13,
		itemWidth: $('#tiles .bg').outerWidth()
	};

	$('#tiles li').wookmark(options);
});