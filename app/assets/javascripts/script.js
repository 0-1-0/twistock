$(document).ready(function(){


    // Show Help
    // $('body').css('overflow', 'hidden');
    var help_block = $('#help').css('height', $(document).outerHeight() ),
        inner_block = help_block.find('.six').css( 'height', $(window).height() );

    $(window).resize(function(){
        help_block.css('height', $(document).outerHeight() );
        inner_block.css( 'height', $(window).height() );
    });

    $('#show_help').on('click', function() {
        // $('body').css('overflow', 'hidden');

        help_block.fadeIn(160,function(){
            $(this).find('*').fadeIn(250);
        })
            .on('click', function(){
                $(this).fadeOut(160).find('*').fadeOut(100);
                $('body').css('overflow', 'auto');
            });
        return false;
    });


    $(document).scroll(function(e){
        // alert('!');
        $('#help').css({'height': $(document).height()});
        
    })


});