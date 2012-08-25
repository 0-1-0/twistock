//Infinite scroll

// var page = 0,
//   loading = false, initial = true;

// function nearBottomOfPage() {
// return $(window).scrollTop() > $(document).height() - $(window).height();
// }


// function updateInfoLine(){
// 	if (loading) {
// 		return;
// 	}


// 	if((nearBottomOfPage() || initial) ) {

// 	  loading=true;
// 	  $.ajax({
// 	    url: '/stream/infoline?page=' + page,
// 	    type: 'get'
// 	  }).done(function(data){
// 	  	loading=false;
// 	  	page++;
// 	  	$('.market-infinite').append(data);
// 	  });
// 	}
// }

// $(window).scroll(function(){
// 	updateInfoLine();
// });

// updateInfoLine();
// var cnt = {};
// var position = {}

$(".scroll").each(function(index){
  $(this).simplyScroll({orientation:'vertical',direction:'backwards',speed: (index%2+1),customClass:'vert'});
});


//$('.tooltip').tooltip();
 

//initialize emitters
// $('.emitter').each(function(index) {
// 	var emitter = $(this);

// 	$.ajax({
//     url: emitter.attr('url') + '?page=1',// + cnt[index],
//     type: 'get'
//   }).done(function(data){
//   	emitter.append(data);
//   });
	
//  });

//Perform animation
// move.defaults = {
//   duration: 40
// };
// if($(window).width() >= 1024){


// setInterval(function(){

// 	if(! $('#most-valuable').is(':hover')){
//     move('#most-valuable')
//     .add('top', -200)
//     .end();	
//   }

//   if(! $('#most-booming').is(':hover')){
//     move('#most-booming')
//     .add('top', -250)
//     .end();	
//   }

//   if(! $('#most-falling').is(':hover')){
//     move('#most-falling')
//     .add('top', -180)
//     .end();	
//   }

//    if(! $('#random-deals').is(':hover')){
//     move('#random-deals')
//     .add('top', -360)
//     .end();	
//   }
// }, 2400);


//Enable Emitters
// setInterval( function() {
// 			 $('.emitter').each(function(index) {	

// 						if(! $(this).is(':hover')){
// 							//position[index] -= $(this).attr('speed');
						
// 							// $(this).css(
// 							// 	"top",
// 							//   position[index]
// 							// );

// 							if($(this).position().top + $(this).height() < $(window).height()){
// 								var emitter = $(this);

// 							// 	if ($(this).height() > $(window).height()*2){
// 							// 		child = $(this).children(":last");
// 							// 		$(this).append(child.clone());
// 							// 		child.remove();
// 							// 		position[index] += child.height();
// 							// 		$(this).css(
// 							// 	"top",
// 							//   position[index]
// 							// );

// 							// 	}else{

// 											$.ajax({
// 										    url: $(this).attr('url') + '?page=' + cnt[index],
// 										    type: 'get'
// 										  }).done(function(data){
// 										  	cnt[index] += 1;
// 										  	//alert($(this).attr('url'));
// 										  	if(data.length < 10){
// 										  		cnt[index] = 0;
// 										  	}
// 										  	emitter.append(data);
// 										  });

// 							//	}

// 							}
// 					}
						
// 				});
// } , 1000);

// };












