var page = 0,
  loading = false, initial = true;

function nearBottomOfPage() {
return $(window).scrollTop() > $(document).height() - $(window).height();
}


function updateInfoLine(){
	if (loading) {
		return;
	}


	if(nearBottomOfPage() || initial) {

	  loading=true;
	  $.ajax({
	    url: '/stream/infoline?page=' + page,
	    type: 'get'
	  }).done(function(data){
	  	loading=false;
	  	page++;
	  	$('.market-infinite').append(data);
	  });
	}
}

$(window).scroll(function(){
	updateInfoLine();
});

updateInfoLine();






