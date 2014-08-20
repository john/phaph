AppJS = {
  shared : {
    init : function(){
      // AppJS.shared.initComments();
      AppJS.shared.initSearch();
    },
    
    initSearch: function(){
      $('.all-or-yours-not-selected').click(function(e){
        e.preventDefault();
        
        var selected = $.trim($(this).text());
        var not_selected = $('.all-or-yours-not-selected')
        
        $('.search_scope').val(selected);
        $('.all-or-yours').text( selected );
        $('.all-or-yours').append( ' <span class="caret"></span>' );
        
        if( selected == 'Yours' ) {
          $('.all-or-yours-not-selected').text( 'All' );
          
        } else {
          $('.all-or-yours-not-selected').text( 'Yours' );
        }
        
      });
    },
    
    initComments: function(){      
      $( "#comment_body" ).focus(function() {
        // $( "#comment_body" ).css('height', '120px');
        $( "#comment_save" ).fadeIn();
        return true;
      });

      // $( "#comment_body" ).focusout(function() {
      //   // $( "#comment_body" ).css('height', '40px');
      //   $( "#comment_save" ).css('display', 'none');
      //   return true;
      // });
      // $('#new_comment').submit(function(){
      //   $( "#comment_save" ).css('display', 'none');
      //   $( "#comment_save" ).fadeOut();
      // })
    }
  }
};

AppJSSetup = {
  execNamespace : function(controller, action, args){
    if (controller !== '' && AppJS[controller] && typeof AppJS[controller][action] == 'function'){
      AppJS[controller][action](args);
    }
  },

  initialize : function(){
    var body = document.body;
    var controller = body.getAttribute( "data-controller" );
    var action = body.getAttribute( "data-action" );

    AppJSSetup.execNamespace('shared', 'init');
    // AppJSSetup.execNamespace(controller, 'init');
    // AppJSSetup.execNamespace(controller, action);
  }
};

$(document).ready(AppJSSetup.initialize);