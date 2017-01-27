/**
 * Created by federico on 1/24/17.
 */

function addPermission() {
    var $role = $('#permission_role');
    var organization = $('#permission_organization').val();
    var content = $('#permission_content').val();
    var grant = $role.val() === 'owner' ? '*' : organization + '/' + content;
    addGrantToRole($role, grant);
    addFaTimes();
}

function removePermission(e) {
    var target = e.target;
    var grantToRemove = e.item;

    var fieldset = $(target).parents('[id^="fieldset_"]');
    var grantsInput = fieldset.find('input[data-role="tagsinput"]');

    var grants = grantsInput.val().split(':');

    var newGrants = grants.filter(function (g) {
        return g !== grantToRemove;
    });
    grantsInput.val(newGrants.join(':'));

    if (newGrants.length === 0) fieldset.remove();
}

function addGrant(grantsInput, grant) {
    var separator = ':';
    var grants = grantsInput.get(0).value.split(separator);
    if (!hasGrant(grants, grant)) {
        grants.push(grant);
        addGrantTag(grantsInput, grant);
    }
    grantsInput.val(grants.join(separator));
}

function addGrantTag(grantsInput, grant) {
    var bootstrapTagsInput = grantsInput.parent().find('.bootstrap-tagsinput > input');
    bootstrapTagsInput.val(grant);
    var e = jQuery.Event("keypress");
    e.which = 13;
    e.keyCode = 13;
    bootstrapTagsInput.trigger(e);
}

function addGrantToRole($role, grant) {
    var grantsInput = $('input[name="user[permissions][' + $role.val() + ']"]');

    grantsInput.length !== 0 ? addGrant(grantsInput, grant) : addInput($role, grant);
}

function addInput($role, grant) {
    var rolesFieldSet = [
        '<fieldset id="fieldset_' + $role.val() + '">',
        '<label for="">' + $role.find(':selected').text() + '</label>',
        '<input type="text" name="user[permissions][' + $role.val() + ']" value="' + grant + '" class="form-control" readonly data-role="tagsinput">',
        '</fieldset>'
    ].join('\n');

    $('#permissions_list').append(rolesFieldSet);
    var input = $('input[name="user[permissions][' + $role.val() + ']"]');
    input.tagsinput();
    input.on('beforeItemRemove', removePermission);
}

function hasGrant(grants, grant) {
    return grants.some(function (g) {
        return g === grant;
    });
}

function addFaTimes() {
    var spans = $('span[data-role="remove"]:not(:has(i))');
    spans.append('<i class="fa fa-fw fa-times" style="cursor: pointer"></i>');
}

$(document).ready(function () {
    addFaTimes();
    $('input').on('beforeItemRemove', removePermission);
});