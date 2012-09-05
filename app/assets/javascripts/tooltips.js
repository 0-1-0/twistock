$("#random-person").tooltip({
    title: I18n.t("random_person_tooltip"),
    'placement': 'bottom'
})


$("#most-valuable").tooltip({
    title: I18n.t('most_valuable_tooltip'),
    'placement': 'bottom'
})

$("#most-booming").tooltip({
    title: I18n.t('most_booming_tooltip'),
    'placement': 'bottom'
})

$("#most-falling").tooltip({
    title: I18n.t('most_falling_tooltip'),
    'placement': 'bottom'
})


$("#yourprice").tooltip({
    title: I18n.t('your_price_tooltip'),
    'placement': 'bottom'
})

$("#popularity").tooltip({
    title: I18n.t('popularity_tooltip'),
     'placement': 'bottom'
    
})


$("#iportfolio").tooltip({
    title: I18n.t('iportfolio_tooltip')
    
})

$("#stockholders").tooltip({
    title: I18n.t('stock_holders_tooltip')
    
})

$(".search-query").tooltip({
    title: I18n.t('search-query_tooltip'),
    'placement': 'bottom'
    
})

setinterval_id = window.setInterval (function(){
    $.get("/profiles/#{current_user.nickname}.json", 
        (function(data){
        if (data.user.share_price) {
          $("#yourprice").html(I18n.t('your_stock_price') + ' $' + data.user.share_price.toMoney());
          $("#yourmoney").html(I18n.t('your_money') + ' $' + data.user.money.toMoney());
          clearInterval(setinterval_id);
        }
        }), 
        "json"
    );
}, 1000);