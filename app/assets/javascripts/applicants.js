$(document).ready(ready);

function ready() {
    $("button#initial"          ).on("click", filterApplicants);
    $("button#all"              ).on("click", showAllApplicants);
    $("tr.applicant"            ).filter(shouldHide).hide()
    $("form.permahide"          ).on("submit", markRowHidden("permahide"));
    $("form.hide_until_active"  ).on("submit", markRowHidden("hide_until_active"));
    $("button.show_permahidden" ).on("click",  showRows('permahide'));
    $("button.show_inactive"    ).on("click",  showRows('hide_until_active'));
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

function markRowHidden(dataAttribute) {
  return function() {
    var tr = $(this).closest('tr');
    tr.data(dataAttribute, true);
    tr.hide();
  }
}

function showRows(dataAttribute) {
    return function() {
        var allRows    = $('tr.applicant');
        var rowsToShow = allRows.filter(function() {
          return $(this).data(dataAttribute);
        });
        allRows.hide();
        rowsToShow.show();
    }
}
