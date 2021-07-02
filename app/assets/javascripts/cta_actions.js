function openLinkInNewTab(e){
  window.open(this.href, '_blank');
  return false;
}

function agentContactForm(agent_id){
  $.ajax({
    url: '/featured_agents/'+agent_id+'/contact',
    type: 'get',
    dataType: 'json',
    success: function(response){
      $('#remote-container').html(response.contact_form_html);
      if($('.contact-agent-modal').length > 0){
        $('.contact-agent-modal').slideDown(200);
        $('.closeContact').click(function(e) {
          e.stopPropagation();
          $('.contact-agent-modal').slideUp(200);
        });
      }else{
        $('#contactAgentModal').modal('show');
      }
    },
    error: function(res){
      //console.log(res);
    }
  });
} 

function showLeasingContactPopup(building_id){
  $.ajax({
    url: '/contacts/new?building_id='+building_id,
    type: 'get',
    dataType: 'script',
    success: function(response){}
  });
}

function showActiveListingsPopup(building_id){
  $('#remote-container').html('');
  var filter_params = {
    amenities:        $('#list_amenities').val(),
    listing_bedrooms: $('#list_bedrooms').val(),
    min_price:        $('#list_min_price').val(),
    max_price:        $('#list_max_price').val(),
  };

  $.ajax({
    url: '/listings/show_more',
    type: 'get',
    dataType: 'script',
    data: { 
            building_id: building_id, 
            listing_type: 'active', 
            filter_params: filter_params 
          },
    success: function(response){}
  });
}