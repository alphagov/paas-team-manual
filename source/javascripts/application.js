//= require govuk_tech_docs

$(document).ready(function() {
    /*
    * Adds Element BEFORE NeighborElement
    * Via: https://stackoverflow.com/a/32135318
    */
    Element.prototype.appendBefore = function(element) {
    element.parentNode.insertBefore(this, element);
    }, false;

    var gcseSearchboxElement = document.createElement('div');
    gcseSearchboxElement.innerHTML = '<gcse:search></gcse:search>';
    gcseSearchboxElement.appendBefore(document.getElementById('toc'));

    var cx = '016732226562729984830:itmwnemplk4';
        var gcse = document.createElement('script');
        gcse.type = 'text/javascript';
        gcse.async = true;
        gcse.src = 'https://cse.google.com/cse.js?cx=' + cx;
        var s = document.getElementsByTagName('script')[0];
        s.parentNode.insertBefore(gcse, s);
});
