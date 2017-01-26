/**
 * Created by federico on 1/24/17.
 */

function addPermission() {
    var $role = $('#permission_role');
    var organization = $('#permission_organization').val();
    var content = $('#permission_content').val();
    var grant = $role.val() === 'owner' ? '*' : organization + '/' + content;
    addGrantToRole($role, grant)
}

function addGrantToRole($role, grant) {
    var separator = ':';
    var grantsInput = $('input[name="user[permissions][' + $role.val() + ']"]');

    if (grantsInput.length !== 0) {
        var grants = grantsInput.get(0).value.split(separator);
        if (!hasGrant(grants, grant)) grants.push(grant);
        grantsInput.val(grants.join(separator));
    } else {
        addInput($role, grant);
    }
}

function addInput($role, grant) {
    var rolesFieldSet = [
        '<fieldset class="fieldset_' + $role.val() + '">',
        '<label for="">' + $role.find(':selected').text() + '</label>',
        '<input type="text" name="user[permissions][' + $role.val() + ']" value="' + grant + '" class="form-control" readonly>',
        '</fieldset>'
    ].join('\n');

    $('#permissions_list').append(rolesFieldSet);
}

function hasGrant(grants, grant) {
    return grants.some(function (g) {
        return g === grant;
    });
}