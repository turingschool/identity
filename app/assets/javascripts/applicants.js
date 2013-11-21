$(document).ready(ready);

function ready() {
    filterApplicants();
    showAllApplicants();
}

function filterApplicants() {
    $("button#initial").on("click", function(){
        var initial = $(this).text().replace(/\s/g, "");
        var filterSelector = "tr#" + initial + "," + "tr#head";

        $("tr").show();
        $("tr").filter("tr").not(filterSelector).hide();
    });
}

function showAllApplicants() {
    $("button#all").on("click", function(){
        $("tr").show();
    });
}