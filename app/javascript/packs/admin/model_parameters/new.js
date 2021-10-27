$(document).ready(function () {
    $('.rf_div').hide();
    $('.svm_div').hide();
    $('.lstm_div').hide();
    $('#model_type').on("change",function(){
      if (($('#model_type option:selected').val()) == "lstm"){
        $('.rf_div').prop('disabled', true);
        $('.rf_div').hide();
        $('.svm_div').prop('disabled', true);
        $('.svm_div').hide();
        $('.lstm_div').show();
        $('.lstm_div').prop('disabled',false);
      } else if(($('#model_type option:selected').val()) == "rf"){
        $('.rf_div').prop('disabled', false);
        $('.rf_div').show();
        $('.svm_div').prop('disabled', true);
        $('.svm_div').hide();
        $('.lstm_div').prop('disabled', true);
        $('.lstm_div').hide();
      }else{
        $('.rf_div').prop('disabled', true);
        $('.rf_div').hide();
        $('.svm_div').prop('disabled', false);
        $('.svm_div').show();
        $('.lstm_div').prop('disabled', true);
        $('.lstm_div').hide();
      }
    });
})