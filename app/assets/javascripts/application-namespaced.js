AppJS = {
  shared : {
    init : function(){
      AppJS.shared.initCosts();
    },
    
    initCosts: function(){
      $('#cost_periodicity').change(function() {
        console.log( $( "#cost_periodicity option:selected").val() );
        if( $( "#cost_periodicity option:selected").val() == '0' ) {
          $('#end_date').hide();
        } else {
          $('#end_date').show();
        }
      });
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