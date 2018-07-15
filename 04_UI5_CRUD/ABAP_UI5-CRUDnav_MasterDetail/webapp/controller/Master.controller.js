sap.ui.define([
	"sap/ui/core/mvc/Controller"
], function(Controller) {
	"use strict";

	return Controller.extend("test_MasterDetailTable.controller.Master", {
		
		onInit: function() {

			this.getView().setModel(this.getOwnerComponent().getModel("employees"));
			
		},
		
		// onNavToDetail : function (oEvent){
		// 	this.getOwnerComponent().getRouter().navTo("detail", {
		// 		detailId : 3 //oCtx.getProperty("detailId")
		// 	});
		// }
		
		onNavToDetail : function (oEvent){
			var oItem = oEvent.getSource().getSelectedItem();
			var oCtx = oItem.getBindingContext();
			var oId = oCtx.getProperty("Carrier") + '-' + oCtx.getProperty("IdEmployee"); //oCtx.getPath() - prepare detailId for URL /detail/{detailId}
			
			this.getOwnerComponent().getRouter().navTo("detail", {
				detailId : oId
			});
		}
		
	});
});