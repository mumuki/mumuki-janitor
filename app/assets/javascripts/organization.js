/**
 * Created by federico on 1/24/17.
 */

function addBook() {
    var parent = $('label[for="books"]').parent();
    var inputGroup = parent.find('.input-group').last().clone();
    var input = inputGroup.find('input');
    input.val('');
    parent.find('.books').append(inputGroup);
    input.focus();
}

function removeBook(el) {
    var inputGroup = $(el).parent();
    var parent = inputGroup.parent();
    if (parent.find('.input-group').length > 1) {
        inputGroup.remove();
    } else {
        inputGroup.find('input').val('');
    }
}