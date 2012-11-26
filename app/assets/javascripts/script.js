$(document).ready(function(){

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

$(document).ready(function(){
    $('#tiles').imagesLoaded(function() {
        var options = {
            autoResize: true,
            container: $('#top'),
            offset: 13,
            itemWidth: $('#tiles .bg').outerWidth()
        };

        $('#tiles li').wookmark(options);
    });
});