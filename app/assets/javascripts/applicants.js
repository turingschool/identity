$(document).ready(ready);

function ready() {
    $("button#initial"                              ).on("click", filterApplicants);
    $("button#all"                                  ).on("click", showAllApplicants);
    $("tr.applicant"                                ).filter(shouldHide).hide()
    $("form.permahide"                              ).on("submit", hideRow("permahide"));
    $("form.hide_until_active"                      ).on("submit", hideRow("hide_until_active"));
    $("label.show_permahidden input[type=checkbox]" ).change(toggleRows('permahide'));
    $("label.show_inactive    input[type=checkbox]" ).change(toggleRows('hide_until_active'));
}

function toggleRows(dataAttribute) {
  return function() {
    var rows = $('tr.applicant').filter(function() {
      return $(this).data(dataAttribute);
    });

    if(this.checked)
      rows.show();
    else
      rows.hide();
  }
}

function shouldHide() {
    _this = $(this);
    return _this.data('permahide') || _this.data('hide_until_active');
}

function filterApplicants() {
    var initial = $(this).text().replace(/\s/g, "");
    var filterSelector = "tr#" + initial + "," + "tr#head";

    var trs = $("tr.applicant");
    trs.show();
    trs.not(filterSelector).hide();
    trs.filter(shouldHide).hide();
}

function showAllApplicants() {
    var trs = $("tr");
    trs.show();
    trs.not(shouldHide).hide();
}

function hideRow(dataAttribute) {
  return function() {
    var tr = $(this).closest('tr');
    tr.data(dataAttribute, true);
    tr.hide();
  }
}
