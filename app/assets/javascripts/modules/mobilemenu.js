function initMobileMenu() {

	var $homeTemplate = $("body.template--pages-home").length,
		$offersTemplate = $("body[class^='template--offers-']").length,
		$inputLocation = $("#search_form_search_location"),
		$inputQuery = $("#search_form_query"),
		$submit = $(".main-search__submit"),
		$header = $(".header-main"),
		smartphone = ($(window).width() < 480);

	$inputLocation.removeClass("visible");

	if ($homeTemplate) {
		return;
	}

	if ($offersTemplate && smartphone) {
		$header.append("<a class='jump-to-tags' href='#tags'>Zum Schlagwortfilter</a>");
	}

	if (Modernizr.touch && smartphone) {

		$inputQuery.click(function() {
			$inputLocation.toggleClass("visible");
			$submit.toggleClass("enlarged");
		});

	}

}

$(document).ready(function () {
	initMobileMenu();
});