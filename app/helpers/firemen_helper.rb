module FiremenHelper
  
  def js_for_status
    javascript_tag("
      $(function() {
        $('#fireman_status').change(function() {
          if ($(this).val() == 1)
            $('#grades').hide();
          else
            $('#grades').show();
        });
      });
    ")
  end
  
  def style_for_grade(fireman)
    fireman.status == 1 ? 'display:none;' : ''
  end
  
end