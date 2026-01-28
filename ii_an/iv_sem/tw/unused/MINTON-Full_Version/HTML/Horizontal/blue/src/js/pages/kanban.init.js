/*
Template Name: Minton - Responsive Bootstrap 4 Admin Dashboard
Author: CoderThemes
Website: https://coderthemes.com/
Contact: support@coderthemes.com
File: Kanban Board init js
*/

! function($) {
	"use strict";

	var KanbanBoard = function() {
		this.$body = $("body")
	};

	$("#upcoming, #inprogress, #completed").sortable({
		connectWith: ".tasklist",
		placeholder: 'task-placeholder',
		forcePlaceholderSize: true,
		update: function (event, ui) {

			var todo = $("#todo").sortable("toArray");
			var inprogress = $("#inprogress").sortable("toArray");
			var completed = $("#completed").sortable("toArray");
		}
	}).disableSelection();

	//initializing various charts and components
	KanbanBoard.prototype.init = function() {
		
	},

	//init KanbanBoard
	$.KanbanBoard = new KanbanBoard, $.KanbanBoard.Constructor =
	KanbanBoard

}(window.jQuery),

//initializing KanbanBoard
function($) {
	"use strict";
	$.KanbanBoard.init()
}(window.jQuery);