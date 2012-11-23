$(function() {

	var slide = $( "#slider-price" ),
		max_count = 84;

	slide.slider({
		// range: "min",
		value: 1,
		min: 1,
		max: max_count,
		slide: function( event, ui ) {
			$( "#snum" ).text( ui.value );
		}
	});

	slide.find('.ui-slider-handle').append('<span id="snum" class="snum">'+ slide.slider( "value" ) +'</span>');


	// Buy Btn
	$('.btn-buy').on('click', function(){

		if( $(this).hasClass('buy-cancel') ){
			$(this).removeClass('alert buy-cancel').addClass('secondary').text('Buy').closest('.blk').removeClass('active');
		} else {
			$(this).removeClass('secondary buy-cancel').addClass('alert buy-cancel').text('Cancel').closest('.blk').addClass('active');
		}

		// $('.dialog').not( network ).fadeOut(160);

		// network.fadeIn(160);
		return false;
	});

});