$(document).ready(function(){
    // Button Close Dialog (x)
    $('.close-dialog').on('click', function(){
        $(this).closest('.bg').fadeOut(160);
        return false;
    });



    // Change dialog
    $('#header_change').on('click', function(){
        var network = $('.network');

        $('.dialog').not( network ).fadeOut(160);

        network.fadeIn(160);
        return false;
    });



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


});